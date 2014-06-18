//
//  CamViewController.swift
//  mempics-ios
//
//  Created by Tianyun Shan on 2014-06-18.
//  Copyright (c) 2014 Jerry Shan. All rights reserved.
//

import UIKit
import AVFoundation

class CamViewController: UIViewController {
    
    var session:AVCaptureSession = AVCaptureSession();
    var takePictureButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var focusDotLabel:UILabel = UILabel();

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
        var videoDevice:AVCaptureDevice = CamViewController.deviceWithMediaType(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back);
        var videoDeviceInput:AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: &error) as AVCaptureDeviceInput;
        
        if error {
            println("Got Error: \(error)");
        }
        
        
        // Get device and add as input into session
        if session.canAddInput(videoDeviceInput) {
            session.addInput(videoDeviceInput);
        }
        session.startRunning();
        
        
        // Setup All subviews
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
    
    func takePictureAction(sender:UIButton) {
        println("Take Picture Button Pressed");
        
        // Count Down 5 Seconds
        println("Start Count Down");
        countDown(5);
    }
    
    // A count down function
    func countDown(time:NSInteger) {
        var second:NSInteger = time;
        println("CountDowning: \(second)");
        if second == 0 {
            return;
        }
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.countDown(second - 1);
            });
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
