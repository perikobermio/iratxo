#include "Sim.h"
#include <ArduinoJson.h>

#include <ArduinoHttpClient.h>

#define TINY_GSM_MODEM_SIM800
#define OUTLIGHT_PIN 2
#define SWITCH_OUTLIGHT_PIN 39

#include <TinyGsmClient.h>
HardwareSerial SerialAT(1);
TinyGsm modem(SerialAT);
TinyGsmClient client(modem);
HttpClient http(client, "api.ebu.freemyip.com", 80);

int rx_pin = 13;
int tx_pin = 5;
String api = "/api/iratxo/data";

bool connected = false;
JsonDocument data;

// Constructor
Sim::Sim() {
    Serial.println("SIM instance created");
}

void Sim::setWriteCallback(std::function<void(String)> cb) {
  writeCallback = cb;
}

void Sim::connect() {
  SerialAT.begin(9600, SERIAL_8N1, rx_pin, tx_pin);
  modem.restart();

  if (modem.gprsConnect("simbase", "", "")) {
    Serial.print("GPRS Connected: "); Serial.print(" CSQ: "); Serial.println(modem.getSignalQuality());
    connected = true;
  } else {
    Serial.println("ERROR: GPRS connection failed!");
  }
}

void Sim::read() {
  if(!connected) Sim::connect();

  http.get(api);

  if(http.responseStatusCode() == 200) {
    DeserializationError error = deserializeJson(data, http.responseBody());

    if (!error) {
      String command = "";

      if(data["data"]["OUT_LIGHT"] == 1)       command = "OUT_LIGHT_ON";
      else if(data["data"]["OUT_LIGHT"] == 0)  command = "OUT_LIGHT_OFF";

      if(writeCallback) writeCallback(command);
    } else {
      Serial.print("SIM error: "); Serial.println(error.c_str());
    }

    Serial.println("SIM read OK");
  } else {
    Serial.print("SIM READ error: "); Serial.println(http.responseStatusCode());
  }
}