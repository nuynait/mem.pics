//
//  MainViewController.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import CoreBluetooth

class MainViewController: UIViewController {
    
    // Model
    var avFoundationModel:AVFoundationDeviceModel?;
    var bluetoothCentralModel:BTLECentralModel?;
    var bluetoothPeripheralModel:BTLEPeripheralModel?;
    var barCodeModel:BarCodeModel?;
    var deviceInfo:DeviceInfo?;
    
    
    // Bridge
    var avSessionSetupImp:AVSessionSetupImp?;
    var successActionImp:SuccessActionImp?;
    
    
    // States
    var currentState:CamState?;
    var centralState:CentralState?;
    var peripheralState:PeripheralState?;
    var qrCodeState:QRCodeState?;
    
    
    // Variable For CountDown Use
    var second:NSInteger?;
    var photoTaken:NSInteger = 4;
    var photoLeft:NSInteger?;

    
    // View
    var mainView:MainView?;
    
    
    // UpLoad?;
    var upLoadViewController:UploadViewController?;
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.centralState = CentralState();
        self.peripheralState = PeripheralState();
        self.qrCodeState = QRCodeState();
        self.currentState = CentralState();
        self.avSessionSetupImp = AVPhotoSessionSetupImp();
        self.successActionImp = PhotoSuccessActionImp();
        // init Models
        self.bluetoothCentralModel = BTLECentralModel(mainVC: self);
        self.bluetoothPeripheralModel = BTLEPeripheralModel(mainVC: self);
        self.avFoundationModel = AVFoundationDeviceModel();
        self.barCodeModel = BarCodeModel(avModel: self.avFoundationModel!, mainViewController: self);
        self.deviceInfo = DeviceInfo();
        
        
        
