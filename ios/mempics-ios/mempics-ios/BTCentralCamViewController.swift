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

class BTCentralCamViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    var session:AVCaptureSession = AVCaptureSession();
    var takePictureButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var focusDotLabel:UILabel = UILabel();
    var countDownLabel:UILabel = UILabel();
    var camSwitch:UISwitch = UISwitch();
    var bluetoothStatus:UILabel = UILabel();
    
    
    // Peripheral View Controller
    var window:UIWindow?;
    var peripheralViewController:BTPeripheralCamViewController = BTPeripheralCamViewController(nibName: nil, bundle: nil);
    var firstLaunchView:Bool = true;
    
    
    // All Bluetooth Use Property
    var data:NSMutableData = NSMutableData();
    var centralManager:CBCentralManager?;
    
    // Remember State for Bluetooth
    var discoveredPeriperal:CBPeripheral?;
    
    
    // UUIDS
    var transferServiceUUID:NSString = "1699DD88-A314-4E04-84DE-6CB7863EA2C0";
    var transferCharacteristicUUID:NSString = "512EA3F8-1209-4095-90E6-302216ED120D";
    
    var tempUUID:NSString = "E20A39F4-73F5-4BC4-A12F-17D1AD07A961";
    var temp2UUID:NSString = "08590F7E-DB05-467E-8757-72F6FAEB13D4";
    
    
    // ImageOutput
    var stillImageOutput:AVCaptureStillImageOutput?;
    
    
    
    // Flags
    
    // Photoponorama
    var storeImage:Array<UIImage> = [];
    var isPhotoponorama:Bool = false;
    
    
    // ImageViewer
    var imagePreview1:UIImageView = UIImageView();
    var imagePreview2:UIImageView = UIImageView();
    var imagePreview3:UIImageView = UIImageView();
    var imagePreview4:UIImageView = UIImageView();
    var imagePreview5:UIImageView = UIImageView();
    var imagePreviewArray:Array<UIImageView>?;
    
    
    var imageLargePreview1:UIImageView = UIImageView();
    var imageLargePreview2:UIImageView = UIImageView();
    var imageLargePreview3:UIImageView = UIImageView();
    var imageLargePreview4:UIImageView = UIImageView();
    var imageLargePreview5:UIImageView = UIImageView();
    var imageLargePreviewArray:Array<UIImageView>?;
    
    
    // Upload
    var pid:NSString = UIDevice.currentDevice().identifierForVendor.UUIDString;
    var mainPID:NSString?;
    var eye:NSString = "l";
    var imageToSave:UIImage?;
    var uploadViewController:UploadViewController?;
    
    
    var pidDisplay:NSString?;
    var pidDisplayLabel:UILabel = UILabel();
    
    
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    override func loadView() {
        var mainView:UIView = UIView(frame:UIScreen.mainScreen().bounds);
        self.view = mainView;
        
        // self.view.addSubview(self.takePictureButton);
        self.view.addSubview(self.countDownLabel);
        self.view.addSubview(self.focusDotLabel);
        self.view.addSubview(self.camSwitch);
        self.view.addSubview(self.bluetoothStatus);
        self.view.addSubview(self.pidDisplayLabel);
        
        
        self.pidDisplay = self.pid.substringWithRange(NSRange(location: self.pid.length - 5, length: 5));
        println("pid: \(self.pid)");
        println("pidDisplay: \(self.pidDisplay)");
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup AV Sessions
        avSessionSetup();
        
        // Setup All Subviews
        subViewSetup();
        
        
        // Debug Use
        self.pairing();
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
        var videoDevice:AVCaptureDevice = BTCentralCamViewController.deviceWithMediaType(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back);
        var videoDeviceInput:AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: &error) as AVCaptureDeviceInput;
        
        if error {
            println("Got Error: \(error)");
        }
        
        
        // Get device and add as input into session
        if session.canAddInput(videoDeviceInput) {
            session.addInput(videoDeviceInput);
        }
        
        
        // Setup the output
        self.stillImageOutput = AVCaptureStillImageOutput();
        if session.canAddOutput(self.stillImageOutput) {
            // Add stillimage output to session
            session.addOutput(self.stillImageOutput);
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
        
        
        self.focusDotLabel.font = UIFont.systemFontOfSize(66);
        self.focusDotLabel.text = "+";
        self.focusDotLabel.textColor = UIColor.redColor();
        self.focusDotLabel.sizeToFit();
        self.focusDotLabel.frame = CGRectMake(
            (self.view.frame.width - self.focusDotLabel.frame.width) / 2,
            (self.view.frame.height - self.focusDotLabel.frame.height) / 2,
            self.focusDotLabel.frame.width,
            self.focusDotLabel.frame.height);
        self.focusDotLabel.alpha = 0.6;
        self.view.bringSubviewToFront(focusDotLabel);
        
        self.camSwitch.frame = CGRectMake(10,self.view.frame.height - 60, 79, 27);
        self.camSwitch.addTarget(self,
            action: "flipView:",
            forControlEvents: UIControlEvents.ValueChanged);
        self.camSwitch.alpha = 0.6;
        self.view.bringSubviewToFront(camSwitch);
        
        // Size 20*20
        self.imagePreview1.frame.size = CGSizeMake(20, 20);
        self.imagePreview1.frame = CGRectMake(2, 2, self.imagePreview1.frame.width, self.imagePreview1.frame.height);
        self.view.bringSubviewToFront(imagePreview1);
        
        self.imagePreview2.frame.size = CGSizeMake(20, 20);
        self.imagePreview2.sizeToFit();
        self.imagePreview2.frame = CGRectMake(self.imagePreview1.frame.maxX, 2, self.imagePreview1.frame.width, self.imagePreview1.frame.height);
        self.view.bringSubviewToFront(imagePreview2);
        
        self.imagePreview3.frame.size = CGSizeMake(20, 20);
        self.imagePreview3.sizeToFit();
        self.imagePreview3.frame = CGRectMake(self.imagePreview2.frame.maxX, 2, self.imagePreview1.frame.width, self.imagePreview1.frame.height);
        self.view.bringSubviewToFront(imagePreview3);
        
        self.imagePreview4.frame.size = CGSizeMake(20, 20);
        self.imagePreview4.sizeToFit();
        self.imagePreview4.frame = CGRectMake(self.imagePreview3.frame.maxX, 2, self.imagePreview1.frame.width, self.imagePreview1.frame.height);
        self.view.bringSubviewToFront(imagePreview4);
        
        self.imagePreview5.frame.size = CGSizeMake(20, 20);
        self.imagePreview5.sizeToFit();
        self.imagePreview5.frame = CGRectMake(self.imagePreview4.frame.maxX, 2, self.imagePreview1.frame.width, self.imagePreview1.frame.height);
        self.view.bringSubviewToFront(imagePreview5);
        
        self.imagePreviewArray = [self.imagePreview1, self.imagePreview2, self.imagePreview3, self.imagePreview4, self.imagePreview5];
        
        
        // Size 64*64
        self.imageLargePreview1.frame.size = CGSizeMake(64,64);
        self.imageLargePreview1.frame = CGRectMake(0,
            (self.view.frame.height - self.imageLargePreview1.frame.height) / 2, self.imageLargePreview1.frame.width, self.imageLargePreview1.frame.height);
        self.imageLargePreview1.alpha = 0.6;
        self.view.bringSubviewToFront(imageLargePreview1);
        self.view.addSubview(imageLargePreview1);
        
        self.imageLargePreview2.frame.size = CGSizeMake(64,64);
        self.imageLargePreview2.frame = CGRectMake(self.imageLargePreview1.frame.maxX,
            (self.view.frame.height - self.imageLargePreview1.frame.height) / 2, self.imageLargePreview1.frame.width, self.imageLargePreview1.frame.height);
        self.imageLargePreview2.alpha = 0.6;
        self.view.bringSubviewToFront(imageLargePreview2);
        self.view.addSubview(imageLargePreview2);
        
        self.imageLargePreview3.frame.size = CGSizeMake(64,64);
        self.imageLargePreview3.frame = CGRectMake(self.imageLargePreview2.frame.maxX,
            (self.view.frame.height - self.imageLargePreview1.frame.height) / 2, self.imageLargePreview1.frame.width, self.imageLargePreview1.frame.height);
        self.imageLargePreview3.alpha = 0.6;
        self.view.bringSubviewToFront(imageLargePreview3);
        self.view.addSubview(imageLargePreview3);
        
        self.imageLargePreview4.frame.size = CGSizeMake(64,64);
        self.imageLargePreview4.frame = CGRectMake(self.imageLargePreview3.frame.maxX,
            (self.view.frame.height - self.imageLargePreview1.frame.height) / 2, self.imageLargePreview1.frame.width, self.imageLargePreview1.frame.height);
        self.imageLargePreview4.alpha = 0.6;
        self.view.bringSubviewToFront(imageLargePreview4);
        self.view.addSubview(imageLargePreview4);
        
        self.imageLargePreview5.frame.size = CGSizeMake(64,64);
        self.imageLargePreview5.frame = CGRectMake(self.imageLargePreview4.frame.maxX,
            (self.view.frame.height - self.imageLargePreview1.frame.height) / 2, self.imageLargePreview1.frame.width, self.imageLargePreview1.frame.height);
        self.imageLargePreview5.alpha = 0.6;
        self.view.bringSubviewToFront(imageLargePreview5);
        self.view.addSubview(imageLargePreview5);
        
        self.imageLargePreviewArray = [self.imageLargePreview1, self.imageLargePreview2, self.imageLargePreview3, self.imageLargePreview4, self.imageLargePreview5];
        
        
        self.pidDisplayLabel.textColor = UIColor.whiteColor();
        self.pidDisplayLabel.text = "ID: \(self.pidDisplay)";
        self.pidDisplayLabel.sizeToFit();
        self.pidDisplayLabel.frame = CGRectMake(
            5, 5,
            self.pidDisplayLabel.frame.width,
            self.pidDisplayLabel.frame.height);
        self.view.bringSubviewToFront(self.pidDisplayLabel);
        self.view.addSubview(self.pidDisplayLabel);
    }
    
    func clearImagePreview () {
        self.imagePreview1.image = nil;
        self.imagePreview2.image = nil;
        self.imagePreview3.image = nil;
        self.imagePreview4.image = nil;
        self.imagePreview5.image = nil;
        
        self.imageLargePreview1.image = nil;
        self.imageLargePreview2.image = nil;
        self.imageLargePreview3.image = nil;
        self.imageLargePreview4.image = nil;
        self.imageLargePreview5.image = nil;
    }
    
    func flipView (sender:UISwitch) {
        self.clearImagePreview();
        if camSwitch.on {
            // Should go to BTPeripheral
            
            /*
            self.peripheralViewController.camCentralViewController = self;
            self.presentViewController(self.peripheralViewController, animated: false, completion: {
                self.peripheralViewController.loadView();
                self.peripheralViewController.viewDidLoad();
                self.peripheralViewController.camSwitch.on = true;
                });
            */
            
            
            // if first launch view, do not setup the previewLayer.
            if self.firstLaunchView {
                self.peripheralViewController.camCentralViewController = self;
                self.peripheralViewController.window = self.window;
                self.peripheralViewController.camSwitch.on = true;
                self.peripheralViewController.panoramaSwitch.on = false;
                
                self.firstLaunchView = false;
                self.window!.rootViewController = self.peripheralViewController;
            }
            else {
                // if not first time launch the view, resetup the previewLayer
                self.peripheralViewController.session.sessionPreset = AVCaptureSessionPresetPhoto;
                self.peripheralViewController.camCentralViewController = self;
                self.peripheralViewController.window = self.window;
                self.peripheralViewController.camSwitch.on = true;
                self.peripheralViewController.panoramaSwitch.on = false;
                
                
                var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as AVCaptureVideoPreviewLayer;
                
                previewLayer.backgroundColor = UIColor.blackColor().CGColor;
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                previewLayer.frame = UIScreen.mainScreen().bounds;
                self.peripheralViewController.view.layer.masksToBounds = true;
                self.peripheralViewController.view.layer.addSublayer(previewLayer);
                
                self.peripheralViewController.subViewSetup();
                
                self.window!.rootViewController = self.peripheralViewController;
            }
        }
        else {
            // Should go to BTCentralCamViewController
            
            // Stay Here
        }
        
    }
    
    // Rerender CountDown Label
    func countDownLabelRedraw(labelText:NSString) {
        self.countDownLabel.font = UIFont.systemFontOfSize(44);
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
    
    
    
    // Rerender Bluetooth Status Label
    func bluetoothStatusLabelRedraw(labelText:NSString) {
        self.bluetoothStatus.text = labelText;
        self.bluetoothStatus.textColor = UIColor.redColor();
        self.bluetoothStatus.sizeToFit();
        self.bluetoothStatus.frame = CGRectMake(
            self.view.frame.width - self.bluetoothStatus.frame.width + 5,
            10,
            self.bluetoothStatus.frame.width,
            self.bluetoothStatus.frame.height);
        self.view.bringSubviewToFront(bluetoothStatus);
    }
    
    func takePictureAction(sender:UIButton) {
        // Count Down 5 Seconds
        // Count Down Runs In A Seperate Thread
        println("Start Count Down");
        // countDown(5);
        
    }
    
    // A count down function
    // Countdown runs in a seperate thread, so anything after the countdown in
    // main function gets exec() before countdown.
    func countDown(time:NSInteger, panoramaPhotoLeft:NSInteger) {
        var second:NSInteger = time;
        println("CountDowning: \(second)");
        self.countDownLabelRedraw("\(second)");
        if second == 0 {
            // Here, Countdown Complete.
            // Run the Complete Function
            if self.isPhotoponorama == false {
                self.countDownComplete();
            }
            if self.isPhotoponorama {
                self.countDownCompletePanorama(panoramaPhotoLeft);
            }
            return;
        }
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.countDown(second - 1, panoramaPhotoLeft: panoramaPhotoLeft);
            });
    }
    
    func countDownCompletePanorama(panoramaPhotoLeft:NSInteger) {
        
        
        
        println("CountDown Finished, panoramaPhotoLeft:\(panoramaPhotoLeft)");
        self.countDownLabel.text = "";
        self.flashScreen();
        
        println("Start Capture Image");
        // Capture Image:
        self.stillImageOutput!.captureStillImageAsynchronouslyFromConnection(self.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo), completionHandler:
            { (buffer, error:NSError!) in
                
                if buffer {
                    var imageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer);
                    var image:UIImage = UIImage(data: imageData);
                    println("Save to Array");
                    self.storeImage.append(image);
                    self.imagePreviewArray![5-panoramaPhotoLeft].image = self.imageWithImage(image, newSize: CGSizeMake(20, 20));
                    self.imageLargePreviewArray![5-panoramaPhotoLeft].image = self.imageWithImage(image, newSize: CGSizeMake(64,64));
                    
                    // This is for debug
                    // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                    
                    
                    
                    
                    //
                    
                    if panoramaPhotoLeft - 1 == 0 {
                        println("Prepare for stitch");
                        // self.stitch();
                        
                        println("Ignore Stitch panorama Finished");
                        
                        // Reenable Button
                        self.takePictureButton.enabled = true;
                        
                        return;
                        
                    }
                    
                    self.countDown(3, panoramaPhotoLeft: panoramaPhotoLeft - 1);
                }
            });
        
        
        
    }
    
    // This function get called after the count down
    func countDownComplete() {
        println("CountDown Finished");
        self.countDownLabel.text = "";
        self.flashScreen();
        
        println("Start Capture Image");
        // Capture Image:
        self.stillImageOutput!.captureStillImageAsynchronouslyFromConnection(self.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo), completionHandler:
            { (buffer, error:NSError!) in
                
                if buffer {
                    var imageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer);
                    var image:UIImage = UIImage(data: imageData);
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                    // println("Save to Album finished");
                    self.imageToSave = image;
                    // self.upLoad();
                    self.uploadViewController = UploadViewController(nibName: nil, bundle: nil);
                    self.uploadViewController!.eye = "l";
                    self.uploadViewController!.pid = self.pid;
                    self.uploadViewController!.mainPID = self.mainPID;
                    self.uploadViewController!.imageToSave = self.imageToSave;
                    self.presentViewController(self.uploadViewController, animated: true, completion:nil);
                    
                }
            });
    }
    
    
    func pairing() {
        
        // Run Bluetooth Central Manager
        self.centralManager = CBCentralManager(delegate: self, queue: nil);
        
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
        if (central.state != CBCentralManagerState.PoweredOn) {
            println("Bluetooth Not Ready To Use");
            return;
        }
        
        println("Bluetooth is Ready To Use");
        scan();
    }
    
    func scan() {
        self.centralManager!.scanForPeripheralsWithServices([CBUUID.UUIDWithString(self.tempUUID)], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]);
        println("Scan Started");
        
    }
    
    func centralManager(central: CBCentralManager!,
        didDiscoverPeripheral peripheral: CBPeripheral!,
        advertisementData: NSDictionary!,
        RSSI: NSNumber!) {
            println("Discoverd \(peripheral.name) at \(RSSI)");
            // Check to See if this peripheral is the one we already connected
            if (self.discoveredPeriperal != peripheral) {
                // Mark it discovered
                self.discoveredPeriperal = peripheral;
                // Connect to that peripheral
                println("Connect to peripheral");
                self.centralManager!.connectPeripheral(peripheral, options: nil);
            }
    }
    
    func centralManager(central: CBCentralManager!,
        didFailToConnectPeripheral peripheral: CBPeripheral!,
        error: NSError!) {
            println("Failed to connect to \(peripheral), Errror: \(error.localizedDescription)");
            
    }
    
    func centralManager(central: CBCentralManager!,
        didConnectPeripheral peripheral: CBPeripheral!) {
            println("Peripheral Connected");
            
            // Stop Scan
            self.centralManager!.stopScan();
            println("Scan Stopped");
            
            // Clear the Data
            self.data.length = 0;
            
            peripheral.delegate = self;
            peripheral.discoverServices([CBUUID.UUIDWithString(self.tempUUID)]);
            
    }
    
    // Discover Service, loopthough and get all the characteristic
    func peripheral(peripheral: CBPeripheral!,
        didDiscoverServices error: NSError!) {
            if error {
                println("Error, Discovering Service: \(error.localizedDescription)");
                self.cleanUp();
                return;
            }
            
            // Discover all the characteristics
            // Loop though the service
            
            for service : AnyObject in peripheral.services {
                peripheral.discoverCharacteristics([CBUUID.UUIDWithString(self.temp2UUID)], forService: service as CBService);
            }
            
    }
    
    // 
    func peripheral(peripheral: CBPeripheral!,
        didDiscoverCharacteristicsForService service: CBService!,
        error: NSError!) {
            if error {
                println("Error, Discovering Characteristics: \(error.localizedDescription)");
                self.cleanUp();
                return;
            }
            
            
            // Subscribe to All the char
            for item: AnyObject in service.characteristics {
                var characteristic:CBCharacteristic = item as CBCharacteristic;
                if (characteristic.UUID.isEqual(CBUUID.UUIDWithString(temp2UUID))) {
                    // Has Found the characteristic, need to subsribe to it
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic);
                }

            }
            
            // Complete! Need to wait for the data to come in
    }
    
    func peripheral(peripheral: CBPeripheral!,
        didUpdateValueForCharacteristic characteristic: CBCharacteristic!,
        error: NSError!) {
            if error {
                println("Error Updating Value of Characteristic: \(error.localizedDescription)");
            }
            
            var stringFromData:NSString = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding);
            println("Received: \(stringFromData)");
            
            // if this if case reached, we have finish receive all the data from the peripheral
            if stringFromData.isEqualToString("EOM") {
                
                // Do everything you want!
                var finalString:NSString = NSString(data: self.data, encoding: NSUTF8StringEncoding);
                println("!!!!!!ALL DATA RECEIVED!!!!!!!!: \(finalString)");
                
                if finalString.isEqualToString("CAT") {
                    self.isPhotoponorama = true;
                }
                else {
                    self.isPhotoponorama = false;
                    self.mainPID = finalString;
                }
                
                // Cancel Subscribtion
                peripheral.setNotifyValue(false, forCharacteristic: characteristic);
                
                // Disconnect from peripheral
                self.centralManager!.cancelPeripheralConnection(peripheral);
                
                
                // All the data has been received. Start Camera Shooting Action
                if self.isPhotoponorama {
                    self.clearImagePreview();
                    self.countDown(5, panoramaPhotoLeft: 5);
                }
                else {
                    self.clearImagePreview();
                    self.countDown(5, panoramaPhotoLeft: 0);
                }
                
                
            }
            else {
                // Not EOM, append data to what we already received
                self.data.appendData(characteristic.value);
            }
    }
    
    
    // whether our subscribe/unsubscribe happened or not
    func peripheral(peripheral: CBPeripheral!,
        didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!,
        error: NSError!) {
            if error {
                println("Error changing notification state: \(error.localizedDescription)");
            }
            
            
            // Check to see if it's our characteristic
            if (!characteristic.UUID.isEqual(CBUUID.UUIDWithString(temp2UUID))) {
                // Not the characteristic we want, exit
                return;
            }
            
            // The notification has started
            if characteristic.isNotifying {
                println("Notification began on \(characteristic)");
            }
            else {
                // The notification has stopped
                println("Notification stopped on \(characteristic). Disconnecting");
                self.centralManager!.cancelPeripheralConnection(peripheral);
            }
    }
    
    // Central disconnect Peripheral happened
    func centralManager(central: CBCentralManager!,
        didDisconnectPeripheral peripheral: CBPeripheral!,
        error: NSError!) {
            println("Peripheral Disconnected");
            self.discoveredPeriperal = nil;
            
            // We have been disconnected, start scanning again
            self.scan();
    }
    
    
    
    func cleanUp() {
        println("ready to clean up");
        // Do nothing if we are not connected
        if !self.discoveredPeriperal!.isConnected {
            return;
        }
        
        if self.discoveredPeriperal!.services != nil {
            for item:AnyObject in self.discoveredPeriperal!.services {
                var service:CBService = item as CBService;
                if service.characteristics != nil {
                    for itemChar:AnyObject in service.characteristics {
                        var characteristic:CBCharacteristic = itemChar as CBCharacteristic;
                        
                        // Finding the characteristic we may notified
                        if characteristic.UUID.isEqual(CBUUID.UUIDWithString(temp2UUID)) {
                            if characteristic.isNotifying {
                                // it is notifying, cancel notify here
                                self.discoveredPeriperal!.setNotifyValue(false, forCharacteristic: characteristic);
                                return;
                            }
                        }
                    }
                }
            }
        }
        
        // We are connected, but not notified, just unconnect the link
        self.centralManager!.cancelPeripheralConnection(self.discoveredPeriperal);
    }
    
}



