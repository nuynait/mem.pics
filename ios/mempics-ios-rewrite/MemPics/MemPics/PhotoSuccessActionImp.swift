//
//  PhotoSuccessActionImp.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoSuccessActionImp: SuccessActionImp {
    
    func startCountDown(mainVC:MainViewController) {
        mainVC.countDown(5, photoLeft: 0);
    }
    
    
    
    func countDownComplete(PhotoLeft:NSInteger, mainVC:MainViewController) {
        println("CountDown Finished");
        // mainVC.mainView!.countDownLabel.text = "";
        // mainVC.mainView!.flashScreen();
        
        println("Start Capture Image");
        // Capture Image:
        mainVC.avFoundationModel!.stillImageOutput!.captureStillImageAsynchronouslyFromConnection(mainVC.avFoundationModel!.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo), completionHandler:
            { (buffer, error:NSError!) in
                
                if buffer {
                    var imageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer);
                    var image:UIImage = UIImage(data: imageData);
                    println("Saving image to Album, image size check: [\(image.size.width), \(image.size.height)]");
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                    // mainVC.uploadViewController!.uploadModel!.imageToSave = image;
                    // self.upLoad();
                    mainVC.upLoadViewController!.uploadModel!.imageToSave = image;
                    mainVC.upLoadViewController!.modeFlag = true;
                    // self.uploadViewController!.imageToSave = UIImage(named: "a1.JPG");
                    // mainVC.switchToUploadViewController();
                    
                    // Reenable Button
                    mainVC.mainView!.takePictureButton.enabled = true;
                }
            });
    }
   
}
