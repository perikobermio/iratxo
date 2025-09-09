#include "Sim.h"
#include <WiFi.h>
#include <ArduinoJson.h>
#include <ArduinoHttpClient.h>
#include <Preferences.h>

#define TINY_GSM_MODEM_SIM800
#define OUTLIGHT_PIN 2
#define SWITCH_OUTLIGHT_PIN 39

#include <TinyGsmClient.h>
HardwareSerial SerialAT(1);
TinyGsm modem(SerialAT);
TinyGsmClient client(modem);
WiFiClient wifi;

int wifi_timeout      = 5;
const char* ssid      = "Jesukristo";
const char* password  = "Bermio1982";

int rx_pin            = 13;
int tx_pin            = 5;

String host           = "api.ebu.freemyip.com";
String api            = "/api/iratxo/data";
String cts            = "/api/iratxo/cts";

bool                  connected = false;
JsonDocument          data;
extern Preferences    prefs;

Sim::Sim() {
    Serial.println("SIM instance created");
}

void Sim::setWriteCallback(std::function<void(String)> cb) {
  writeCallback = cb;
}

void Sim::connect() {

  prefs.begin("iratxo", false);
  WiFi.begin(prefs.getString("wifi_ssid", "Jesukristo"), prefs.getString("wifi_pass", "Bermio1982"));
  prefs.end();

  unsigned long start = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - start < wifi_timeout * 1000) delay(500);

  if (WiFi.status() == WL_CONNECTED) {
    Serial.print("WIFI Connected: "); Serial.print(" dBm: "); Serial.println(WiFi.RSSI());
    connected = true;
  } else {
    SerialAT.begin(9600, SERIAL_8N1, rx_pin, tx_pin);
    modem.restart();

    if (modem.gprsConnect("simbase", "", "")) {
      Serial.print("GPRS Connected: "); Serial.print(" CSQ: "); Serial.println(modem.getSignalQuality());
      connected = true;
    } else {
      Serial.println("ERROR: GPRS connection failed!");
    }
  }

}

void Sim::read(unsigned long last_update ) {
  if(!connected) Sim::connect();

  HttpClient http((WiFi.status() == WL_CONNECTED) ? static_cast<Client&>(wifi) : static_cast<Client&>(client), host, 80);

  http.get(api);

  if(http.responseStatusCode() == 200) {
    DeserializationError error = deserializeJson(data, http.responseBody());

    if (!error && data["last_update"] > last_update) {
      std::vector<String> commands;

      if(data["data"]["OUT_LIGHT"] == 1)       commands.push_back("OUT_LIGHT_ON");
      else if(data["data"]["OUT_LIGHT"] == 0)  commands.push_back("OUT_LIGHT_OFF");

      for(const auto& command : commands) {
        if(writeCallback) writeCallback(command);
      }
    }

    Serial.println("SIM read Finished");
  } else {
    Serial.print("SIM READ error: "); Serial.println(http.responseStatusCode());
  }
}

unsigned long Sim::now() {
  if(!connected) return static_cast<unsigned long>(0);

  HttpClient http((WiFi.status() == WL_CONNECTED) ? static_cast<Client&>(wifi) : static_cast<Client&>(client), host, 80);
  http.get(cts);

  if(http.responseStatusCode() == 200) {
    DeserializationError error = deserializeJson(data, http.responseBody());
    return static_cast<unsigned long>(data["timestamp"].as<unsigned long>());
  }

  Serial.print("SIM NOW() error: "); Serial.println(http.responseStatusCode());
  return static_cast<unsigned long>(0);
}