//
//  AVFoundationDeviceModel.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-08.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import AVFoundation

class AVFoundationDeviceModel: NSObject {
    
    var session:AVCaptureSession = AVCaptureSession();
    var stillImageOutput:AVCaptureStillImageOutput?;
    
    
    class func deviceWithMediaType(mediaType:NSString, position:AVCaptureDevicePosition) -> AVCaptureDevice {
        var devices:NSArray = AVCaptureDevice.devicesWithMediaType(mediaType);
        var captureDevice:AVCaptureDevice = devices.firstObject as AVCaptureDevice;
        
        for item : AnyObject in devices{
            var device:AVCaptureDevice = item as AVCaptureDevice;
            if device.position == position {
                captureDevice = device;
                break;
            }
        }
        return captureDevice;
    }
}
