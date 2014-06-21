//
//  BTPeripheralCamViewController.swift
//  mempics-ios
//
//  Created by Tianyun Shan on 2014-06-18.
//  Copyright (c) 2014 Jerry Shan. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth

class BTPeripheralCamViewController: UIViewController, CBPeripheralManagerDelegate {
    
    var session:AVCaptureSession = AVCaptureSession();
    var takePictureButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var focusDotLabel:UILabel = UILabel();
    var countDownLabel:UILabel = UILabel();
    
    
    
    // Bluetooth
    var dataToSend:NSData?;
    var sendDataIndex:NSInteger?;
    var sendingEOM:Bool = false;
    var stringToSend:NSString?;
    var peripheralManager:CBPeripheralManager?;
    var transferCharacteristic:CBMutableCharacteristic?;
    var advertisingSwitch:Bool = false;
    
    
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
        
        self.view.addSubview(self.countDownLabel);
        self.view.addSubview(self.takePictureButton);
        self.view.addSubview(self.focusDotLabel);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup All the Sessions
        avSessionSetup();
        
        // Setup All subviews
        subViewSetup();
        
        // Start up the CBPeripheralManger
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil);
        self.stringToSend = "This is a test!!!!! This is really a test!!!!! Please Trust me, this is absolutly a test!!!!";
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


// All the AV Foundation Setups
extension BTPeripheralCamViewController {
    
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
        var videoDevice:AVCaptureDevice = BTPeripheralCamViewController.deviceWithMediaType(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back);
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
extension BTPeripheralCamViewController {
    
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
        /*
        // Count Down 5 Seconds
        // Count Down Runs In A Seperate Thread
        println("Start Count Down");
        countDown(5);
        */
        
        self.advertisingSwitch = true;
        println("Start Advertising");
        self.peripheralManager!.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [CBUUID.UUIDWithString(tempUUID)]]);
        
        // Button Disable
        self.takePictureButton.enabled = false;
        
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
        
        // Reenable Button
        self.takePictureButton.enabled = true;
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


// Add all core bluetooth functions
extension BTPeripheralCamViewController {
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        // Check Bluetooth Avalibility
        if peripheral.state != CBPeripheralManagerState.PoweredOn {
            println("Bluetooth NOT Avaliable!");
            return;
        }
        
        println("peripheral Manager powered on");
        
        
        // Build out the characteristic
        self.transferCharacteristic = CBMutableCharacteristic(
            type: CBUUID.UUIDWithString(temp2UUID),
            properties: CBCharacteristicProperties.Notify,
            value: nil,
            permissions: CBAttributePermissions.Readable);
        
        // Build out the service
        var transferService:CBMutableService = CBMutableService(type: CBUUID.UUIDWithString(tempUUID), primary: true);
        
        // Add characteristic to the service
        // Service contains an array of characteristics
        transferService.characteristics = [self.transferCharacteristic!];
        
        // Add service to the peripheral manager
        self.peripheralManager!.addService(transferService);
    }
    
    // Catch when someone subscribe to our characteristic
    // Start send them data
    func peripheralManager(peripheral: CBPeripheralManager!,
        central: CBCentral!,
        didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
            println("Central subscribed to characteristic");
            
            // Get the data
            self.dataToSend = self.stringToSend!.dataUsingEncoding(NSUTF8StringEncoding);
            
            // Reset the index
            // Because this is the first time central subscribe to peripheral
            // All the data needs to be resended
            self.sendDataIndex = 0;
            self.sendingEOM = false;
            
            
            // SendData
            self.sendData();
            
    }
    
    
    // This function get called when peripheral manager is ready to send
    // the next chunk of data. This is ensure that packets will arrive in 
    // the order they are sent
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        
        // Start sending again
        self.sendData();
        
    }
    
    
    func sendData() {
        
        if sendingEOM {
            var eomString:NSString = "EOM";
            
            // Sending EOM
            var didSend:Bool = self.peripheralManager!.updateValue(eomString.dataUsingEncoding(NSUTF8StringEncoding),
                forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil);
            
            // If EOM is already sent
            if didSend {
                // Mark EOM has been sent
                self.sendingEOM = false;
                
                // Turn off the advertise
                self.peripheralManager!.stopAdvertising();
                self.advertisingSwitch = false;
                
                // Run CountDown Action
                self.countDown(5);
                
                println("sent EOM");
            }
            
            return;
            
        }
        
        
        // Send actual data
        
        // first check if there is any data left to send
        if self.sendDataIndex >= self.dataToSend!.length {
            
            // No more data to send, Do nothing
            return;
        }
        
        
        // There is data to send, send until the callback fails, or we're done
        var didSend:Bool = true;
        
        while didSend {
            
            // Calc how big it should to be
            var amountToSend:NSInteger = self.dataToSend!.length - self.sendDataIndex!;
            
            println("Prepare Sending Data, amountToSend: \(amountToSend), dataToSend.length: \(self.dataToSend!.length)")
            
            // Bluetooth can only send no more than 20 bytes
            // Check if we need to send more than 20 bytes data
            if amountToSend > 20 {
                amountToSend = 20;
                println("amountToSend exceeds 20 bytes, thus change amountToSend to 20");
            }
            
            // Copy out the data we need to send
            var startRange:NSInteger = self.sendDataIndex!;
            var endRange:NSInteger = amountToSend;
            var chunk:NSData = self.dataToSend!.subdataWithRange(NSMakeRange(startRange, endRange));
            
            // Debug
            var chunkString:NSString = NSString(data: chunk, encoding: NSUTF8StringEncoding);
            println("Send Out Data: String: \(chunkString), startRange: \(startRange), endRange: \(endRange)");
            
            
            // Send the chunk
            didSend = self.peripheralManager!.updateValue(chunk,
                forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil);
            
            // if it didn't work, drop out and wait for the callback
            if !didSend {
                println("Didn't work. Drop out Wait for the callback");
                return;
            }
            
            // if did send, update our index
            self.sendDataIndex = self.sendDataIndex! + amountToSend;
            
            
            // check if it is the last one
            // if it is last one, we need to send out the eom string
            
            if self.sendDataIndex >= self.dataToSend!.length {
                
                // Send EOM
                // Set Sending EOM to true, so if the first time failes
                // we can still resend it
                self.sendingEOM = true;
                
                // Send ROM
                var eomString:NSString = "EOM";
                
                // Sending EOM
                var eomSent:Bool = self.peripheralManager!.updateValue(eomString.dataUsingEncoding(NSUTF8StringEncoding),
                    forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil);
                
                // If EOM is already sent
                if eomSent {
                    // Mark EOM has been sent
                    self.sendingEOM = false;
                    
                    
                    // Turn off the advertise 
                    self.peripheralManager!.stopAdvertising();
                    self.advertisingSwitch = false;
                    
                    // Run CountDown Action
                    self.countDown(5);
                    
                    println("sent EOM");
                }
                
                return;
                
            }
        }
    }
    
    // This function get called when central unsubscribes
    func peripheralManager(peripheral: CBPeripheralManager!,
        central: CBCentral!,
        didUnsubscribeFromCharacteristic characteristic: CBCharacteristic!) {
            println("Central unsubscribed from characteristic");
    }
}
