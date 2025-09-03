#include <ArduinoJson.h>
#include "Ble.h"
#include "Sim.h"

#define OUTLIGHT_PIN 2
#define SWITCH_OUTLIGHT_PIN 39

unsigned long lastOutLightDebounceTime    = 0;
const unsigned long outLightdebounceDelay = 2000;

Ble ble;
Sim sim;

void setPins() {
  pinMode(OUTLIGHT_PIN, OUTPUT);
  pinMode(SWITCH_OUTLIGHT_PIN, INPUT);
  digitalWrite(OUTLIGHT_PIN, LOW);
}

void readSwitchOutLight() {
  if (digitalRead(SWITCH_OUTLIGHT_PIN) == LOW) {
    if ((millis() - lastOutLightDebounceTime) > outLightdebounceDelay) {
      lastOutLightDebounceTime = millis();
      setWriteCallback(!digitalRead(OUTLIGHT_PIN) ? "OUT_LIGHT_ON" : "OUT_LIGHT_OFF");
    }
  }
}

void setWriteCallback(String command) {
  JsonDocument response;

  command.trim();
  response["command"] = command;

  if (command == "OUT_LIGHT_ON") {
    digitalWrite(OUTLIGHT_PIN, HIGH);
    response["message"]     = "Kanpoko argia piztuta";
    response["OUT_LIGHT"]   = 1;

  } else if (command == "OUT_LIGHT_OFF") {
    digitalWrite(OUTLIGHT_PIN, LOW);
    response["message"]     = "Kanpoko argia itzalita";
    response["OUT_LIGHT"]   = 0;

  } else if (command == "READ_VALUES") {
    response["message"]     = "Datuak ongi irakurrita";
    response["OUT_LIGHT"]   = digitalRead(OUTLIGHT_PIN);

  } else if (command == "SYNC_TOGGLE") {
    response["message"]     = "Sinkronizazioa aldatu";

  } else {
    response["message"]     = "COMMAND error";
  }

  response["status"] = "OK";
  ble.sendNotify(response);
}

void setup() {
  Serial.begin(115200);

  setPins();

  ble.setWriteCallback([](String value) {
    setWriteCallback(value);
  });

  sim.setWriteCallback([](String value) {
    setWriteCallback(value);
  });

  ble.connect();
  //sim.connect();

  if(sim.connected) {
    //sim.read();
  }
}

void loop() {
  readSwitchOutLight();

  delay(10);
}
