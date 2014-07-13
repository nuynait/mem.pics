//
//  AVPanoramicPhotoSessionSetupImp.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import AVFoundation

class AVPanoramicPhotoSessionSetupImp: AVSessionSetupImp {
    
    func setupAVSession(avFoundationDeviceModel:AVFoundationDeviceModel, mainView:MainView)  {
        println("Setup Panoramic Session");
        
        var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(avFoundationDeviceModel.session) as AVCaptureVideoPreviewLayer;
        previewLayer.backgroundColor = UIColor.whiteColor().CGColor;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        // previewLayer.frame = UIScreen.mainScreen().bounds;
        var testRect:CGRect = CGRectMake(
            160,
            15,
            336,
            448);
        previewLayer.frame = testRect;
        mainView.layer.masksToBounds = true;
        mainView.layer.addSublayer(previewLayer);
        
        
        // var testRect:CGRect = CGRectMake(
        //     160,
        //     15,
        //     336,
        //     448);
        // 
        // var testView:UIView = UIView(frame: testRect);
        // testView.backgroundColor = UIColor.redColor();
        // mainView.addSubview(testView);
        
        
        
        /*
        // Set up a Camera Preview Layer
        avFoundationDeviceModel.session.sessionPreset = AVCaptureSessionPresetPhoto;
        // self.session.sessionPreset = AVCaptureSessionPreset640x480;
        var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(avFoundationDeviceModel.session) as AVCaptureVideoPreviewLayer;
        previewLayer.backgroundColor = UIColor.blackColor().CGColor;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        previewLayer.frame = UIScreen.mainScreen().bounds;
        mainView.layer.masksToBounds = true;
        mainView.layer.addSublayer(previewLayer);
        
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
        if avFoundationDeviceModel.session.canAddInput(videoDeviceInput) {
        avFoundationDeviceModel.session.addInput(videoDeviceInput);
        }
        
        
        // Setup the output
        var stillImageOutput:AVCaptureStillImageOutput = AVCaptureStillImageOutput();
        if avFoundationDeviceModel.session.canAddOutput(stillImageOutput) {
        // Add stillimage output to session
        avFoundationDeviceModel.session.addOutput(stillImageOutput);
        avFoundationDeviceModel.stillImageOutput = stillImageOutput;
        }
        
        avFoundationDeviceModel.session.startRunning();
        */
        
    }
    
}
