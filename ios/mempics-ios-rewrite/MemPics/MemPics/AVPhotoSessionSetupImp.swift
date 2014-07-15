//
//  AVPhotoSessionSetupImp.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import AVFoundation

class AVPhotoSessionSetupImp: AVSessionSetupImp {
    
    
    func setupAVSession(avFoundationDeviceModel:AVFoundationDeviceModel, mainView:MainView) {
        println("Setup Photo Session");
       
        /*
        var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(avFoundationDeviceModel.session) as AVCaptureVideoPreviewLayer;
        previewLayer.backgroundColor = UIColor.blackColor().CGColor;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.frame = UIScreen.mainScreen().bounds;
        mainView.layer.masksToBounds = true;
        mainView.layer.addSublayer(previewLayer);
        */
        
        mainView.layer.masksToBounds = true;
        mainView.layer.addSublayer(avFoundationDeviceModel.photoPreview);
        avFoundationDeviceModel.session.startRunning();
        
        // avFoundationDeviceModel.session.startRunning();
        
    }
    
}
