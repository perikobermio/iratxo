#include "Ble.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <ArduinoJson.h>

#define SERVICE_UUID           "8ea03f1f-de1b-4c80-bed8-4e4cc24822e2"
#define CHARACTERISTIC_UUID_RX "0e0f8877-e007-4095-ad2e-b85462fc2ae8"
#define CHARACTERISTIC_UUID_TX "3166f32a-a7ce-4e90-a28d-61907aaed70c"

BLECharacteristic *pTxCharacteristic;
bool deviceConnected = false;


Ble::Ble() {
    Serial.println("BLE instance created");
}


Ble::ServerCallbacks* Ble::createServerCallbacks() {
  return new ServerCallbacks();
}
void Ble::ServerCallbacks::onConnect(BLEServer* pServer) {
  deviceConnected = true;
  Serial.println("🔗BLE Connected");
}
void Ble::ServerCallbacks::onDisconnect(BLEServer* pServer) {
  deviceConnected = false;
  pServer->startAdvertising();
  Serial.println("BLE Disconnected");
}


void Ble::setWriteCallback(std::function<void(std::string)> cb) {
  writeCallback = cb;
}
Ble::RXCallbacks* Ble::createRXCallbacks() {
  return new RXCallbacks(writeCallback);
}
Ble::RXCallbacks::RXCallbacks(std::function<void(std::string)> cb) : callback(cb) {}
void Ble::RXCallbacks::onWrite(BLECharacteristic *pCharacteristic) {
  if (callback) {
    String val = pCharacteristic->getValue();
    std::string value = std::string(val.c_str());
    callback(value);
  }
}



void Ble::connect() {
    set();
    Serial.println("BLE Connected");
}

void Ble::set() {
    BLEDevice::init("IRATXO");

    BLEServer *pServer = BLEDevice::createServer();
    pServer->setCallbacks(createServerCallbacks());

    BLEService *pService = pServer->createService(SERVICE_UUID);

    pTxCharacteristic = pService->createCharacteristic(CHARACTERISTIC_UUID_TX, BLECharacteristic::PROPERTY_NOTIFY);

    pTxCharacteristic->addDescriptor(new BLE2902());

    BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(CHARACTERISTIC_UUID_RX, BLECharacteristic::PROPERTY_WRITE);
    pRxCharacteristic->setCallbacks(createRXCallbacks());

    pService->start();

    BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(SERVICE_UUID);
    pAdvertising->start();
}

void Ble::sendNotify(JsonDocument json) {
  if (deviceConnected) {
    String responseString;

    serializeJson(json, responseString);
    pTxCharacteristic->setValue(responseString.c_str());
    pTxCharacteristic->notify();
  }
}
