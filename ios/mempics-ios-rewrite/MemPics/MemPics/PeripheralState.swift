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
        
        mainView.takePictureButtonRedraw();
        mainView.focusDotLabelRedraw();
        mainView.camSwitchRedraw();
        mainView.panoramaSwitchRedraw();
        mainView.pidDisplayLabelRedraw();
    }
    
    
    func turnOnBluetooth(central:BTLECentralModel, peripheral:BTLEPeripheralModel) {
        central.cleanUp();
        peripheral.changeAdvertisingState();
        
    }
    
    func BTLETrigger(peripheral:BTLEPeripheralModel, panoramicPhoto:Bool) {
        if panoramicPhoto {
            peripheral.stringToSend = "ABC";
            peripheral.dataToSend = peripheral.stringToSend.dataUsingEncoding(NSUTF8StringEncoding);
            peripheral.sendData();
            
        }
        else {
            peripheral.sendData();
        }
    }
}
