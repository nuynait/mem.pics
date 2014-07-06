//
//  mainViewController.swift
//  CamView
//
//  Created by Tianyun Shan on 2014-06-26.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import Cocoa
import AVFoundation

class mainViewController: NSViewController {
    var session:AVCaptureSession?;

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Initialization code here.
    }
    
    override func loadView()  {
        var view:NSView = NSView(frame:
        
    }
    
    override func viewDidAppear() {
        
    }

    func avSessionSetup() {
        // Set up a Camera Preview Layer
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        // self.session.sessionPreset = AVCaptureSessionPreset640x480;
        var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as AVCaptureVideoPreviewLayer;
        previewLayer.backgroundColor = UIColor.blackColor().CGColor;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        previewLayer.frame = UIScreen.mainScreen().bounds;
        self.view.layer.masksToBounds = true;
        self.view.layer.addSublayer(previewLayer);
        
        // According to Apple Documentation, The following actions takes times and will
        // cause ui to freeze, should put them into a dispatch_queue and run on the
        // other thread. Determain what device to use.
        var error:NSError?;
        var videoDevice:AVCaptureDevice = BTPeripheralCamViewController.deviceWithMediaType(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back);
        var videoDeviceInput:AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: &error) as AVCaptureDeviceInput;
        
        if error {
            println("Got Error: \(error)");
        }
        
        
        // Get device and add as input into session
        if session.canAddInput(videoDeviceInput) {
            session.addInput(videoDeviceInput);
        }
        
        
        
        
        session.startRunning();
    }
}
