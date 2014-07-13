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
    
    // Bridge
    var avSessionSetupImp:AVSessionSetupImp?;
    var successActionImp:SuccessActionImp?;
    
    
    // States
    var currentState:CamState?;
    var centralState:CentralState?;
    var peripheralState:PeripheralState?;

    
    // View
    var mainView:MainView?;
    
    
    // UpLoad?;
    var upLoadViewController:UploadViewController?;
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.centralState = CentralState();
        self.peripheralState = PeripheralState();
        self.currentState = CentralState();
        self.avSessionSetupImp = AVPhotoSessionSetupImp();
        self.successActionImp = PhotoSuccessActionImp();
        // init Models
        self.bluetoothCentralModel = BTLECentralModel(mainVC: self);
        self.bluetoothPeripheralModel = BTLEPeripheralModel(mainVC: self);
        self.avFoundationModel = AVFoundationDeviceModel();
        
        
        
        
        


        
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
        var second:NSInteger = time;
        println("CountDowning: \(second)");
        self.mainView!.countDownLabelRedraw("\(second)");
        if second == 0 {
            self.successActionImp!.countDownComplete(photoLeft, mainVC: self);
            self.mainView!.bluetoothStatusLabelRedraw("Waiting For Trigger...");
            return;
        }
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.countDown(second - 1, photoLeft: photoLeft);
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
    }
    
    // targets action Functions
    func takePictureButtonPressed(sender:UIButton) {
        self.mainView!.takePictureButton.enabled = false;
        self.currentState!.BTLETrigger(self.bluetoothPeripheralModel!, panoramicPhoto: self.mainView!.camSwitch.on);
    }

    
    func camSwitchSwitcherFliped(sender:UISwitch) {
        println("camSwitch Switcher Flipped: currentState: \(sender.on)");
        self.setState(sender.on);
        self.currentState!.subViewSetup(self.mainView!);
        self.currentState!.turnOnBluetooth(bluetoothCentralModel!, peripheral: bluetoothPeripheralModel!);
    }

    
    
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
            self.mainView!.bluetoothStatusLabelRedraw("Waiting For Trigger ...");
            
        case BTLECentralState.EOMReceived:
            // Run Success Function
            
            self.avSessionSetupImp = AVPhotoSessionSetupImp();
            self.successActionImp = PhotoSuccessActionImp();
            self.avSessionSetupImp!.setupAVSession(self.avFoundationModel!, mainView: self.mainView!);
            self.currentState!.subViewSetup(self.mainView!);
            
            
            println("Case: BTLECentralState.EOMRecieved");
            self.mainView!.bluetoothStatusLabelRedraw("Take Action");
            self.upLoadViewController!.uploadModel!.mainPid = stringReceived;
            self.upLoadViewController!.uploadModel!.eye = "l";
            self.upLoadViewController!.uploadModel!.clearArray();
            
            self.successActionImp!.startCountDown(self);
        case BTLECentralState.EOMReceivedPanoramic:
            self.avSessionSetupImp = AVPanoramicPhotoSessionSetupImp();
            self.successActionImp = PanoramicPhotoSuccessActionImp();
            self.avSessionSetupImp!.setupAVSession(self.avFoundationModel!, mainView: self.mainView!);
            self.currentState!.subViewSetup(self.mainView!);
            
            self.successActionImp!.startCountDown(self);
            
        default:
            println("ERROR, Not an Avaliable bluetooth state");
        }
        
    }
    
    func updateFromBTLEPeripheralModel(state:BTLEPeripheralState) {
        println("Receive Notify From BTLE CentralModel");
        
        switch state {
        case BTLEPeripheralState.Connecting:
            println("Case: BTLEPeripheralState.Connecting");
            self.mainView!.bluetoothStatusLabelRedraw("Connecting");
            
        case BTLEPeripheralState.Connected:
            println("Case: BTLEPeripheralState.Connected");
            self.mainView!.bluetoothStatusLabelRedraw("Connected");
            
        case BTLEPeripheralState.SendData:
            println("Case: BTLEPeripheralState.SendData");
            self.mainView!.bluetoothStatusLabelRedraw("Sending Data")
            
        case BTLEPeripheralState.EOMSent:
            // Run Success Function
            println("Case: BTLEPeripheralState.EOMSent");
            self.mainView!.bluetoothStatusLabelRedraw("Take Action");
            self.upLoadViewController!.uploadModel!.mainPid = DeviceInfo.getDevicePid();
            self.upLoadViewController!.uploadModel!.eye = "r";
            self.upLoadViewController!.uploadModel!.clearArray();
            self.successActionImp!.startCountDown(self);
            
        case BTLEPeripheralState.EOMSentPanoramic:
            self.avSessionSetupImp = AVPanoramicPhotoSessionSetupImp();
            self.successActionImp = PanoramicPhotoSuccessActionImp();
            self.avSessionSetupImp!.setupAVSession(self.avFoundationModel!, mainView: self.mainView!);
            self.currentState!.subViewSetup(self.mainView!);
            
            self.successActionImp!.startCountDown(self);
            
        default:
            println("ERROR, Not an Avaliable bluetooth state");
        }
    }
    
}

