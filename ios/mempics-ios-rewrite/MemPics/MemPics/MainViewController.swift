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
    var uploadModel:UploadModel?;
    
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
        
        
        // init ViewControllers
        self.upLoadViewController = UploadViewController(nibName: nil, bundle: nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Render View
        self.currentState!.paring(self.bluetoothCentralModel!);

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.avSessionSetupImp!.setupAVSession(self.avFoundationModel!, mainView: self.mainView!);
        drawView();
    }
    
    
    
    
    // Set State Function
    // if state == false, means central
    // if state == true, means peripheral
    func setState(state:Bool) {
        if state {
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
            return;
        }
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.countDown(second - 1, photoLeft: photoLeft);
            });
    }
    
    func switchToUploadViewController() {
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
        self.mainView!.takePictureButton.addTarget(self, action: "takePictureButtonPressed", forControlEvents: UIControlEvents.TouchUpInside);
        self.mainView!.camSwitch.addTarget(self, action: "camSwitchSwitcherFliped", forControlEvents: UIControlEvents.TouchUpInside);
        self.mainView!.panoramaSwitch.addTarget(self, action: "panoramaSwitchFliped", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    // targets action Functions
    func takePictureButtonPressed(sender: UIButton) {
        self.mainView!.takePictureButton.enabled = false;
        self.currentState!.boardCasting(self.bluetoothCentralModel!);
    }

    
    func camSwitchSwitcherFliped(sender: UISwitch) {
        self.setState(sender.on);
    }

    
    
    func panoramaSwitchFliped(sender: UISwitch) {
        if sender.on {
            self.avSessionSetupImp = AVPanoramicPhotoSessionSetupImp();
            self.successActionImp = PanoramicPhotoSuccessActionImp();
        }
        else {
            self.avSessionSetupImp = AVPhotoSessionSetupImp();
            self.successActionImp = PhotoSuccessActionImp();
        }
        
    }
    
}

// Update Model Methods
extension MainViewController {
    func updateFromBTLECentralModel(state:BTLECentralState, stringReceived:NSString) {
        println("Receive Notify From BTLE CentralModel");
        
        switch state {
            
        case BTLECentralState.EOMReceived:
            // Run Success Function
            println("Case: BTLECentralState.EOMRecieved");
            self.upLoadViewController!.uploadModel.mainPid = stringReceived;
            self.upLoadViewController!.uploadModel.eye = "l";
        }
        
    }
    
    func updateFromBTLEPeripheralModel(state:BTLEPeripheralState) {
        println("Receive Notify From BTLE CentralModel");
        
        switch state {
            
        case BTLEPeripheralState.EOMSent:
            // Run Success Function
            println("Case: BTLEPeripheralState.EOMSent");
            self.upLoadViewController!.uploadModel.mainPid = DeviceInfo.getDevicePid();
            self.upLoadViewController!.uploadModel.eye = "r";
        }
    }
}

