//
//  self.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    var takePictureButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var focusDotLabel:UILabel = UILabel();
    var countDownLabel:UILabel = UILabel();
    var pidDisplayLabel:UILabel = UILabel();
    var bluetoothStatusLabel:UILabel = UILabel();
    var camSwitch:UISwitch = UISwitch();
    var panoramaSwitch:UISwitch = UISwitch();
    var imagePreviewArray:UIImageView[]?;

    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
   

    func flashScreen() {
        var flashView:UIView = UIView(frame:self.frame);
        flashView.backgroundColor = UIColor.whiteColor();
        self.window.addSubview(flashView);
        
        UIView.animateWithDuration(1, animations: {
            flashView.alpha = 0;
            });
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}


/*
 * All the drawing functions
 * 
 */
extension MainView {
    func removeAllFromSubview() {
        self.countDownLabel.removeFromSuperview();
        self.takePictureButton.removeFromSuperview();
        self.focusDotLabel.removeFromSuperview();
        self.camSwitch.removeFromSuperview();
        self.panoramaSwitch.removeFromSuperview();
        self.bluetoothStatusLabel.removeFromSuperview();
    }
    
    func countDownLabelRedraw(labelText:NSString) {
        self.countDownLabel.font = UIFont.systemFontOfSize(44);
        self.countDownLabel.text = labelText;
        self.countDownLabel.textColor = UIColor.redColor();
        self.countDownLabel.sizeToFit();
        self.countDownLabel.frame = CGRectMake(
            (self.frame.width - self.countDownLabel.frame.width) / 2,
            100,
            self.countDownLabel.frame.width,
            self.countDownLabel.frame.height);
        self.bringSubviewToFront(self.countDownLabel);
    }
    
    func bluetoothStatusLabelRedraw(labelText:NSString) {
        self.bluetoothStatusLabel.text = labelText;
        self.bluetoothStatusLabel.textColor = UIColor.redColor();
        self.bluetoothStatusLabel.sizeToFit();
        self.bluetoothStatusLabel.frame = CGRectMake(
            self.frame.width - self.bluetoothStatusLabel.frame.width + 5,
            10,
            self.bluetoothStatusLabel.frame.width,
            self.bluetoothStatusLabel.frame.height);
        self.bringSubviewToFront(self.bluetoothStatusLabel);
    }
    
    
    func focusDotLabelRedraw() {
        self.focusDotLabel.font = UIFont.systemFontOfSize(66);
        self.focusDotLabel.text = "+";
        self.focusDotLabel.textColor = UIColor.redColor();
        self.focusDotLabel.sizeToFit();
        self.focusDotLabel.frame = CGRectMake(
            (self.frame.width - self.focusDotLabel.frame.width) / 2,
            (self.frame.height - self.focusDotLabel.frame.height) / 2,
            self.focusDotLabel.frame.width,
            self.focusDotLabel.frame.height);
        self.focusDotLabel.alpha = 0.6;
        self.bringSubviewToFront(self.focusDotLabel);
    }
    
    func camSwitchRedraw() {
        self.camSwitch.frame = CGRectMake(10,self.frame.height - 60, 79, 27);
        self.camSwitch.alpha = 0.6;
        self.bringSubviewToFront(self.camSwitch);
    }
    
    func pidDisplayLabelRedraw() {
        self.pidDisplayLabel.textColor = UIColor.whiteColor();
        self.pidDisplayLabel.text = "ID: \(DeviceInfo.getDevicePid())";
        self.pidDisplayLabel.sizeToFit();
        self.pidDisplayLabel.frame = CGRectMake(
            5, 5,
            self.pidDisplayLabel.frame.width,
            self.pidDisplayLabel.frame.height);
        self.bringSubviewToFront(self.pidDisplayLabel);
        self.addSubview(self.pidDisplayLabel);
    }
    
    func takePictureButtonRedraw() {
        var buttonImage:UIImage = UIImage(named: "takePictureButton@2x.png");
        self.takePictureButton.setImage(buttonImage, forState: UIControlState.Normal);
        // self.takePictureButton.setTitle("Take Picture", forState:UIControlState.Normal);
        self.takePictureButton.sizeToFit();
        self.takePictureButton.frame = CGRectMake(
            (self.frame.width - self.takePictureButton.frame.width) / 2,
            self.frame.height - 100,
            self.takePictureButton.frame.width,
            self.takePictureButton.frame.height);
        self.takePictureButton.alpha = 0.9;
        self.bringSubviewToFront(self.takePictureButton);
    }
    
    func panoramaSwitchRedraw() {
        self.panoramaSwitch.sizeToFit();
        self.panoramaSwitch.frame = CGRectMake(
            self.frame.width - self.panoramaSwitch.frame.width - 10,
            self.frame.height - 60,
            79,
            27);
        self.panoramaSwitch.alpha = 0.6;
        self.bringSubviewToFront(self.panoramaSwitch);
    }
    
    func imagePreviewSetup() {
        var imagePreview1:UIImageView = UIImageView();
        var imagePreview2:UIImageView = UIImageView();
        var imagePreview3:UIImageView = UIImageView();
        var imagePreview4:UIImageView = UIImageView();
        var imagePreview5:UIImageView = UIImageView();
        
        imagePreview1.frame.size = CGSizeMake(64,64);
        imagePreview1.frame = CGRectMake(0,
            (self.frame.height - imagePreview1.frame.height) / 2, imagePreview1.frame.width, imagePreview1.frame.height);
        imagePreview1.alpha = 0.6;
        self.bringSubviewToFront(imagePreview1);
        self.addSubview(imagePreview1);
        
        imagePreview2.frame.size = CGSizeMake(64,64);
        imagePreview2.frame = CGRectMake(imagePreview1.frame.maxX,
            (self.frame.height - imagePreview1.frame.height) / 2, imagePreview1.frame.width, imagePreview1.frame.height);
        imagePreview2.alpha = 0.6;
        self.bringSubviewToFront(imagePreview2);
        self.addSubview(imagePreview2);
        
        imagePreview3.frame.size = CGSizeMake(64,64);
        imagePreview3.frame = CGRectMake(imagePreview2.frame.maxX,
            (self.frame.height - imagePreview1.frame.height) / 2, imagePreview1.frame.width, imagePreview1.frame.height);
        imagePreview3.alpha = 0.6;
        self.bringSubviewToFront(imagePreview3);
        self.addSubview(imagePreview3);
        
        imagePreview4.frame.size = CGSizeMake(64,64);
        imagePreview4.frame = CGRectMake(imagePreview3.frame.maxX,
            (self.frame.height - imagePreview1.frame.height) / 2, imagePreview1.frame.width, imagePreview1.frame.height);
        imagePreview4.alpha = 0.6;
        self.bringSubviewToFront(imagePreview4);
        self.addSubview(imagePreview4);
        
        imagePreview5.frame.size = CGSizeMake(64,64);
        imagePreview5.frame = CGRectMake(imagePreview4.frame.maxX,
            (self.frame.height - imagePreview1.frame.height) / 2, imagePreview1.frame.width, imagePreview1.frame.height);
        imagePreview5.alpha = 0.6;
        self.bringSubviewToFront(imagePreview5);
        self.addSubview(imagePreview5);
        
        imagePreviewArray = [imagePreview1, imagePreview2, imagePreview3, imagePreview4, imagePreview5];
    }
    
    func imageDrawPreview(imageToDraw:UIImage, index:Int) {
        self.imagePreviewArray![index].image = self.imageWithImage(imageToDraw, newSize: CGSizeMake(64,64));
    }
    
    func imageWithImage(image:UIImage, newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height));
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
}

