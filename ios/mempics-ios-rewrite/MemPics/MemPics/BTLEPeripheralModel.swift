//
//  BTLEPeripheralModel.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import CoreBluetooth

enum BTLEPeripheralState {
    case EOMSent
}

class BTLEPeripheralModel: NSObject, CBPeripheralManagerDelegate {
    
    // Delegate
    var mainViewController:MainViewController?;
    
    var dataToSend:NSData?;
    var sendDataIndex:NSInteger?;
    var sendingEOM:Bool = false;
    var stringToSend:NSString?;
    var peripheralManager:CBPeripheralManager?;
    var transferCharacteristic:CBMutableCharacteristic?;
    var advertisingSwitch:Bool = false;
    
    
    // UUIDS
    var transferServiceUUID:NSString = "1699DD88-A314-4E04-84DE-6CB7863EA2C0";
    var transferCharacteristicUUID:NSString = "512EA3F8-1209-4095-90E6-302216ED120D";
    
    

    

    
    init(mainVC:MainViewController) {
        super.init();
        self.mainViewController = mainVC;
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil);
    }
    
    func setStringToSend(strToSend:NSString) {
        self.stringToSend = strToSend;
    }
    
    func changeAdvertisingState() {
        if advertisingSwitch {
                self.peripheralManager!.stopAdvertising();
                self.advertisingSwitch = false;
        }
        else {
            self.peripheralManager!.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [CBUUID.UUIDWithString(transferServiceUUID)]]);
            self.advertisingSwitch = true;
        }
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        // Check Bluetooth Avalibility
        if peripheral.state != CBPeripheralManagerState.PoweredOn {
            println("Bluetooth NOT Avaliable!");
            return;
        }
        
        println("peripheral Manager powered on");
        
        
        // Build out the characteristic
        self.transferCharacteristic = CBMutableCharacteristic(
            type: CBUUID.UUIDWithString(transferCharacteristicUUID),
            properties: CBCharacteristicProperties.Notify,
            value: nil,
            permissions: CBAttributePermissions.Readable);
        
        // Build out the service
        var transferService:CBMutableService = CBMutableService(type: CBUUID.UUIDWithString(transferServiceUUID), primary: true);
        
        // Add characteristic to the service
        // Service contains an array of characteristics
        transferService.characteristics = [self.transferCharacteristic!];
        
        // Add service to the peripheral manager
        self.peripheralManager!.addService(transferService);
    }
    
    // Catch when someone subscribe to our characteristic
    // Start send them data
    func peripheralManager(peripheral: CBPeripheralManager!,
        central: CBCentral!,
        didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
            println("Central subscribed to characteristic");
            
            // Get the data
            self.dataToSend = self.stringToSend!.dataUsingEncoding(NSUTF8StringEncoding);
            
            // Reset the index
            // Because this is the first time central subscribe to peripheral
            // All the data needs to be resended
            self.sendDataIndex = 0;
            self.sendingEOM = false;
            
            
            // SendData
            self.sendData();
            
    }
    
    
    // This function get called when peripheral manager is ready to send
    // the next chunk of data. This is ensure that packets will arrive in
    // the order they are sent
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        
        // Start sending again
        self.sendData();
        
    }
    
    
    func sendData() {
        
        if sendingEOM {
            self.sendEOMString();
            
            return;
            
        }
        
        
        // Send actual data
        
        // first check if there is any data left to send
        if self.sendDataIndex >= self.dataToSend!.length {
            
            // No more data to send, Do nothing
            return;
        }
        
        
        // There is data to send, send until the callback fails, or we're done
        var didSend:Bool = true;
        
        while didSend {
            
            // Calc how big it should to be
            var amountToSend:NSInteger = self.dataToSend!.length - self.sendDataIndex!;
            
            println("Prepare Sending Data, amountToSend: \(amountToSend), dataToSend.length: \(self.dataToSend!.length)")
            
            // Bluetooth can only send no more than 20 bytes
            // Check if we need to send more than 20 bytes data
            if amountToSend > 20 {
                amountToSend = 20;
                println("amountToSend exceeds 20 bytes, thus change amountToSend to 20");
            }
            
            // Copy out the data we need to send
            var startRange:NSInteger = self.sendDataIndex!;
            var endRange:NSInteger = amountToSend;
            var chunk:NSData = self.dataToSend!.subdataWithRange(NSMakeRange(startRange, endRange));
            
            // Debug
            var chunkString:NSString = NSString(data: chunk, encoding: NSUTF8StringEncoding);
            println("Send Out Data: String: \(chunkString), startRange: \(startRange), endRange: \(endRange)");
            
            
            // Send the chunk
            didSend = self.peripheralManager!.updateValue(chunk,
                forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil);
            
            // if it didn't work, drop out and wait for the callback
            if !didSend {
                println("Didn't work. Drop out Wait for the callback");
                return;
            }
            
            // if did send, update our index
            self.sendDataIndex = self.sendDataIndex! + amountToSend;
            
            
            // check if it is the last one
            // if it is last one, we need to send out the eom string
            
            if self.sendDataIndex >= self.dataToSend!.length {
                
                self.sendEOMString();
                
                return;
                
            }
        }
    }
    
    func sendEOMString() {
        // Send EOM
        // Set Sending EOM to true, so if the first time failes
        // we can still resend it
        self.sendingEOM = true;
        
        // Send ROM
        var eomString:NSString = "EOM";
        
        // Sending EOM
        var eomSent:Bool = self.peripheralManager!.updateValue(eomString.dataUsingEncoding(NSUTF8StringEncoding),
            forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil);
        
        // If EOM is already sent
        if eomSent {
            // Mark EOM has been sent
            self.sendingEOM = false;
            
            
            // Turn off the advertise
            self.peripheralManager!.stopAdvertising();
            self.advertisingSwitch = false;
            
            // Run CountDown Action
            // self.countDown(5, panoramaPhotoLeft: 0);
            
            // Notify View Controller EOM Has Been Sent
            self.NotifyMainViewController(BTLEPeripheralState.EOMSent);
            
            println("sent EOM");
        }
    }
    
    // This function get called when central unsubscribes
    func peripheralManager(peripheral: CBPeripheralManager!,
        central: CBCentral!,
        didUnsubscribeFromCharacteristic characteristic: CBCharacteristic!) {
            println("Central unsubscribed from characteristic");
    }
    
    func NotifyMainViewController(state:BTLEPeripheralState) {
        println("BTLEPeripheralModel boardcast MainViewController");
        
        self.mainViewController!.updateFromBTLEPeripheralModel(state);
        
    }
    
    
}
