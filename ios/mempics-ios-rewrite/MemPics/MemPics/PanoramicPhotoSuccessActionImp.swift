//
//  PanoramicPhotoSuccessActionImp.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import AVFoundation

class PanoramicPhotoSuccessActionImp: SuccessActionImp {
    
    func startCountDown(mainVC:MainViewController) {
        mainVC.avFoundationModel!.lockExposure();
        mainVC.countDown(3, photoLeft: 6);
    }

    
    
    func countDownComplete(PhotoLeft:NSInteger, mainVC:MainViewController) {
        
        
        // bluetooth handler
        mainVC.photoLeft = mainVC.photoLeft! - 1;
        
        println("Shooting Panoramic Photos");
        println("CountDown Finished");
        // mainVC.mainView!.countDownLabel.text = "";
        // mainVC.mainView!.flashScreen();
        
        // Capture Image:
        mainVC.avFoundationModel!.stillImageOutput!.captureStillImageAsynchronouslyFromConnection(mainVC.avFoundationModel!.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo), completionHandler:
            { (buffer, error:NSError!) in
                
                if buffer {
                    println("Start Capture Image");
                    var imageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer);
                    var image:UIImage = UIImage(data: imageData);
                    
                    
                    // Scale image
                    // var newImage:UIImage = mainVC.upLoadViewController!.uploadModel!.resizeImage(image, newSize: CGSizeMake(620, 864));
                    
                    var newImage:UIImage = mainVC.upLoadViewController!.uploadModel!.imageWithImage(image, scaledToSize: CGSizeMake(720, 964));
                    
                    
                    println("Scaled Original image size: \(image.size.width), \(image.size.height)");
                    
                    println("Scaled New image size: \(newImage.size.width), \(newImage.size.height)");
                    // mainVC.mainView!.imageDrawPreview(newImage, index: 5 - PhotoLeft);
                    mainVC.mainView!.imageDrawPreviewTesting(image);
                    
                    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
                    mainVC.upLoadViewController!.uploadModel!.imageToSave = newImage;
                    mainVC.upLoadViewController!.uploadModel!.storeImage();
                    // mainVC.uploadViewController!.uploadModel!.imageToSave = image;
                    // self.upLoad();
                    // self.uploadViewController!.imageToSave = UIImage(named: "a1.JPG");
                    
                    // Reenable Button
                    if PhotoLeft == 1 {
                        mainVC.upLoadViewController!.modeFlag = false;
                        // mainVC.upLoadViewController!.uploadModel!.imageToSave = mainVC.upLoadViewController!.uploadModel!.imageStored[0] as? UIImage;
                        mainVC.switchToUploadViewController();
                    }
                    else if PhotoLeft == -1 {
                        // This is the central state, do nothing. Let the peripheral control the central
                        println("Do Nothing");
                    }
                    else {
                        mainVC.countDown(9, photoLeft: PhotoLeft-1);
                    }
                }
            });
        // var image1 = UIImage(named:"a1.jpg");
        // var image2 = UIImage(named:"a2.jpg");
        // var image3 = UIImage(named:"a3.jpg");
        // var image4 = UIImage(named:"a4.jpg");
        // var image5 = UIImage(named:"a5.jpg");
        // var image6 = UIImage(named:"a6.jpg");
        // var image7 = UIImage(named:"a7.jpg");
        // var image8 = UIImage(named:"a8.jpg");
        // //var image5 = UIImage(named:"a4.JPG");
        // 
        // mainVC.upLoadViewController!.uploadModel!.imageToSave = image1;
        // mainVC.upLoadViewController!.uploadModel!.storeImage();
        // 
        // mainVC.upLoadViewController!.uploadModel!.imageToSave = image2;
        // mainVC.upLoadViewController!.uploadModel!.storeImage();
        // 
        // mainVC.upLoadViewController!.uploadModel!.imageToSave = image3;
        // mainVC.upLoadViewController!.uploadModel!.storeImage();
        // 
        // mainVC.upLoadViewController!.uploadModel!.imageToSave = image4;
        // mainVC.upLoadViewController!.uploadModel!.storeImage();
        // 
        // mainVC.upLoadViewController!.modeFlag = false;
        // mainVC.switchToUploadViewController();
    }
}
