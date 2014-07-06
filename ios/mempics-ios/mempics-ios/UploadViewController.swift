//
//  UploadViewController.swift
//  mempics-ios
//
//  Created by Tianyun Shan on 2014-06-25.
//  Copyright (c) 2014 Jerry Shan. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {
    
    var eye:NSString?;
    var pid:NSString?;
    var mainPID:NSString?;
    var imageToSave:UIImage?;
    
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
    var statusLabel:UILabel = UILabel();
    var retryButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var dismissVCButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    override func loadView()  {
        var mainView:UIView = UIView(frame: UIScreen.mainScreen().bounds);
        mainView.backgroundColor = UIColor.blackColor();
        self.view = mainView;
        
        self.view.addSubview(self.statusLabel);
        self.view.addSubview(self.spinner);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinner.sizeToFit();
        self.spinner.frame = CGRectMake(
            (self.view.frame.width - self.spinner.frame.width) / 2,
            (self.view.frame.height - self.spinner.frame.height) / 2,
            self.spinner.frame.width,
            self.spinner.frame.height);
        
        self.statusLabelRedraw("Prepare Upload");
     
        // Do any additional setup after loading the view.
    }
    
    func statusLabelRedraw(labelText:NSString) {
        self.statusLabel.textColor = UIColor.whiteColor();
        self.statusLabel.text = labelText;
        self.statusLabel.sizeToFit();
        self.statusLabel.frame = CGRectMake(
            (self.view.frame.width - self.statusLabel.frame.width) / 2,
            self.spinner.frame.maxY + 10,
            self.statusLabel.frame.width, self.statusLabel.frame.height);
        
        self.retryButton.setTitle("Retry", forState: UIControlState.Normal);
        self.retryButton.sizeToFit();
        self.retryButton.frame = CGRectMake(
            (self.view.frame.width - self.retryButton.frame.width) / 2,
            self.statusLabel.frame.maxY + 50,
            self.retryButton.frame.width, self.retryButton.frame.height);
        self.retryButton.addTarget(self, action: "retryButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
        
        self.dismissVCButton.setTitle("Back to Camera", forState: UIControlState.Normal);
        self.dismissVCButton.sizeToFit();
        self.dismissVCButton.frame = CGRectMake(
            (self.view.frame.width - self.dismissVCButton.frame.width) / 2,
            self.retryButton.frame.maxY + 10,
            self.dismissVCButton.frame.width,
            self.dismissVCButton.frame.height);
        self.dismissVCButton.addTarget(self, action: "dismissButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    func retryButtonPressed (sender:UIButton) {
        self.retryButton.removeFromSuperview();
        self.dismissVCButton.removeFromSuperview();
        self.upLoad();
    }
    
    func dismissButtonPressed (sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.retryButton.removeFromSuperview();
        self.dismissVCButton.removeFromSuperview();
        self.spinner.startAnimating();
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.upLoad();
            });
    }
    
    func upLoad() {
        
        
        println("Prepare Upload: Pid: \(self.pid), eye: \(self.eye)");
        println("MainPID: \(self.mainPID)");
        self.statusLabelRedraw("Prepare Upload");
        
        // Rotate Image:
        // var finalImage:UIImage = UIImage(CGImage: self.imageToSave!.CGImage, scale: self.imageToSave!.scale, orientation: UIImageOrientation.Right);
        // UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);
        
        
        // Here, Upload Image to Server Using Http Post
        var imageData:NSData? = UIImageJPEGRepresentation(self.imageToSave!, 0.8);
        var urlString:NSString = "http://107.170.171.175:3000/uploadImg";
        
        var request:NSMutableURLRequest = NSMutableURLRequest();
        request.HTTPMethod = "Post";
        request.URL = NSURL.URLWithString(urlString);
        var boundary:NSString = NSString.stringWithString("----WebKitFormBoundaryqFAZHDjmNaoRiQYZ");
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type");
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control");
        
        var body:NSMutableData = NSMutableData();
        body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"eye\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("\(self.eye)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"PID\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("\(self.pid)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"mainPID\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("\(self.mainPID)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"image\"; filename=\"upload.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Type: image/png\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSData.dataWithData(imageData));
        body.appendData(NSString.stringWithString("\r\n--\(boundary)--\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        var postLength:NSString = "\(body.length)";
        request.setValue(postLength, forHTTPHeaderField: "Content-Length");
        
        
        request.HTTPBody = body;
        
        self.statusLabelRedraw("Uploading ...");
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:
            { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var httpResponse:NSHTTPURLResponse = response as NSHTTPURLResponse;
                println("response: \(response)");
                println("Status Code = \(httpResponse.statusCode)");
                if httpResponse.statusCode == 200 {
                    println("Success");
                    self.statusLabelRedraw("Success");
                    self.dismissViewControllerAnimated(true, completion: nil);
                }
                else {
                    println("Failed");
                    self.statusLabelRedraw("UpLoad Failed!");
                    self.view.addSubview(self.retryButton);
                    self.view.addSubview(self.dismissVCButton);
                }
            });
        
        
        println("Finish Camera Function, Waiting for Uploading Response");
    }

}