/*
* This is for panorama Views
*/
extension BTCentralCamViewController {
    
    func upLoad() {
        
        
        println("Prepare Upload: Pid: \(self.pid), eye: \(self.eye)");
        println("MainPID: \(self.mainPID)");
        
        
        // Here, Upload Image to Server Using Http Post
        var imageData:NSData? = UIImagePNGRepresentation(self.imageToSave);
        var urlString:NSString = "http://107.170.171.175:3000/uploadImg";
        
        var request:NSMutableURLRequest = NSMutableURLRequest();
        request.HTTPMethod = "Post";
        request.URL = NSURL.URLWithString(urlString);
        var boundary:NSString = NSString.stringWithString("----WebKitFormBoundaryqFAZHDjmNaoRiQYZ");
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type");
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control");
        
        var body:NSMutableData = NSMutableData();
        body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"eye\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("\(self.eye)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"PID\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("\(self.pid)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"mainPID\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("\(self.mainPID)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"image\"; filename=\"upload.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Type: image/png\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSData.dataWithData(imageData));
        body.appendData(NSString.stringWithString("\r\n--\(boundary)--\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        var postLength:NSString = "\(body.length)";
        request.setValue(postLength, forHTTPHeaderField: "Content-Length");
        
        
        request.HTTPBody = body;
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:
            { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var httpResponse:NSHTTPURLResponse = response as NSHTTPURLResponse;
                println("response: \(response)");
                println("Status Code = \(httpResponse.statusCode)");
            });
        
        println("Finish Camera Function, Waiting for Uploading Response");
    }
    
    func stitch() {
        // var newView:UIView = UIView(frame:UIScreen.mainScreen().bounds);
        // newView.addSubview(spinner);
        // self.view = newView;
        // self.spinner.startAnimating();
        
        // var imageArray:UIImage[] = self.storeImage;
        
        // var stitchedImage:UIImage = CVWrapper.processWithArray(imageArray) as UIImage
        // UIImageWriteToSavedPhotosAlbum(stitchedImage, nil, nil, nil);
        
        // println("Stitch Complete");
    }
    
    func imageWithImage(image:UIImage, newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height));
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}