        // init ViewControllers
        self.upLoadViewController = UploadViewController(nibName: nil, bundle: nil);
    }

    override func loadView() {
        // init View
        self.mainView = MainView(frame: UIScreen.mainScreen().bounds);
        self.view = mainView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Render View
        println("Prepare Set AVSession");
        self.avSessionSetupImp!.setupAVSession(self.avFoundationModel!, mainView: self.mainView!);
        drawView();
        self.mainView!.imagePreviewSetupTesting();
        //self.mainView!.imagePreviewSetup();
        
        
        self.addSubViewTargets();
        self.currentState!.turnOnBluetooth(self.bluetoothCentralModel!, peripheral: self.bluetoothPeripheralModel!);
        
        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // Set State Function
    // if state == false, means central
    // if state == true, means peripheral
    func setState(state:Bool) {
        if state {
            println("Change Current State to Peripheral State");
            self.currentState = self.peripheralState!;
        }
        else {
            self.currentState = self.centralState!;
        }
    }
    
    // A countDown
    func countDown(time:NSInteger, photoLeft:NSInteger) {
        self.second = time;
        self.photoLeft = photoLeft;
        println("CountDowning: \(second)");
        
        self.currentState!.BTLESendCountDown(self.second!, peripheral: bluetoothPeripheralModel!);
        
        if second == 0 {
            // self.successActionImp!.countDownComplete(photoLeft, mainVC: self);
            self.mainView!.bluetoothStatusLabelRedraw("Waiting For Trigger...");
            return;
        }
        
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.countDown(self.second! - 1, photoLeft: photoLeft);
            });
    }
    
    func switchToUploadViewController() {
        println("Before Present uploadViewController, Check Stored Image Size: \(self.upLoadViewController!.uploadModel!.imageStored.count)");
        self.presentViewController(self.upLoadViewController!, animated: true, completion: nil);
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


// Subview Related
extension MainViewController {
    
    // Render views depending on different states
    func drawView() {
        self.currentState!.subViewSetup(self.mainView!);
    }
    
    // Add subview targets
    // Button Listeners
    func addSubViewTargets() {
        self.mainView!.takePictureButton.addTarget(self, action: "takePictureButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
        self.mainView!.camSwitch.addTarget(self, action: "camSwitchSwitcherFliped:", forControlEvents: UIControlEvents.TouchUpInside);
        self.mainView!.panoramaSwitch.addTarget(self, action: "panoramaSwitchFliped:", forControlEvents: UIControlEvents.TouchUpInside);
        self.mainView!.qrCodeScanButton.addTarget(self, action: "qrCodeScanButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    // targets action Functions
    // Bluetooth triggerType is 0
    func takePictureButtonPressed(sender:UIButton) {
        self.mainView!.bluetoothStatusLabelRedraw("Take Action");
        self.upLoadViewController!.uploadModel!.mainPid = DeviceInfo.getDevicePid();
        self.upLoadViewController!.uploadModel!.eye = "r";
        self.upLoadViewController!.uploadModel!.clearArray();
        self.mainView!.takePictureButton.enabled = false;
        
        self.currentState!.BTLETrigger(self.bluetoothPeripheralModel!, triggerType: 0, panoramicPhoto: self.mainView!.panoramaSwitch.on);
    }

    
    func camSwitchSwitcherFliped(sender:UISwitch) {
        println("camSwitch Switcher Flipped: currentState: \(sender.on)");
        self.setState(sender.on);
        self.currentState!.subViewSetup(self.mainView!);
        self.currentState!.turnOnBluetooth(bluetoothCentralModel!, peripheral: bluetoothPeripheralModel!);
    }
    
    
    // If this switch is flipped, a bluetooth signal is sending to the central
    // The central setup the implementation method to the correct method
    // Bluetooth triggerType is 1
    func panoramaSwitchFliped(sender:UISwitch) {
        if sender.on {
            self.avSessionSetupImp = AVPanoramicPhotoSessionSetupImp();
            self.successActionImp = PanoramicPhotoSuccessActionImp();
        }
        else {
            self.avSessionSetupImp = AVPhotoSessionSetupImp();
            self.successActionImp = PhotoSuccessActionImp();
            self.avSessionSetupImp!.setupAVSession(self.avFoundationModel!, mainView: self.mainView!);
            self.currentState!.subViewSetup(self.mainView!);
        }
        self.currentState!.BTLETrigger(self.bluetoothPeripheralModel!, triggerType: 1, panoramicPhoto: self.mainView!.panoramaSwitch.on);
    }
    
    func qrCodeScanButtonPressed(sender:UISwitch) {
        // QRCode Scanner Button Pressed
        if self.mainView!.qrCodeModeOn == true {
            self.mainView!.qrCodeModeOn = false;
        }
        else {
            self.mainView!.qrCodeModeOn = true;
        }
        self.mainView!.qrCodeScanButtonSetup();
    }
    
    
    func notifiedFromQRCodeModel() {
        self.setState(false);
        self.currentState!.subViewSetup(self.mainView!);
    }
    

    
}



// Update Model Methods
extension MainViewController {
    func updateFromBTLECentralModel(state:BTLECentralState, stringReceived:NSString) {
        println("Receive Notify From BTLE CentralModel");
        
        switch state {
            
        case BTLECentralState.Connecting:
            println("Case: BTLECentralState.Connecting");
            self.mainView!.bluetoothStatusLabelRedraw("Connecting...");
            
        case BTLECentralState.Connected:
            println("Case: BTLECentralState.Connected");
            self.mainView!.bluetoothStatusLabelRedraw("Waiting For PID");
            
            self.photoLeft = self.photoTaken;
            
        case BTLECentralState.PIDReceived:
            println("Case: BTLECentralState.PIDReceived");
            self.deviceInfo!.mainPid = self.bluetoothCentralModel!.stringReceived;
            
            println("Main PID Received, mainPID: \(self.deviceInfo!.mainPid)");
            self.mainView!.bluetoothStatusLabelRedraw("Waiting For Trigger ...");
            
        case BTLECentralState.PanoramicModeSetup:
            println("Case: BTLECentralState.PanoramicModeSetup");
            self.avSessionSetupImp = AVPanoramicPhotoSessionSetupImp();
            self.successActionImp = PanoramicPhotoSuccessActionImp();
            println("Setup Panoramic Mode finished");
            
        case BTLECentralState.PhotoModeSetup:
            println("Case: BTLECentralState.PhotoModeSetup");
            self.avSessionSetupImp = AVPhotoSessionSetupImp();
            self.successActionImp = PhotoSuccessActionImp();
            println("Setup Photo Mode Finished");
            self.avSessionSetupImp!.setupAVSession(self.avFoundationModel!, mainView: self.mainView!);
            self.currentState!.subViewSetup(self.mainView!);
            println("SETUP AVSESSION PREVIEW");
            
        case BTLECentralState.TakePhotoTriggerReceived:
            println("Case: BTLECentral.TakePictureTriggerReceived");
            self.mainView!.bluetoothStatusLabelRedraw("Take Action");
            self.upLoadViewController!.uploadModel!.mainPid = self.deviceInfo!.mainPid;
            self.upLoadViewController!.uploadModel!.eye = "l";
            self.upLoadViewController!.uploadModel!.clearArray();
            
            println("Take Picture Action");
            // self.successActionImp!.startCountDown(self);
            
        case BTLECentralState.TakePanoramicTriggerReceived:
            println("Case: BTLECentral.TakePanoramicTriggerReceived");
            self.mainView!.bluetoothStatusLabelRedraw("Take Action");
            self.upLoadViewController!.uploadModel!.mainPid = self.deviceInfo!.mainPid;
            self.upLoadViewController!.uploadModel!.eye = "l";
            self.upLoadViewController!.uploadModel!.clearArray();
            
            println("SETUP AVSESSION PREVIEW");
            self.avSessionSetupImp!.setupAVSession(self.avFoundationModel!, mainView: self.mainView!);
            // self.successActionImp!.startCountDown(self);
            
        case BTLECentralState.CountDownReceived:
            println("Case: BTLECentral.CountDownReceived");
            self.mainView!.countDownLabelRedraw(stringReceived);
            
        case BTLECentralState.CountDownCompleteReceived:
            println("Case: BTLECentral.CountDownCompleteReceived");
            
            self.mainView!.countDownLabel.text = "";
            self.mainView!.flashScreen();
            
            if (self.photoLeft == 1) {
                self.successActionImp!.countDownComplete(1, mainVC: self);
                self.photoLeft == photoTaken;
            }
            else {
                self.successActionImp!.countDownComplete(-1, mainVC: self);
            }
            
            
        default:
            println("ERROR, Not an Avaliable bluetooth state");
        }
        
    }
    
    func updateFromBTLEPeripheralModel(state:BTLEPeripheralState) {
        println("Receive Notify From BTLE Peripheral Model");
        
        switch state {
        case BTLEPeripheralState.Connecting:
            println("Case: BTLEPeripheralState.Connecting");
            self.mainView!.bluetoothStatusLabelRedraw("Connecting");
            
        case BTLEPeripheralState.Connected:
            println("Case: BTLEPeripheralState.Connected");
            self.mainView!.bluetoothStatusLabelRedraw("Connected");
            
            
            println("Device is Connected, Now Peripheral Sending the Central The Device ID");
            // Peripheral Connected
            // Send the Peripheral's Device ID to Central
            self.bluetoothPeripheralModel!.setupStringToSend(DeviceInfo.getDevicePid());
            self.bluetoothPeripheralModel!.sendData();
            
            println("Device ID: \(DeviceInfo.getDevicePid()) SENT!");
            // self.bluetoothPeripheralModel!.sendEOMString();
            
            
        case BTLEPeripheralState.SendData:
            println("Case: BTLEPeripheralState.SendData");
            self.mainView!.bluetoothStatusLabelRedraw("Sending Data")
            
        case BTLEPeripheralState.WaitingTrigger:
            println("Case: BTLEPeripheralState.WaitingTrigger");
            self.mainView!.bluetoothStatusLabelRedraw("Waiting User Action");
            
        case BTLEPeripheralState.SentPhotoTrigger:
            println("Case: BTLEPeripheralState.SentPhotoTrigger");
            self.mainView!.bluetoothStatusLabelRedraw("Take Action");
            self.upLoadViewController!.uploadModel!.mainPid = DeviceInfo.getDevicePid();
            self.upLoadViewController!.uploadModel!.eye = "r";
            self.upLoadViewController!.uploadModel!.clearArray();
            
            println("Take Picture Action");
            self.successActionImp!.startCountDown(self);
            
        case BTLEPeripheralState.SentPanoramicTrigger:
            println("Case BTLEPeripheralState.SentPanoramicTrigger");
            
            println("Case: BTLECentral.TakePanoramicTriggerReceived");
            self.mainView!.bluetoothStatusLabelRedraw("Take Action");
            self.upLoadViewController!.uploadModel!.mainPid = DeviceInfo.getDevicePid();
            self.upLoadViewController!.uploadModel!.eye = "r";
            self.upLoadViewController!.uploadModel!.clearArray();
            
            println("SETUP AVSESSION PREVIEW");
            self.avSessionSetupImp!.setupAVSession(self.avFoundationModel!, mainView: self.mainView!);
            self.successActionImp!.startCountDown(self);
            
        case BTLEPeripheralState.SentCountDown:
            println("Case BTLEPeripheralState.SentCountDown, Second: \(self.second)");
            self.mainView!.countDownLabelRedraw("\(self.second)");
            
        case BTLEPeripheralState.SentCountDownComplete:
            println("Case BTLEPeripheralState.COMPLETE");
            
            self.mainView!.countDownLabel.text = "";
            self.mainView!.flashScreen();
            self.successActionImp!.countDownComplete(self.photoLeft!, mainVC: self);

        default:
            println("ERROR, Not an Avaliable bluetooth state");
        }
    }
    
}

