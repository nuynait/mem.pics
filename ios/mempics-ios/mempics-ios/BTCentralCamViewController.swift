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
            self.countDownComplete();
            return;
        }
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.countDown(second - 1);
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
                    println("Save to Album finished");
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
                
                // Cancel Subscribtion
                peripheral.setNotifyValue(false, forCharacteristic: characteristic);
                
                // Disconnect from peripheral
                self.centralManager!.cancelPeripheralConnection(peripheral);
                
                
                // All the data has been received. Start Camera Shooting Action
                self.countDown(5);
                
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

