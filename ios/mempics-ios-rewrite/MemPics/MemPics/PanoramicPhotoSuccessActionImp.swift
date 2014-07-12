//
//  PanoramicPhotoSuccessActionImp.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class PanoramicPhotoSuccessActionImp: SuccessActionImp {
    
    func startCountDown(mainVC:MainViewController) {
        mainVC.countDown(5, photoLeft: 6);
    }

    
    
    func countDownComplete(PhotoLeft:NSInteger, mainVC:MainViewController) {
        println("Shooting Panoramic Photos");
        
        var image1 = UIImage(named:"a1.jpg");
        var image2 = UIImage(named:"a2.jpg");
        var image3 = UIImage(named:"a3.jpg");
        var image4 = UIImage(named:"a4.jpg");
        //var image5 = UIImage(named:"a4.JPG");
        
        //var imageArray:UIImage[] = [image1,image2,image3,image4,image5];
        var imageArray:UIImage[] = [image1, image2, image3, image4];
        
        println("Start Stitching Photo");
        var stitchedImage:UIImage = CVWrapper.processWithArray(imageArray) as UIImage;
        println("Finish Stitching Photo");
        UIImageWriteToSavedPhotosAlbum(stitchedImage, nil, nil, nil);
        println("Finish Saving Photo");
    }
}
