//
//  DeviceInfo.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-08.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class DeviceInfo: NSObject {
    var mainPid:NSString?;
    
    class func getDevicePid() -> NSString {
        var DevicePid:NSString = UIDevice.currentDevice().identifierForVendor.UUIDString;
        return DevicePid;
    }
    
}
