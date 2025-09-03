#ifndef BLE_H
#define BLE_H

#include <Arduino.h>
#include <BLEServer.h>
#include <BLECharacteristic.h>
#include <functional>
#include <string>
#include <ArduinoJson.h>

class Ble {
  public:
    Ble();
    void connect();
    bool isConnected();
    void setWriteCallback(std::function<void(String)> cb);
    void sendNotify(const ArduinoJson::JsonDocument& response);

  private:
    void set();

    class ServerCallbacks : public BLEServerCallbacks {
      protected:
        void onConnect(BLEServer* pServer) override;
        void onDisconnect(BLEServer* pServer) override;
    };

    class RXCallbacks : public BLECharacteristicCallbacks {
      public:
        RXCallbacks(std::function<void(String)> cb);
      protected:
        void onWrite(BLECharacteristic *pCharacteristic) override;
      private:
        std::function<void(String)> callback;
    };

    ServerCallbacks* createServerCallbacks();
    RXCallbacks* createRXCallbacks();
    std::function<void(String)> writeCallback;
};

#endif
