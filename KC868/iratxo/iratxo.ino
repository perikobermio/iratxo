#include <ArduinoJson.h>
#include "Ble.h"

#define OUTLIGHT_PIN 2
#define SWITCH_OUTLIGHT_PIN 39

unsigned long lastOutLightDebounceTime = 0;
const unsigned long outLightdebounceDelay = 2000;

Ble ble;

void setPins() {
  pinMode(OUTLIGHT_PIN, OUTPUT);
  pinMode(SWITCH_OUTLIGHT_PIN, INPUT);
  digitalWrite(OUTLIGHT_PIN, LOW);
}

void readSwitchOutLight() {
  if (digitalRead(SWITCH_OUTLIGHT_PIN) == LOW) {
    if ((millis() - lastOutLightDebounceTime) > outLightdebounceDelay) {

      bool currentState = digitalRead(OUTLIGHT_PIN);
      bool newState = !currentState;

      digitalWrite(OUTLIGHT_PIN, newState);
      lastOutLightDebounceTime = millis();

      JsonDocument response;

      response["command"]   = newState ? "OUT_LIGHT_ON" : "OUT_LIGHT_OFF";
      response["message"]   = newState ? "Kanpoko argia piztuta (switch)" : "Kanpoko argia itzalita (switch)";
      response["status"]    = "OK";
      response["OUT_LIGHT"] = (int)newState;

      ble.sendNotify(response);
    }
  }
}

void setWriteCallback(String command) {
  JsonDocument response;

  command.trim();
  response["command"] = command;

  if (command == "OUT_LIGHT_ON") {
    digitalWrite(OUTLIGHT_PIN, HIGH);
    response["message"] = "Kanpoko argia piztuta";
  } else if (command == "OUT_LIGHT_OFF") {
    digitalWrite(OUTLIGHT_PIN, LOW);
    response["message"] = "Kanpoko argia itzalita";
  } else if (command == "READ_VALUES") {
    response["message"]   = "Datuak ongi irakurrita";
    response["OUT_LIGHT"] = digitalRead(OUTLIGHT_PIN);
  } else {
    response["message"] = "COMMAND error";
  }

  response["status"] = "OK";
  ble.sendNotify(response);
}

void setup() {
  Serial.begin(115200);

  setPins();

  ble.setWriteCallback([](std::string value) {
    setWriteCallback(String(value.c_str()));
  });

  ble.connect();
}

void loop() {
  readSwitchOutLight();
  delay(10);
}
