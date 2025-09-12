#include <ArduinoJson.h>
#include <Preferences.h>
#include <RTClib.h>
#include "Ble.h"
#include "Sim.h"

#define OUTLIGHT_PIN 2
#define SWITCH_OUTLIGHT_PIN 39

unsigned long         lastOutLightDebounceTime  = 0;
const unsigned long   outLightdebounceDelay     = 2000;
unsigned long         last_update               = 0;
int                   refresh                   = 5;
static unsigned long  lastRead                  = 0;

Ble ble;
Sim sim;
Preferences prefs;
RTC_DS3231 rtc;

void setPins() {
  pinMode(OUTLIGHT_PIN, OUTPUT);
  pinMode(SWITCH_OUTLIGHT_PIN, INPUT);
  digitalWrite(OUTLIGHT_PIN, LOW);
}

void setClock() {
  Wire.begin(4, 16);

  if (!rtc.begin()) {
    Serial.println("No se detecta el RTC DS3231");
    while (1);
  }

  if (rtc.lostPower()) {
    Serial.println("RTC sin hora, ajustando...");
    rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
  }
}

void setPrefs(JsonDocument* data) {
  prefs.begin("iratxo", false);
  for (JsonPair kv : (*data)["data"].as<JsonObject>()) {
    prefs.putString(kv.key().c_str(), kv.value().as<String>());
  }
  prefs.end();
}

void setWriteCallback(String command, JsonDocument* data = nullptr) {
  JsonDocument response;

  command.trim();
  response["command"] = command;
  response["status"]  = "OK";

  if (command == "OUT_LIGHT_ON") {
    digitalWrite(OUTLIGHT_PIN, HIGH);
    response["message"]     = "Kanpoko argia piztuta";
    response["OUT_LIGHT"]   = 1;

  } else if (command == "OUT_LIGHT_OFF") {
    digitalWrite(OUTLIGHT_PIN, LOW);
    response["message"]     = "Kanpoko argia itzalita";
    response["OUT_LIGHT"]   = 0;
    response["WIFI_SSID"]   = prefs.getString("wifi_ssid", "Jesukristo");

  } else if (command == "READ_VALUES") {
    response["message"]     = "Datuak ongi irakurrita";
    response["OUT_LIGHT"]   = digitalRead(OUTLIGHT_PIN);

  } else if (command == "SET_PREFS") {
    response["message"]     = "Preferentziak aldatu";
    if(data) setPrefs(data);

  } else {
    response["message"]     = "COMMAND error";
  }

  Serial.println(command);
  updateLastUpdate();
  ble.sendNotify(response);
}

void readSwitchOutLight() {
  if (digitalRead(SWITCH_OUTLIGHT_PIN) == LOW && (millis() - lastOutLightDebounceTime) > outLightdebounceDelay) {
    lastOutLightDebounceTime = millis();
    setWriteCallback(!digitalRead(OUTLIGHT_PIN) ? "OUT_LIGHT_ON" : "OUT_LIGHT_OFF");
  }
}

void updateLastUpdate() {
  DateTime now  = rtc.now();
  last_update   = static_cast<unsigned long>(now.unixtime());
  Serial.print("Updating last_update: "); Serial.println(last_update);
}

void syncLastUpdate() {
  const unsigned long lu = sim.now();
  if(lu > 0) rtc.adjust(DateTime((time_t)lu));
}

void setup() {
  Serial.begin(115200);

  setPins();
  setClock();

  ble.setWriteCallback([](String value) {
    JsonDocument doc;
    DeserializationError error = deserializeJson(doc, value);

    if (error)  setWriteCallback(value);
    else        setWriteCallback(doc["action"].as<String>(), &doc);
  });

  sim.setWriteCallback([](String value) {
    setWriteCallback(value);
  });

  ble.connect();
  sim.connect();

  syncLastUpdate();
  updateLastUpdate();
}

void loop() {
  readSwitchOutLight();

  if(millis() - lastRead >= refresh * 60000) {
    sim.read(last_update);
    lastRead = millis();
  }

  delay(10);
}