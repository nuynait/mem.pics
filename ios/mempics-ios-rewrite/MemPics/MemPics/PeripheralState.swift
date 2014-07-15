//
//  PeripheralState.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class PeripheralState: CamState {
    
    func subViewSetup(mainView:MainView) {
        println("Subview Setup From PeripheralState");
        mainView.removeAllFromSubview();
        
        mainView.addSubview(mainView.countDownLabel);
        mainView.addSubview(mainView.takePictureButton);
        mainView.addSubview(mainView.focusDotLabel);
        mainView.addSubview(mainView.camSwitch);
        mainView.addSubview(mainView.panoramaSwitch);
        mainView.addSubview(mainView.bluetoothStatusLabel);
        mainView.addSubview(mainView.qrCodeScanButton);
        
        mainView.takePictureButtonRedraw();
        mainView.focusDotLabelRedraw();
        mainView.camSwitchRedraw();
        mainView.panoramaSwitchRedraw();
        mainView.qrCodeModeIndecatorSetup();
        mainView.pidDisplayLabelRedraw();
        mainView.qrCodeScanButtonSetup();
    }
    
    
    func turnOnBluetooth(central:BTLECentralModel, peripheral:BTLEPeripheralModel) {
        central.cleanUp();
        peripheral.changeAdvertisingState();
        
    }
    
    // Peripheral is the Bluetooth Peripheral Model
    // TriggerType is a INT, 
    // if it is 0, the peripheral send the trigger signal,
    // if it is 1, the peripheral send the setup implementation signal
    // panoramicPhoto is a Bool, pass in the panoramicSwitcher.on, used when TriggerType is 1
    func BTLETrigger(peripheral:BTLEPeripheralModel, triggerType:Int, panoramicPhoto:Bool) {
        
        switch triggerType {
        case 0:
            println("BTLETrigger: Take Picture Trigger Send")
            if panoramicPhoto == true {
                peripheral.setupStringToSend("Take Panoramic Trigger");
                peripheral.sendData();
            }
            else {
                peripheral.setupStringToSend("Take Photo Trigger");
                peripheral.sendData();
            }
            
        case 1:
            println("BTLETrigger: Change MODE Trigger Send");
            if panoramicPhoto == true {
                peripheral.setupStringToSend("Setup Panoramic Mode");
                peripheral.sendData();
            }
            else {
                peripheral.setupStringToSend("Setup Photo Mode");
                peripheral.sendData();
            }
            
        default:
            println("ERROR, not an avaliable trigger case");
        }
        
        
        
        
    }
}
