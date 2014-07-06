//
//  MainViewController.swift
//  BoardCastiPad
//
//  Created by Tianyun Shan on 2014-06-26.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    var session:AVCaptureSession = AVCaptureSession();
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    override func loadView() {
        var mainView:UIView = UIView(frame:UIScreen.mainScreen().bounds);
        mainView.backgroundColor = UIColor.blackColor();
        self.view = mainView;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        avSessionSetup();

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // Setup the AVSession and AVCaptureDevice
    // Setup the previewLayer
    // Start running the session
    func avSessionSetup() {
        // Set up a Camera Preview Layer
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        // self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
        // self.session.sessionPreset = AVCaptureSessionPreset640x480;
        var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as AVCaptureVideoPreviewLayer;
        // previewLayer.backgroundColor = UIColor.blackColor().CGColor;
        // previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        // previewLayer.frame = UIScreen.mainScreen().bounds;
        previewLayer.frame = CGRectMake(0, 0, 999, 999);
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.orientation =  AVCaptureVideoOrientation.LandscapeLeft;
        previewLayer.automaticallyAdjustsMirroring = true;
        // previewLayer.orientation = AVCaptureVideoOrientation.LandscapeRight;
        self.view.layer.masksToBounds = true;
        self.view.layer.addSublayer(previewLayer);
        
        // According to Apple Documentation, The following actions takes times and will
        // cause ui to freeze, should put them into a dispatch_queue and run on the
        // other thread. Determain what device to use.
        var error:NSError?;
        var videoDevice:AVCaptureDevice = MainViewController.deviceWithMediaType(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back);
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
