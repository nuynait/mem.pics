//
//  MainVC.swift
//  MemPics
//
//  Created by Jerry Shan on 2014-06-08.
//  Copyright (c) 2014 Jerry Shan. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var cameraViewButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;

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
        self.view.addSubview(self.cameraViewButton);
    }

    override func viewDidLoad() {
        super.viewDidLoad();

        // cameraViewButton Property
        
        println("What is width? Answer: \(self.view.frame.width/2)");
        cameraViewButton.setTitle("Launch Camera", forState: UIControlState.Normal);
        cameraViewButton.sizeToFit();
        println("What is cameraViewButton.frame.width? \(cameraViewButton.frame.width)");
        cameraViewButton.frame = CGRectMake(100,
            (self.view.frame.width - cameraViewButton.frame.width) / 2,
            cameraViewButton.frame.width,
            cameraViewButton.frame.height);
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
