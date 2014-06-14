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
    var nextViewButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var cameraVC: CameraVC = CameraVC(nibName: nil, bundle: nil);

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
        self.view.addSubview(self.nextViewButton);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // New Test Button For A New View Controller
        
        self.nextViewButton.setTitle("Next View", forState: UIControlState.Normal);
        self.nextViewButton.sizeToFit();
        self.nextViewButton.frame = CGRectMake((self.view.frame.width - self.nextViewButton.frame.width) / 2,
            100,
            self.nextViewButton.frame.width,
            self.nextViewButton.frame.height);
        self.nextViewButton.addTarget(self, action: "launchView:", forControlEvents: UIControlEvents.TouchUpInside);
        
    }
    
    func launchView(sender:UIButton) {
        println("Launch View");
        self.presentViewController(cameraVC, animated: true, completion: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
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
    
}
