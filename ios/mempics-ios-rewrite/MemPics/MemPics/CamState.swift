//
//  CamState.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

protocol CamState {
    func subViewSetup(mainView:MainView);
    func turnOnBluetooth(central:BTLECentralModel, peripheral:BTLEPeripheralModel);
    func BTLETrigger(peripheral:BTLEPeripheralModel, triggerType:Int, panoramicPhoto:Bool);
    func BTLESendCountDown(seconds:NSInteger, peripheral:BTLEPeripheralModel);
}
