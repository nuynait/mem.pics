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
    var photoPreview:AVCaptureVideoPreviewLayer?;
    
    init() {
        super.init();
        setupBasicAVSession();
    }
    
    func setupBasicAVSession() {
        
        // Set up a Camera Preview Layer
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        // self.session.sessionPreset = AVCaptureSessionPreset640x480;
        
        
        var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as AVCaptureVideoPreviewLayer;
        previewLayer.backgroundColor = UIColor.blackColor().CGColor;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.frame = UIScreen.mainScreen().bounds;
        self.photoPreview = previewLayer;
        
        // According to Apple Documentation, The following actions takes times and will
        // cause ui to freeze, should put them into a dispatch_queue and run on the
        // other thread. Determain what device to use.
        var error:NSError?;
        var videoDevice:AVCaptureDevice = AVFoundationDeviceModel.deviceWithMediaType(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back);
        var videoDeviceInput:AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: &error) as AVCaptureDeviceInput;
        
        
        if error {
            println("Got Error: \(error)");
        }
        
        
        // Get device and add as input into session
        if self.session.canAddInput(videoDeviceInput) {
            self.session.addInput(videoDeviceInput);
        }
        
        
        // Setup the output
        var stillImageOutput:AVCaptureStillImageOutput = AVCaptureStillImageOutput();
        if self.session.canAddOutput(stillImageOutput) {
            // Add stillimage output to session
            self.session.addOutput(stillImageOutput);
            self.stillImageOutput = stillImageOutput;
        }
    }
    
    class func deviceWithMediaType(mediaType:NSString, position:AVCaptureDevicePosition) -> AVCaptureDevice {
        var devices:NSArray = AVCaptureDevice.devicesWithMediaType(mediaType);
        var captureDevice:AVCaptureDevice = devices.firstObject as AVCaptureDevice;
        // captureDevice.lockForConfiguration(nil);
        // captureDevice.exposureMode = AVCaptureExposureMode.Locked;
        // captureDevice.unlockForConfiguration();
        
        for item : AnyObject in devices{
            var device:AVCaptureDevice = item as AVCaptureDevice;
            if device.position == position {
                captureDevice = device;
                break;
            }
        }
        return captureDevice;
    }
    
    func lockExposure() {
        var devices:NSArray = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo);
        var captureDevice:AVCaptureDevice = devices.firstObject as AVCaptureDevice;
        captureDevice.lockForConfiguration(nil);
        captureDevice.exposureMode = AVCaptureExposureMode.Locked;
        captureDevice.focusMode = AVCaptureFocusMode.Locked;
        captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceMode.Locked;
        captureDevice.unlockForConfiguration();
    }
}
