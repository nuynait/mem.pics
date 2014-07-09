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
    }
}
