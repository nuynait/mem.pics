//
//  CameraVC.swift
//  MemPics
//
//  Created by Tianyun Shan on 6/10/14.
//  Copyright (c) 2014 Jerry Shan. All rights reserved.
//

import UIKit

class CameraVC: UIViewController {
    
    // Button to Call Camera View
    var cameraViewButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    override func loadView() {
        // Render view
        var mainView:UIView = UIView(frame:UIScreen.mainScreen().bounds);
        self.view = mainView;
        
        self.view.addSubview(self.cameraViewButton);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Subviews
        self.cameraViewButton.setTitle("Launch Camera", forState: UIControlState.Normal);
        self.cameraViewButton.sizeToFit();
        self.cameraViewButton.frame = CGRectMake((self.view.frame.width - self.cameraViewButton.frame.width) / 2,
            100,
            self.cameraViewButton.frame.width,
            self.cameraViewButton.frame.height);
        self.cameraViewButton.addTarget(self, action: "cameraViewButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    
    // Launch Camera Picker Button Pressed
    // Use LaunchCamera function to launch camera picker
    // if launchCamera picker returns false, pop up a no camera alert
    func cameraViewButtonPressed(sender:UIButton) {
        var hasCamera:Bool = launchCamera();
        if (!hasCamera){
            println("Alart, No Camera Avaliable");
        }
    }
    
    // Launch Camera Function Use
    // Test if the camera exist first
    // Then present the camera view
    func launchCamera() -> Bool {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var cameraUI:UIImagePickerController = UIImagePickerController();
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera;
            cameraUI.allowsEditing = false;
            self.presentModalViewController(cameraUI, animated: true);
            return true;
        }
        return false
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

}
