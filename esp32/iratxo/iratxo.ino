#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <ArduinoJson.h>

#define SERVICE_UUID           "8ea03f1f-de1b-4c80-bed8-4e4cc24822e2"
#define CHARACTERISTIC_UUID_RX "0e0f8877-e007-4095-ad2e-b85462fc2ae8"
#define CHARACTERISTIC_UUID_TX "3166f32a-a7ce-4e90-a28d-61907aaed70c"

#define OUTLIGHT_PIN 27

BLECharacteristic *pTxCharacteristic;
bool deviceConnected = false;

class ServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("🔗 Connected");
    pTxCharacteristic->setValue("Kaixo! IRATXO prest dago ;-)");
    pTxCharacteristic->notify();
  }

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    pServer->startAdvertising();
    Serial.println("❌ Disconnected");
  }
};

class RXCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String command = pCharacteristic->getValue().c_str();
    JsonDocument response;
    String responseString;
    
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
      Serial.println("READING");
      Serial.println(digitalRead(OUTLIGHT_PIN));
    } else {
      Serial.println("Command error");
    }

    response["status"] = "OK";
    serializeJson(response, responseString);

    if (deviceConnected) {
      pTxCharacteristic->setValue(responseString.c_str());
      pTxCharacteristic->notify();
    }
    
  }
};

void setup() {
  Serial.begin(115200);
  
  pinMode(OUTLIGHT_PIN, OUTPUT);
  digitalWrite(OUTLIGHT_PIN, HIGH);
  //Serial.println(digitalRead(OUTLIGHT_PIN));

  ////////////////////////////////////////

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

  Serial.println("IRATXO BLE prest dago ;-)");
}

void loop() {
  delay(1000);
}
