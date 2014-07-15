//
//  BTLECentralModel.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import CoreBluetooth

enum BTLECentralState {
    case Connecting
    case Connected
    case PIDReceived
    case PanoramicModeSetup
    case PhotoModeSetup
    case TakePhotoTriggerReceived
    case TakePanoramicTriggerReceived
}


class BTLECentralModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // Delegate:
    var mainViewController:MainViewController?;
    
    
    var data:NSMutableData = NSMutableData();
    var stringReceived:NSString?;
    var centralManager:CBCentralManager?;
    var discoveredPeriperal:CBPeripheral?;
    
    // UUIDs:
    var transferServiceUUID:NSString = "1699DD88-A314-4E04-84DE-6CB7863EA2C0";
    var transferCharacteristicUUID:NSString = "512EA3F8-1209-4095-90E6-302216ED120D";
    
    


    init(mainVC:MainViewController) {
        super.init();
        self.mainViewController = mainVC;
        self.stringReceived = "";
    }
    
    func setupCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil);
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!)  {
        if (central.state != CBCentralManagerState.PoweredOn) {
            println("Bluetooth Not Ready To Use");
        }
        println("Bluetooth is Ready To Use");
        
        // Scan For Avaliable Bluetooth
        scan();
    }
    
    // Scan For Avaliable Bluetooth
    func scan() {
        self.centralManager!.scanForPeripheralsWithServices([CBUUID.UUIDWithString(self.transferServiceUUID)], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]);
        self.NotifyMainViewController(BTLECentralState.Connecting);
    }

    func centralManager(central: CBCentralManager!,
        didDiscoverPeripheral peripheral: CBPeripheral!,
        advertisementData: NSDictionary!,
        RSSI: NSNumber!) {
            println("Discoverd \(peripheral.name) at \(RSSI)");
            // Check to See if this peripheral is the one we already connected
            if (self.discoveredPeriperal != peripheral) {
                // Mark it discovered
                self.discoveredPeriperal = peripheral;
                // Connect to that peripheral
                println("Connect to peripheral");
                self.centralManager!.connectPeripheral(peripheral, options: nil);
            }
    }
    
    func centralManager(central: CBCentralManager!,
        didFailToConnectPeripheral peripheral: CBPeripheral!,
        error: NSError!) {
            println("Failed to connect to \(peripheral), Errror: \(error.localizedDescription)");
    }
    
    func centralManager(central: CBCentralManager!,
        didConnectPeripheral peripheral: CBPeripheral!) {
            println("Peripheral Connected");
            
            // Stop Scan
            self.centralManager!.stopScan();
            println("Scan Stopped");
            
            // Clear the Data
            self.data.length = 0;
            
            peripheral.delegate = self;
            peripheral.discoverServices([CBUUID.UUIDWithString(self.transferServiceUUID)]);
            
    }
    
    // Discover Service, loopthough and get all the characteristic
    func peripheral(peripheral: CBPeripheral!,
        didDiscoverServices error: NSError!) {
            if error {
                println("Error, Discovering Service: \(error.localizedDescription)");
                self.cleanUp();
                return;
            }
            
            // Discover all the characteristics
            // Loop though the service
            
            for service : AnyObject in peripheral.services {
                peripheral.discoverCharacteristics([CBUUID.UUIDWithString(self.transferCharacteristicUUID)], forService: service as CBService);
            }
            
    }
    
    //
    func peripheral(peripheral: CBPeripheral!,
        didDiscoverCharacteristicsForService service: CBService!,
        error: NSError!) {
            if error {
                println("Error, Discovering Characteristics: \(error.localizedDescription)");
                self.cleanUp();
                return;
            }
            
            
            // Subscribe to All the char
            for item: AnyObject in service.characteristics {
                var characteristic:CBCharacteristic = item as CBCharacteristic;
                if (characteristic.UUID.isEqual(CBUUID.UUIDWithString(transferCharacteristicUUID))) {
                    // Has Found the characteristic, need to subsribe to it
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic);
                }
                
            }
            
            self.NotifyMainViewController(BTLECentralState.Connected);
            
            // Complete! Need to wait for the data to come in
    }
    
    // When Characteristic Updated
    
    func peripheral(peripheral: CBPeripheral!,
        didUpdateValueForCharacteristic characteristic: CBCharacteristic!,
        error: NSError!) {
            if error {
                println("Error Updating Value of Characteristic: \(error.localizedDescription)");
            }
            
            var stringFromData:NSString = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding);
            println("Received: \(stringFromData)");
            
            // if this if case reached, we have finish receive all the data from the peripheral
            if stringFromData.isEqualToString("EOM") {
                
                // Do everything you want!
                var finalString:NSString = NSString(data: self.data, encoding: NSUTF8StringEncoding);
                println("!!!!!!ALL DATA RECEIVED!!!!!!!!: \(finalString)");
                

                self.stringReceived = finalString;
                if self.stringReceived == "Take Photo Trigger" {
                    self.NotifyMainViewController(BTLECentralState.TakePhotoTriggerReceived);
                }
                else if self.stringReceived == "Take Panoramic Trigger" {
                    self.NotifyMainViewController(BTLECentralState.TakePanoramicTriggerReceived);
                }
                else if self.stringReceived == "Setup Panoramic Mode" {
                    self.NotifyMainViewController(BTLECentralState.PanoramicModeSetup);
                }
                else if self.stringReceived == "Setup Photo Mode" {
                    self.NotifyMainViewController(BTLECentralState.PhotoModeSetup);
                    
                }
                else {
                    
                    // All the data has been received. Start Camera Shooting Action
                    self.NotifyMainViewController(BTLECentralState.PIDReceived);
                }
                
                self.data.length = 0;
                
                
            }
            else {
                // Not EOM, append data to what we already received
                self.data.appendData(characteristic.value);
            }
    }
    
    
    // whether our subscribe/unsubscribe happened or not
    func peripheral(peripheral: CBPeripheral!,
        didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!,
        error: NSError!) {
            if error {
                println("Error changing notification state: \(error.localizedDescription)");
            }
            
            
            // Check to see if it's our characteristic
            if (!characteristic.UUID.isEqual(CBUUID.UUIDWithString(transferCharacteristicUUID))) {
                // Not the characteristic we want, exit
                return;
            }
            
            // The notification has started
            if characteristic.isNotifying {
                println("Notification began on \(characteristic)");
            }
            else {
                // The notification has stopped
                println("Notification stopped on \(characteristic). Disconnecting");
                self.centralManager!.cancelPeripheralConnection(peripheral);
            }
    }
    
    // Central disconnect Peripheral happened
    func centralManager(central: CBCentralManager!,
        didDisconnectPeripheral peripheral: CBPeripheral!,
        error: NSError!) {
            println("Peripheral Disconnected");
            self.discoveredPeriperal = nil;
            
            // We have been disconnected, start scanning again
            self.scan();
    }
    
    
    
    func cleanUp() {
        println("ready to clean up");
        self.centralManager!.stopScan();
        if self.discoveredPeriperal == nil {
            return;
        }
        // Do nothing if we are not connected
        if !self.discoveredPeriperal!.isConnected {
            return;
        }
        
        if self.discoveredPeriperal!.services != nil {
            for item:AnyObject in self.discoveredPeriperal!.services {
                var service:CBService = item as CBService;
                if service.characteristics != nil {
                    for itemChar:AnyObject in service.characteristics {
                        var characteristic:CBCharacteristic = itemChar as CBCharacteristic;
                        
                        // Finding the characteristic we may notified
                        if characteristic.UUID.isEqual(CBUUID.UUIDWithString(transferCharacteristicUUID)) {
                            if characteristic.isNotifying {
                                // it is notifying, cancel notify here
                                self.discoveredPeriperal!.setNotifyValue(false, forCharacteristic: characteristic);
                                return;
                            }
                        }
                    }
                }
            }
        }
        
        // We are connected, but not notified, just unconnect the link
        self.centralManager!.cancelPeripheralConnection(self.discoveredPeriperal);
    }
    
    func NotifyMainViewController(state:BTLECentralState) {
        println("BLTLCentralModel boardcast MainViewController");
        
        self.mainViewController!.updateFromBTLECentralModel(state, stringReceived: self.stringReceived!);
        
        
    }
    

   
}
