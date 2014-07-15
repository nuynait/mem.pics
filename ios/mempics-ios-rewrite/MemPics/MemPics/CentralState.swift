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
        mainView.addSubview(mainView.qrCodeScanButton);
        
        mainView.focusDotLabelRedraw();
        mainView.camSwitchRedraw();
        mainView.pidDisplayLabelRedraw();
        mainView.qrCodeScanButtonSetup();
        mainView.qrCodeModeIndecatorSetup();
        mainView.qrCodeModeIndicator.hidden = true;
        println("Subview Setup From CentralState Finished");
    }
    
    func turnOnBluetooth(central:BTLECentralModel, peripheral:BTLEPeripheralModel) {
        central.setupCentralManager();
    }
   
    func BTLETrigger(peripheral:BTLEPeripheralModel, triggerType:Int, panoramicPhoto:Bool) {
        // Central Don't Have BTLETrigger
    }
}
