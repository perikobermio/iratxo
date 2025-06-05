#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <ArduinoJson.h>

#define SERVICE_UUID           "8ea03f1f-de1b-4c80-bed8-4e4cc24822e2"
#define CHARACTERISTIC_UUID_RX "0e0f8877-e007-4095-ad2e-b85462fc2ae8"
#define CHARACTERISTIC_UUID_TX "3166f32a-a7ce-4e90-a28d-61907aaed70c"

#define OUTLIGHT_PIN 27
#define SWITCH_OUTLIGHT_PIN 5

unsigned long lastOutLightDebounceTime = 0;
const unsigned long outLightdebounceDelay = 2000;

BLECharacteristic *pTxCharacteristic;
bool deviceConnected = false;




class ServerCallbacks : public BLEServerCallbacks {
  
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("🔗BLE Connected");
  }

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    pServer->startAdvertising();
    Serial.println("BLE Disconnected");
  }
};

void sendNotify(JsonDocument json) {
  if (deviceConnected) {
    String responseString;

    serializeJson(json, responseString);
    pTxCharacteristic->setValue(responseString.c_str());
    pTxCharacteristic->notify();
    Serial.println(responseString.c_str());
  }
}

class RXCallbacks : public BLECharacteristicCallbacks {
  
  void onWrite(BLECharacteristic *pCharacteristic) {
    String command = pCharacteristic->getValue().c_str();
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
    sendNotify(response);
  }
};

void setPins() {
  pinMode(OUTLIGHT_PIN, OUTPUT);
  pinMode(SWITCH_OUTLIGHT_PIN, INPUT_PULLUP);
  digitalWrite(OUTLIGHT_PIN, HIGH);
}

void setBLE() {
  BLEDevice::init("IRATXO");

  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  pTxCharacteristic = pService->createCharacteristic(CHARACTERISTIC_UUID_TX, BLECharacteristic::PROPERTY_NOTIFY);

  pTxCharacteristic->addDescriptor(new BLE2902());

  BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(CHARACTERISTIC_UUID_RX, BLECharacteristic::PROPERTY_WRITE);
  pRxCharacteristic->setCallbacks(new RXCallbacks());

  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->start();
}

void readSwitchOutLight() {

  if (digitalRead(SWITCH_OUTLIGHT_PIN) == LOW) {
    if ((millis() - lastOutLightDebounceTime) > outLightdebounceDelay) {
    
      bool currentState = digitalRead(OUTLIGHT_PIN);
      bool newState = !currentState;

      digitalWrite(OUTLIGHT_PIN, newState);
      lastOutLightDebounceTime = millis();

      // Notificar por BLE
      if (deviceConnected) {
        JsonDocument response;

        response["command"]       = newState ? "OUT_LIGHT_ON" : "OUT_LIGHT_OFF";
        response["message"]       = newState ? "Kanpoko argia piztuta (switch)" : "Kanpoko argia itzalita (switch)";
        response["status"]        = "OK";
        response["OUT_LIGHT"]     = (int)newState;

        sendNotify(response);
      }
    }
  }


}

///////////////////////////////////

void setup() {
  Serial.begin(115200);

  setPins();
  setBLE();

}

void loop() {
  readSwitchOutLight();
  delay(100);
}
