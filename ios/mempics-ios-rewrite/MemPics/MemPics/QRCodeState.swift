//
//  QRCodeState.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-14.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class QRCodeState: CamState {
    func subViewSetup(mainView:MainView) {
        println("Subview Setup For QRCode State");
        mainView.removeAllFromSubview();
        mainView.qrCodeModeIndecatorSetup();
    }
    func turnOnBluetooth(central:BTLECentralModel, peripheral:BTLEPeripheralModel) {
        // QRCode Do not Need To Manage With Bluetooth
        
    }
    func BTLETrigger(peripheral:BTLEPeripheralModel, triggerType:Int, panoramicPhoto:Bool) {
        // QRCode Do Not Need To Manage With Bluetooth
        
    }
    
    func BTLESendCountDown(seconds:NSInteger, peripheral:BTLEPeripheralModel) {
        // QRCode Do Not Need To Send Count Down
    }
   
}
