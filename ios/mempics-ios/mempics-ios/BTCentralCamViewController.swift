//
//  BTCentralCamViewController.swift
//  mempics-ios
//
//  Created by Tianyun Shan on 2014-06-18.
//  Copyright (c) 2014 Jerry Shan. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth

class BTCentralCamViewController: UIViewController, CBCentralManagerDelegate {

    var session:AVCaptureSession = AVCaptureSession();
    var takePictureButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var focusDotLabel:UILabel = UILabel();
    var countDownLabel:UILabel = UILabel();
    
    
    // Flags
    
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    override func loadView() {
        var mainView:UIView = UIView(frame:UIScreen.mainScreen().bounds);
        self.view = mainView;
        
        self.view.addSubview(self.takePictureButton);
        self.view.addSubview(self.focusDotLabel);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup All the Sessions
        avSessionSetup();
        
        // Setup All subviews
        subViewSetup();
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


// All the AV Foundation Setups
extension BTCentralCamViewController {
    
    // Setup the AVSession and AVCaptureDevice
    // Setup the previewLayer
    // Start running the session
    func avSessionSetup() {
        // Set up a Camera Preview Layer
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
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
        var videoDevice:AVCaptureDevice = BTCentralCamViewController.deviceWithMediaType(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back);
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

// All the Camera Functionality
extension BTCentralCamViewController {
    
    // Render all the subviews above the preview layer
    func subViewSetup() {
        self.takePictureButton.setTitle("Take Picture", forState:UIControlState.Normal);
        self.takePictureButton.sizeToFit();
        self.takePictureButton.frame = CGRectMake(
            (self.view.frame.width - self.takePictureButton.frame.width) / 2,
            400,
            takePictureButton.frame.width,
            takePictureButton.frame.height);
        self.takePictureButton.addTarget(self,
            action: "takePictureAction:",
            forControlEvents: UIControlEvents.TouchUpInside);
        self.view.bringSubviewToFront(takePictureButton);
        
        self.focusDotLabel.text = ".";
        self.focusDotLabel.textColor = UIColor.redColor();
        self.focusDotLabel.sizeToFit();
        self.focusDotLabel.frame = CGRectMake(
            (self.view.frame.width - self.focusDotLabel.frame.width) / 2,
            (self.view.frame.height - self.focusDotLabel.frame.height) / 2,
            self.focusDotLabel.frame.width,
            self.focusDotLabel.frame.height);
        self.view.bringSubviewToFront(focusDotLabel);
        
    }
    
    
    // Rerender CountDown Label
    func countDownLabelRedraw(labelText:NSString) {
        self.countDownLabel.text = labelText;
        self.countDownLabel.textColor = UIColor.redColor();
        self.countDownLabel.sizeToFit();
        self.countDownLabel.frame = CGRectMake(
            (self.view.frame.width - self.countDownLabel.frame.width) / 2,
            100,
            self.countDownLabel.frame.width,
            self.countDownLabel.frame.height);
        self.view.bringSubviewToFront(countDownLabel);
    }
    
    func takePictureAction(sender:UIButton) {
        self.view.addSubview(self.countDownLabel);
        // Count Down 5 Seconds
        // Count Down Runs In A Seperate Thread
        println("Start Count Down");
        countDown(5);
        
    }
    
    // A count down function
    // Countdown runs in a seperate thread, so anything after the countdown in
    // main function gets exec() before countdown.
    func countDown(time:NSInteger) {
        var second:NSInteger = time;
        println("CountDowning: \(second)");
        self.countDownLabelRedraw("\(second)");
        if second == 0 {
            // Here, Countdown Complete.
            // Run the Complete Function
            println("CountDown Finished");
            self.countDownLabel.removeFromSuperview();
            self.flashScreen();
            return;
        }
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.countDown(second - 1);
            });
    }
    
    
    // Screen Flash, this is for simulate a "picture taken" animation
    func flashScreen() {
        var flashView:UIView = UIView(frame:self.view.frame);
        flashView.backgroundColor = UIColor.whiteColor();
        self.view.window.addSubview(flashView);
        
        UIView.animateWithDuration(1, animations: {
            flashView.alpha = 0;
            });
    }
    
}


// Add Core Bluetooth Functions and Protocols
extension BTCentralCamViewController {
    
    func centralManagerDidUpdateState(central: CBCentralManager!)  {
        
    }
    
}

