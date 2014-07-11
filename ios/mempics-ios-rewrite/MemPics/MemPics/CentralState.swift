//
//  CentralState.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class CentralState: CamState {
    
    func subViewSetup(mainView:MainView) {
        println("Subview Setup From CentralState");
        mainView.removeAllFromSubview();
        mainView.addSubview(mainView.countDownLabel);
        mainView.addSubview(mainView.focusDotLabel);
        mainView.addSubview(mainView.camSwitch);
        mainView.addSubview(mainView.bluetoothStatusLabel);
        mainView.addSubview(mainView.pidDisplayLabel);
        
        mainView.focusDotLabelRedraw();
        mainView.camSwitchRedraw();
        mainView.pidDisplayLabelRedraw();
    }
    
    func turnOnBluetooth(central:BTLECentralModel, peripheral:BTLEPeripheralModel) {
        central.setupCentralManager();
    }
   
    func BTLETrigger(peripheral:BTLEPeripheralModel) {
        // Central Don't Have BTLETrigger
    }
}
