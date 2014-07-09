//
//  UploadModel.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class UploadModel: NSObject {
    
    // Delegate:
    var uploadVC:UploadViewController?;
    
    var imageToSave:UIImage?;
    var imageStored:NSMutableArray = NSMutableArray(); // This is for panoramic Photo
    
    
    // Main Info
    var eye:NSString?;
    var pid:NSString?;
    var mainPid:NSString?;
    
    init() {
        super.init();
        self.pid = DeviceInfo.getDevicePid();
    }
    

    
}


// Panaramic Upload Model
extension UploadModel {
    func storeImage() {
        self.imageStored.addObject(self.imageToSave!);
    }
    
    func stitch() {
        // Stitch image to a panoramic photo
        println("Stitch Image to Panoramic Photo");
    }
}


// Upload Function
extension UploadModel {
    func upLoad() {
        println("uploading");
        println("Prepare Upload: Pid: \(self.pid), eye: \(self.eye)");
        println("MainPID: \(self.mainPid!)");
        self.NotifyViewController("Prepare Upload");
        
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
        body.appendData(NSString.stringWithString("\(self.mainPid)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Disposition: form-data; name=\"image\"; filename=\"upload.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSString.stringWithString("Content-Type: image/png\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        body.appendData(NSData.dataWithData(imageData));
        body.appendData(NSString.stringWithString("\r\n--\(boundary)--\r\n").dataUsingEncoding(NSUTF8StringEncoding));
        var postLength:NSString = "\(body.length)";
        request.setValue(postLength, forHTTPHeaderField: "Content-Length");
        
        
        request.HTTPBody = body;
        
        self.NotifyViewController("Uploading ...... ");
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:
            { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var httpResponse:NSHTTPURLResponse = response as NSHTTPURLResponse;
                println("response: \(response)");
                println("Status Code = \(httpResponse.statusCode)");
                if httpResponse.statusCode == 200 {
                    println("Success");
                    self.NotifyViewController("Success");
                }
                else {
                    println("Failed");
                    self.NotifyViewController("Failed");
                }
            });
        
        
        println("Finish Camera Function, Waiting for Uploading Response");
    }
}


// Notify Controller
extension UploadModel {
    func NotifyViewController(stringToSend:NSString) {
        self.uploadVC!.getNotifedFromUpLoadModel(stringToSend);
    }
}