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
        
        
        
        // All the info subview
        mainView.addSubview(mainView.camSwitchInfoLabel);
        mainView.addSubview(mainView.camSwitchHowtoLabel);
        mainView.addSubview(mainView.camSwitchHowtoDetailLabel);
        mainView.addSubview(mainView.rectangleView);
        mainView.addSubview(mainView.rectangleViewOnTop);


        
        
        mainView.camSwitchRedraw();
        mainView.pidDisplayLabelRedraw();
        mainView.qrCodeScanButtonSetup();
        mainView.qrCodeModeIndecatorSetup();
        mainView.qrCodeModeIndicator.hidden = true;
        if mainView.isRotating == false {
            mainView.focusDotLabelRedraw();
            mainView.focusImageRotating(999, frequency: 0.1);
        }
        
        mainView.camSwitchInfoLabelRedraw("L");
        mainView.camSwitchHowtoLabelRedraw();
        mainView.setupRectangleView();
        mainView.setupRectangleViewOnTop();
        // mainView.displayAllInfoLabel();
        
        mainView.bringEverythingOnTop();
        mainView.bringSubviewToFront(mainView.rectangleView);
        mainView.bringSubviewToFront(mainView.rectangleViewOnTop);
        mainView.bringSubviewToFront(mainView.camSwitch);
        
        println("Subview Setup From CentralState Finished");
    }
    
    func turnOnBluetooth(central:BTLECentralModel, peripheral:BTLEPeripheralModel) {
        central.setupCentralManager();
    }
   
    func BTLETrigger(peripheral:BTLEPeripheralModel, triggerType:Int, panoramicPhoto:Bool) {
        // Central Don't Have BTLETrigger
    }
    
    func BTLESendCountDown(seconds:NSInteger, peripheral:BTLEPeripheralModel) {
        // Central Don'e Send Count Down
        
    }
}
