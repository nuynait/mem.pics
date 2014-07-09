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
    

    func paring(currentBTLEModel:AnyObject) {
        println("Peripheral State Do not need to scan");
        
    }
    func boardCasting(currentBTLEModel:AnyObject) {
        // start advertising (boardcasting)
        
        var bluetoothPeripheralModel:BTLEPeripheralModel = currentBTLEModel as BTLEPeripheralModel;
        bluetoothPeripheralModel.changeAdvertisingState();
    }
}
