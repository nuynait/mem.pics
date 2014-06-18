//
//  CameraVC.swift
//  MemPics
//  Out Dated! May Not Use This Version Of Camera Picker
//
//  Created by Tianyun Shan on 6/10/14.
//  Copyright (c) 2014 Jerry Shan. All rights reserved.
//

import UIKit

class CameraVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Button to Call Camera View
    var cameraViewButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var lastViewButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    
    // Image Picker View Controller
    var cameraUI:UIImagePickerController = UIImagePickerController();
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    override func loadView() {
        // Render view
        var mainView:UIView = UIView(frame:UIScreen.mainScreen().bounds);
        self.view = mainView;
        
        self.view.addSubview(self.cameraViewButton);
        self.view.addSubview(self.lastViewButton);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Subviews
        buttonLoad(self.cameraViewButton, title: "Launch Camera", state: UIControlState.Normal, yPoint:100);
        self.cameraViewButton.addTarget(self, action: "cameraViewButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
        
        buttonLoad(self.lastViewButton, title: "Last View", state: UIControlState.Normal, yPoint: self.cameraViewButton.frame.maxY + 10);
        self.lastViewButton.addTarget(self, action: "lastViewButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    // render a button in the middle of the line for x-axis
    // input variable: 
    // 1. button title and state. 
    // 2. y-axis point
    func buttonLoad(target:UIButton, title:NSString, state:UIControlState, yPoint:CGFloat) {
        target.setTitle(title, forState: state);
        target.sizeToFit();
        target.frame = CGRectMake((self.view.frame.width - target.frame.width) / 2,
            yPoint,
            target.frame.width,
            target.frame.height);
    }
    
    func lastViewButtonPressed(sender:UIButton) {
        self.dismissModalViewControllerAnimated(true);
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
            self.cameraUI.sourceType = UIImagePickerControllerSourceType.Camera;
            self.cameraUI.delegate = self;
            self.cameraUI.allowsEditing = false;
            self.presentModalViewController(self.cameraUI, animated: true);
            return true;
        }
        return false
    }
    
    // *********************************************************************************************
    // Camera Delegate Method
    
    // For responding to the user tapping cancel
    func imagePickerControllerDidCancel (picker:UIImagePickerController) {
        // dismiss the camera picker when user tap cancel
        self.dismissModalViewControllerAnimated(true);
    }
    
    // For responding to the user accepting a newly-captured picture
    func imagePickerController(_picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        var mediaType:NSString = info.objectForKey(UIImagePickerControllerMediaType) as NSString;
        var originalImage:UIImage?;
        var editedImage:UIImage?;
        var imageToSave:UIImage?;
        
        
        // Handle a still image capture
        if (mediaType.isEqualToString("public.image")){
            editedImage = info.objectForKey(UIImagePickerControllerEditedImage) as? UIImage;
            originalImage = info.objectForKey(UIImagePickerControllerOriginalImage) as? UIImage;
            
            if (editedImage) {
                imageToSave = editedImage;
            }
            else {
                imageToSave = originalImage;
            }
            
            // Here, Upload Image to Server Using Http Post
            var imageData:NSData? = UIImagePNGRepresentation(imageToSave);
            var urlString:NSString = "http://107.170.171.175:49156/tasks";
            
            var request:NSMutableURLRequest = NSMutableURLRequest();
            request.HTTPMethod = "Post";
            request.URL = NSURL.URLWithString(urlString);
            var boundary:NSString = NSString.stringWithString("----WebKitFormBoundaryqFAZHDjmNaoRiQYZ");
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type");
            request.setValue("no-cache", forHTTPHeaderField: "Cache-Control");
            
            var body:NSMutableData = NSMutableData();
            body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
            body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"task\"; filename=\"upload.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding));
            //body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"task\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
            //body.appendData(NSString.stringWithString("TEST\r\n").dataUsingEncoding(NSUTF8StringEncoding));
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
        else {
            println("ERROR: If Case Passed, test FAILED, mediaType = \(mediaType)");
        }
        
        // Dismiss image Picker
        self.dismissModalViewControllerAnimated(true);
        
    }
    // *********************************************************************************************
    
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
