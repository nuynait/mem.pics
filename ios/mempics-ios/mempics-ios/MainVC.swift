//
//  MainVC.swift
//  MemPics
//
//  Created by Jerry Shan on 2014-06-08.
//  Copyright (c) 2014 Jerry Shan. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    
    // Test View Button
    var centralCamViewButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var peripheralCamViewButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var centralCamVC: BTCentralCamViewController = BTCentralCamViewController(nibName: nil, bundle: nil);
    var peripheralCamVC: BTPeripheralCamViewController = BTPeripheralCamViewController(nibName: nil, bundle: nil);

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    override func loadView() {
        // Create a Main View
        var viewRect:CGRect = UIScreen.mainScreen().bounds;
        var mainView:UIView = UIView(frame:viewRect);
        self.view = mainView;
        
        // Add cameraViewButton Button
        self.view.addSubview(self.centralCamViewButton);
        self.view.addSubview(self.peripheralCamViewButton);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // New Test Button For A New View Controller
        
        self.centralCamViewButton.setTitle("Launch BTCentralCamViewController", forState: UIControlState.Normal);
        self.centralCamViewButton.sizeToFit();
        self.centralCamViewButton.frame = CGRectMake((self.view.frame.width - self.centralCamViewButton.frame.width) / 2,
            100,
            self.centralCamViewButton.frame.width,
            self.centralCamViewButton.frame.height);
        self.centralCamViewButton.addTarget(self, action: "launchCentralView:", forControlEvents: UIControlEvents.TouchUpInside);
        
        self.peripheralCamViewButton.setTitle("Launch BTPeripheralCamViewController", forState: UIControlState.Normal);
        self.peripheralCamViewButton.sizeToFit();
        self.peripheralCamViewButton.frame = CGRectMake((self.view.frame.width - self.peripheralCamViewButton.frame.width) / 2,
            200,
            self.peripheralCamViewButton.frame.width,
            self.peripheralCamViewButton.frame.height);
        self.peripheralCamViewButton.addTarget(self, action: "launchPeripheralView:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    func launchCentralView(sender:UIButton) {
        println("Launch Central View");
        self.presentViewController(centralCamVC, animated: true, completion: nil);
    }
    
    func launchPeripheralView(sender:UIButton) {
        println("Launch Peripheral View");
        self.presentViewController(peripheralCamVC, animated: true, completion: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    

    
}
