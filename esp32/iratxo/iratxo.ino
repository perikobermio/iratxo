#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define SERVICE_UUID           "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID_RX "12345678-1234-1234-1234-1234567890ac"
#define CHARACTERISTIC_UUID_TX "12345678-1234-1234-1234-1234567890ad"

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
    Serial.println("❌ Disconnected");
  }
};

class RXCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String command = pCharacteristic->getValue().c_str();  // conversión correcta
    command.trim();
    Serial.print("RX: ");
    Serial.println(command);

    if (command == "OUT_LIGHT_ON") {
      Serial.println("Encendiendo LED");
      // digitalWrite(LED_BUILTIN, HIGH);
    } else if (command == "OUT_LIGHT_OFF") {
      Serial.println("Apagando LED");
      // digitalWrite(LED_BUILTIN, LOW);
    } else {
      Serial.println("Command error");
    }
  }
};

void setup() {
  Serial.begin(115200);
  // pinMode(LED_BUILTIN, OUTPUT); // si usas un LED

  BLEDevice::init("IRATXO"); // Nombre BLE

  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  pTxCharacteristic = pService->createCharacteristic(
                        CHARACTERISTIC_UUID_TX,
                        BLECharacteristic::PROPERTY_NOTIFY
                      );

  pTxCharacteristic->addDescriptor(new BLE2902());

  BLECharacteristic *pRxCharacteristic = pService->createCharacteristic(
                                           CHARACTERISTIC_UUID_RX,
                                           BLECharacteristic::PROPERTY_WRITE
                                         );
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
