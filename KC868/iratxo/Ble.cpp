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

// Constructor
Ble::Ble() {
    Serial.println("BLE instance created");
}

// ServerCallbacks methods
void Ble::ServerCallbacks::onConnect(BLEServer* pServer) {
  deviceConnected = true;
  Serial.println("BLE Connected");
}

void Ble::ServerCallbacks::onDisconnect(BLEServer* pServer) {
  deviceConnected = false;
  pServer->startAdvertising();
  Serial.println("BLE Disconnected");
}

// RXCallbacks constructor and methods
Ble::RXCallbacks::RXCallbacks(std::function<void(String)> cb) : callback(cb) {}

void Ble::RXCallbacks::onWrite(BLECharacteristic *pCharacteristic) {
  if (callback) {
    String value = pCharacteristic->getValue().c_str();
    if(callback) callback(value);
  }
}

// Create callbacks helpers
Ble::ServerCallbacks* Ble::createServerCallbacks() {
  return new ServerCallbacks();
}

Ble::RXCallbacks* Ble::createRXCallbacks() {
  return new RXCallbacks(writeCallback);
}

void Ble::setWriteCallback(std::function<void(String)> cb) {
  writeCallback = cb;
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

  pTxCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID_TX, BLECharacteristic::PROPERTY_NOTIFY);
  pTxCharacteristic->addDescriptor(new BLE2902());

  BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID_RX, BLECharacteristic::PROPERTY_WRITE);
  pRxCharacteristic->setCallbacks(createRXCallbacks());

  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->start();
}

void Ble::sendNotify(const ArduinoJson::JsonDocument& json) {
  if (deviceConnected) {
    String responseString;
    serializeJson(json, responseString);
    pTxCharacteristic->setValue(responseString.c_str());
    pTxCharacteristic->notify();
  }
}

bool Ble::isConnected() {
  return deviceConnected;
}
