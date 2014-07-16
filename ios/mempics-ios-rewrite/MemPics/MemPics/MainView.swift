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
    var qrCodeScanButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
    var qrCodeModeOn:Bool = true;
    var qrCodeModeIndicator:UIImageView = UIImageView();
    var qrCodeModeIndicatorIsFlashing:Bool = false;
    var focusDotLabel:UIImageView = UIImageView();
    var countDownLabel:UILabel = UILabel();
    var pidDisplayLabel:UILabel = UILabel();
    var bluetoothStatusLabel:UILabel = UILabel();
    var camSwitch:UISwitch = UISwitch();
    var panoramaSwitch:UISwitch = UISwitch();
    var imagePreviewArray:UIImageView[]?;
    var imagePreviewTesting:UIImageView = UIImageView();
    var imagePreviewTesting2:UIImageView = UIImageView();
    var degree:float_t = 0;
    
    
    var isRotating:Bool = false;
    
    // Information Panel
    var rectangleView:UIView = UIView();
    var rectangleViewOnTop:UIView = UIView();
    var camSwitchInfoLabel:UILabel = UILabel();
    var panoramicSwitchInfoLabel:UILabel = UILabel();

    
    
    var camSwitchHowtoLabel:UILabel = UILabel();
    var camSwitchHowtoDetailLabel:UILabel = UILabel();
    var panoramicSwitchHowtoLabel:UILabel = UILabel();
    var panoramicSwitchHowtoDetailLabel:UILabel = UILabel();
    
    
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
        self.qrCodeScanButton.removeFromSuperview();
        self.qrCodeModeIndicator.removeFromSuperview();
        self.camSwitchInfoLabel.removeFromSuperview();
        self.camSwitchHowtoLabel.removeFromSuperview();
        self.camSwitchHowtoDetailLabel.removeFromSuperview();
        self.panoramicSwitchInfoLabel.removeFromSuperview();
        self.panoramicSwitchHowtoLabel.removeFromSuperview();
        self.panoramicSwitchHowtoDetailLabel.removeFromSuperview();
        self.imagePreviewTesting.hidden = true;
    }
    
    func countDownLabelRedraw(labelText:NSString) {
        self.countDownLabel.font = UIFont.systemFontOfSize(44);
        self.countDownLabel.text = labelText;
        self.countDownLabel.textColor = UIColor.whiteColor();
        self.countDownLabel.backgroundColor = UIColor(white: 0, alpha: 0.5);
        self.countDownLabel.textAlignment = NSTextAlignment.Center;
        self.countDownLabel.layer.cornerRadius = 10;
        self.countDownLabel.layer.masksToBounds = true;
        self.countDownLabel.sizeToFit();
        self.countDownLabel.frame.size = CGSizeMake(60, 60);
        self.countDownLabel.frame = CGRectMake(
            (self.frame.width - self.countDownLabel.frame.width) / 2,
            100,
            self.countDownLabel.frame.width,
            self.countDownLabel.frame.height);
        self.bringSubviewToFront(self.countDownLabel);
    }
    
    func bluetoothStatusLabelRedraw(labelText:NSString) {
        self.bluetoothStatusLabel.text = labelText;
        self.bluetoothStatusLabel.textColor = UIColor(red: 1, green: 0.8, blue: 0.4, alpha: 1)
        self.bluetoothStatusLabel.sizeToFit();
        self.bluetoothStatusLabel.frame = CGRectMake(
            self.frame.width - self.bluetoothStatusLabel.frame.width - 5,
            20,
            self.bluetoothStatusLabel.frame.width,
            self.bluetoothStatusLabel.frame.height);
        self.bringSubviewToFront(self.bluetoothStatusLabel);
    }
    
    
    func focusDotLabelRedraw() {
        self.focusDotLabel.image = self.imageWithImage(UIImage(named: "targetFocus@2x.png"), newSize: CGSizeMake(20, 20));
        // self.focusDotLabel.textColor = UIColor.redColor();
        self.focusDotLabel.sizeToFit();
        self.focusDotLabel.frame = CGRectMake(
            (self.frame.width - self.focusDotLabel.frame.width) / 2,
            (self.frame.height - self.focusDotLabel.frame.height) / 2,
            self.focusDotLabel.frame.width,
            self.focusDotLabel.frame.height);
        self.focusDotLabel.alpha = 1;
    }
    
    func camSwitchRedraw() {
        self.camSwitch.frame = CGRectMake(10,self.frame.height - 80, 79, 27);
        self.camSwitch.onTintColor = UIColor(red: 1, green: 0.8, blue: 0.4, alpha: 1);
        self.camSwitch.tintColor = UIColor(red: 1, green: 0.8, blue: 0.4, alpha: 1);
        self.camSwitch.alpha = 0.6;
    }
    
    func pidDisplayLabelRedraw() {
        self.pidDisplayLabel.textColor = UIColor.whiteColor();
        self.pidDisplayLabel.text = "ID: \(DeviceInfo.getDevicePid().substringFromIndex(DeviceInfo.getDevicePid().length - 5))";
        self.pidDisplayLabel.sizeToFit();
        self.pidDisplayLabel.frame = CGRectMake(
            5, 20,
            self.pidDisplayLabel.frame.width,
            self.pidDisplayLabel.frame.height);
    }
    
    func takePictureButtonRedraw() {
        var buttonImage:UIImage = self.imageWithImage(UIImage(named: "takePictureButtonStyle4@2x.png"), newSize: CGSizeMake(85, 85));
        self.takePictureButton.setImage(buttonImage, forState: UIControlState.Normal);
        // self.takePictureButton.setTitle("Take Picture", forState:UIControlState.Normal);
        self.takePictureButton.tintColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1);
        self.takePictureButton.sizeToFit();
        self.takePictureButton.frame = CGRectMake(
            (self.frame.width - self.takePictureButton.frame.width) / 2,
            self.frame.height - 120,
            self.takePictureButton.frame.width,
            self.takePictureButton.frame.height);
        self.takePictureButton.alpha = 0.9;
    }
    
    func panoramaSwitchRedraw() {
        self.panoramaSwitch.sizeToFit();
        self.panoramaSwitch.frame = CGRectMake(
            self.frame.width - self.panoramaSwitch.frame.width - 10,
            self.frame.height - 80,
            79,
            27);
        self.panoramaSwitch.onTintColor = UIColor(red: 1, green: 0.8, blue: 0.4, alpha: 1);
        self.panoramaSwitch.tintColor = UIColor(red: 1, green: 0.8, blue: 0.4, alpha: 1);
        self.panoramaSwitch.alpha = 0.6;
    }
    
    func imagePreviewSetupTesting() {
        
        self.imagePreviewTesting.frame.size = CGSizeMake(336,448);
        
        var testRect:CGRect = CGRectMake(
            -176,
            15,
            336,
            448);
        
        self.imagePreviewTesting.frame = testRect;
        // imagePreviewTesting.alpha = 0.6;
        self.bringSubviewToFront(self.imagePreviewTesting);
        // imagePreviewTesting.image = self.imageWithImage(UIImage(named: "a1.jpg"), newSize: CGSizeMake(144, 192));
        self.addSubview(self.imagePreviewTesting);
        
        
        // self.imagePreviewTesting2.frame.size = CGSizeMake(64,89);
        // 
        // var testRect2:CGRect = CGRectMake(
        //     200,
        //     150,
        //     64,
        //     98);
        // 
        // self.imagePreviewTesting2.frame = testRect2;
        // // imagePreviewTesting.alpha = 0.6;
        // self.bringSubviewToFront(self.imagePreviewTesting2);
        // // imagePreviewTesting.image = self.imageWithImage(UIImage(named: "a1.jpg"), newSize: CGSizeMake(144, 192));
        // self.addSubview(self.imagePreviewTesting2);
    }
    
    func imageDrawPreviewTesting(image:UIImage) {
        self.imagePreviewTesting.hidden = false;
        self.imagePreviewTesting.image = self.imageWithImage(image, newSize: CGSizeMake(352, 432));
        // self.imagePreviewTesting2.image = self.imageWithImage(image, newSize: CGSizeMake(64, 98));
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
    
    
    
    func qrCodeScanButtonSetup() {
        if self.qrCodeModeOn == true {
            self.qrCodeScanButton.setImage(self.imageWithImage(UIImage(named: "qrcode@2x.png"), newSize: CGSizeMake(30, 30)), forState: UIControlState.Normal);
        }
        else {
            self.qrCodeScanButton.setImage(self.imageWithImage(UIImage(named: "qrcodeOff@2x.png"), newSize: CGSizeMake(30, 30)), forState: UIControlState.Normal);
        }
        self.qrCodeScanButton.sizeToFit();
        self.qrCodeScanButton.frame = CGRectMake(
            5, 60,
            self.qrCodeScanButton.frame.width,
            self.qrCodeScanButton.frame.height);
        self.qrCodeScanButton.alpha = 0.6;
        
    }
    
    func qrCodeModeIndecatorSetup() {
        self.qrCodeModeIndicator.image = UIImage(named: "qrcode@2x.png");
        self.qrCodeModeIndicator.sizeToFit();
        self.qrCodeModeIndicator.frame = CGRectMake(
            (self.frame.width - self.qrCodeModeIndicator.frame.width) / 2,
            (self.frame.height - self.qrCodeModeIndicator.frame.height) / 2,
            self.qrCodeModeIndicator.frame.width,
            self.qrCodeModeIndicator.frame.height);
        self.qrCodeModeIndicator.alpha = 0.5;
        self.addSubview(self.qrCodeModeIndicator);
    }
    
    func qrCodeModeIndecatorFlashing(time:NSInteger, frequency:Double) {
        self.qrCodeModeIndicatorIsFlashing = true;
        var second:NSInteger = time;
        println("QRCode Indecator Flashing: \(second)");
        if (second % 2 == 0) {
            // EVEN
            self.qrCodeModeIndicator.hidden = false;
            
        }
        else {
            // ODD
            self.qrCodeModeIndicator.hidden = true;
        }
        if second == 0 {
            self.qrCodeModeIndicator.hidden = true;
            self.qrCodeModeIndicatorIsFlashing = false;
            self.flashScreen();
            return;
        }
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(frequency * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.qrCodeModeIndecatorFlashing(second-1, frequency: frequency);
            });
    }
    
    func camSwitchInfoFlashing(time:NSInteger, frequency:Double) {
        var second:NSInteger = time;
        println("QRCode Indecator Flashing: \(second)");
        if (second % 2 == 0) {
            // EVEN
            // self.camSwitchInfoLabel.hidden = false;
            self.camSwitchHowtoDetailLabel.hidden = false;
            self.camSwitchHowtoLabel.hidden = false;
            //self.bringSubviewToFront(self.camSwitchHowtoLabel);
            //self.bringSubviewToFront(self.camSwitchHowtoDetailLabel);
            //self.bringSubviewToFront(self.camSwitchInfoLabel);
        }
        else {
            // ODD
            self.bringSubviewToFront(self.rectangleView);
            self.bringSubviewToFront(self.camSwitch);
            self.bringSubviewToFront(self.panoramaSwitch);
            self.bringSubviewToFront(self.takePictureButton);
        }
        
        if second == 0 {
            self.camSwitchHowtoLabel.hidden = true;
            self.camSwitchHowtoDetailLabel.hidden = true;
            self.camSwitchHowtoLabel.alpha = 1;
            self.camSwitchHowtoDetailLabel.alpha = 1;
            
            self.bringSubviewToFront(self.rectangleView);
            self.bringSubviewToFront(self.camSwitch);
            self.bringSubviewToFront(self.panoramaSwitch);
            self.bringSubviewToFront(self.takePictureButton);
            return;
        }
        else if second < 10 {
            self.camSwitchHowtoDetailLabel.alpha = self.camSwitchHowtoDetailLabel.alpha - 0.1;
            self.camSwitchHowtoLabel.alpha = self.camSwitchHowtoLabel.alpha - 0.1;
        }
        
        
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(frequency * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            if second > 10 {
                self.camSwitchInfoFlashing(second-1, frequency: frequency);
            }
            else {
                self.camSwitchInfoFlashing(second-1, frequency: 0.1);
            }
            });
        
    }
    
    func panoramicSwitchInfoFlashing(time:NSInteger, frequency:Double) {
        var second:NSInteger = time;
        println("QRCode Indecator Flashing: \(second)");
        if (second % 2 == 0) {
            // EVEN
            // self.camSwitchInfoLabel.hidden = false;
            self.panoramicSwitchHowtoDetailLabel.hidden = false;
            self.panoramicSwitchHowtoLabel.hidden = false;
            //self.bringSubviewToFront(self.camSwitchHowtoLabel);
            //self.bringSubviewToFront(self.camSwitchHowtoDetailLabel);
            //self.bringSubviewToFront(self.camSwitchInfoLabel);
        }
        else {
            // ODD
            self.bringSubviewToFront(self.rectangleView);
            self.bringSubviewToFront(self.camSwitch);
            self.bringSubviewToFront(self.panoramaSwitch);
            self.bringSubviewToFront(self.takePictureButton);
        }
        
        if second == 0 {
            self.panoramicSwitchHowtoDetailLabel.hidden = true;
            self.panoramicSwitchHowtoLabel.hidden = true;
            self.panoramicSwitchHowtoLabel.alpha = 1;
            self.panoramicSwitchHowtoDetailLabel.alpha = 1;
            
            self.bringSubviewToFront(self.rectangleView);
            self.bringSubviewToFront(self.camSwitch);
            self.bringSubviewToFront(self.panoramaSwitch);
            self.bringSubviewToFront(self.takePictureButton);
            return;
        }
        else if second < 10 {
            self.panoramicSwitchHowtoDetailLabel.alpha = self.panoramicSwitchHowtoDetailLabel.alpha - 0.1;
            self.panoramicSwitchHowtoLabel.alpha = self.panoramicSwitchHowtoLabel.alpha - 0.1;
        }
        
        
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(frequency * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            if second > 10 {
                self.panoramicSwitchInfoFlashing(second-1, frequency: frequency);
            }
            else {
                self.panoramicSwitchInfoFlashing(second-1, frequency: 0.1);
            }
            });
        
    }
    
    
    
    func focusImageRotating(time:NSInteger, frequency:Double) {
        self.isRotating = true;
        var second:NSInteger = time;
        self.degree = self.degree + 0.1;
        if self.degree >= 6.28 {
            self.degree = 0;
        }
        
        self.focusDotLabel.transform = CGAffineTransformMakeRotation(self.degree);
        
        
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(frequency * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.focusImageRotating(second-1, frequency: 0.1);
            });
        
    }
    
    
    func displayAllInfoLabel() {
        self.camSwitchInfoLabel.hidden = false;
        self.panoramicSwitchInfoLabel.hidden = false;
        self.camSwitchHowtoLabel.hidden = false;
        self.camSwitchHowtoDetailLabel.hidden = false;
        self.panoramicSwitchHowtoLabel.hidden = false;
        self.panoramicSwitchHowtoDetailLabel.hidden = false;
    }
    
    func camSwitchInfoLabelRedraw(text:NSString) {
        self.camSwitchInfoLabel.font = UIFont.systemFontOfSize(14);
        self.camSwitchInfoLabel.text = text;
        self.camSwitchInfoLabel.textColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1);
        self.camSwitchInfoLabel.sizeToFit();
        self.camSwitchInfoLabel.hidden = false;
        self.camSwitchInfoLabel.frame = CGRectMake(
            self.camSwitch.frame.minX + 5,
            self.camSwitch.frame.minY - self.camSwitchInfoLabel.frame.height - 5,
            self.camSwitchInfoLabel.frame.width,
            self.camSwitchInfoLabel.frame.height);
    }
    
    func panoramicSwitchInfoLabelRedraw(text:NSString) {
        self.panoramicSwitchInfoLabel.font = UIFont.systemFontOfSize(14);
        self.panoramicSwitchInfoLabel.text = text;
        self.panoramicSwitchInfoLabel.textColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1);
        self.panoramicSwitchInfoLabel.sizeToFit();
        self.panoramicSwitchInfoLabel.hidden = false;
        self.panoramicSwitchInfoLabel.frame = CGRectMake(
            self.panoramaSwitch.frame.maxX - self.panoramicSwitchInfoLabel.frame.width - 5,
            self.panoramaSwitch.frame.minY - self.panoramicSwitchInfoLabel.frame.height - 5,
            self.panoramicSwitchInfoLabel.frame.width,
            self.panoramicSwitchInfoLabel.frame.height);
    }
    
    func camSwitchHowtoLabelRedraw() {
        self.camSwitchHowtoLabel.font = UIFont.systemFontOfSize(12);
        self.camSwitchHowtoLabel.text = "L - Left Eye"
        self.camSwitchHowtoLabel.textColor = UIColor.whiteColor();
        self.camSwitchHowtoLabel.sizeToFit();
        // self.camSwitchHowtoLabel.backgroundColor = UIColor.blueColor();
        self.camSwitchHowtoLabel.hidden = true;
        self.camSwitchHowtoLabel.alpha = 1;
        self.camSwitchHowtoLabel.frame = CGRectMake(
            self.camSwitch.frame.minX + 5,
            self.camSwitch.frame.maxY + 10,
            self.camSwitchHowtoLabel.frame.width,
            self.camSwitchHowtoLabel.frame.height);
        
        
        // How to Detail Label
        self.camSwitchHowtoDetailLabel.font = UIFont.systemFontOfSize(12);
        self.camSwitchHowtoDetailLabel.text = "R - Right Eye."
        self.camSwitchHowtoDetailLabel.textColor = UIColor.whiteColor();
        self.camSwitchHowtoDetailLabel.sizeToFit();
        // self.camSwitchHowtoDetailLabel.backgroundColor = UIColor.blueColor();
        self.camSwitchHowtoDetailLabel.hidden = true;
        self.camSwitchHowtoDetailLabel.alpha = 1;
        self.camSwitchHowtoDetailLabel.frame = CGRectMake(
            self.camSwitch.frame.minX + 5,
            self.camSwitchHowtoLabel.frame.maxY + 3,
            self.camSwitchHowtoDetailLabel.frame.width,
            self.camSwitchHowtoDetailLabel.frame.height);
    }
    
    func panoramicSwitchHowtoLabelRedraw() {
        self.panoramicSwitchHowtoLabel.font = UIFont.systemFontOfSize(12);
        self.panoramicSwitchHowtoLabel.text = "S - Photo (Single)";
        self.panoramicSwitchHowtoLabel.textColor = UIColor.whiteColor();
        self.panoramicSwitchHowtoLabel.sizeToFit();
        self.panoramicSwitchHowtoLabel.hidden = true;
        self.panoramicSwitchHowtoLabel.alpha = 1;
        self.panoramicSwitchHowtoLabel.frame = CGRectMake(
            self.panoramaSwitch.frame.maxX - self.panoramicSwitchHowtoLabel.frame.width - 5,
            self.panoramaSwitch.frame.maxY + 10 ,
            self.panoramicSwitchHowtoLabel.frame.width,
            self.panoramicSwitchHowtoLabel.frame.height);
        
        
        self.panoramicSwitchHowtoDetailLabel.font = UIFont.systemFontOfSize(12);
        self.panoramicSwitchHowtoDetailLabel.text = "M - Panoramic (Multiple)";
        self.panoramicSwitchHowtoDetailLabel.textColor = UIColor.whiteColor();
        self.panoramicSwitchHowtoDetailLabel.sizeToFit();
        self.panoramicSwitchHowtoDetailLabel.hidden = true;
        self.panoramicSwitchHowtoDetailLabel.alpha = 1;
        self.panoramicSwitchHowtoDetailLabel.frame = CGRectMake(
            self.panoramaSwitch.frame.maxX - self.panoramicSwitchHowtoDetailLabel.frame.width - 5,
            self.panoramicSwitchHowtoLabel.frame.maxY + 3,
            self.panoramicSwitchHowtoDetailLabel.frame.width,
            self.panoramicSwitchHowtoDetailLabel.frame.height);
        
    }
    
    func setupRectangleView() {
        self.rectangleView.frame.size = CGSizeMake(
            self.frame.width, 120);
        self.rectangleView.frame = CGRectMake(
            0,
            self.frame.height - self.rectangleView.frame.height,
            self.rectangleView.frame.width,
            self.rectangleView.frame.height);
        // self.rectangleView.backgroundColor = UIColor(red: 0.933, green: 0.212, blue: 0, alpha: 0.3)
        self.rectangleView.backgroundColor = UIColor.blackColor();
        self.rectangleView.alpha = 0.4;
        // self.rectangleView.layer.cornerRadius = 20;
        self.rectangleView.layer.masksToBounds = true;
    }
    
    func setupRectangleViewOnTop() {
        self.rectangleViewOnTop.frame.size = CGSizeMake(
            self.frame.width, 50);
        self.rectangleViewOnTop.frame = CGRectMake(
            0,
            0,
            self.rectangleViewOnTop.frame.width,
            self.rectangleViewOnTop.frame.height);
        // self.rectangleViewOnTop.backgroundColor = UIColor(red: 0.933, green: 0.212, blue: 0, alpha: 0.3)
        self.rectangleViewOnTop.backgroundColor = UIColor.blackColor();
        self.rectangleViewOnTop.alpha = 0.4;
        // self.rectangleViewOnTop.layer.cornerRadius = 20;
        self.rectangleViewOnTop.layer.masksToBounds = true;
    }
    
    func bringEverythingOnTop() {
        self.bringSubviewToFront(self.pidDisplayLabel);
        self.bringSubviewToFront(self.bluetoothStatusLabel);
        self.bringSubviewToFront(self.qrCodeScanButton);
        self.bringSubviewToFront(self.qrCodeModeIndicator);
        self.bringSubviewToFront(self.countDownLabel);
        self.bringSubviewToFront(self.camSwitch);
        self.bringSubviewToFront(self.panoramaSwitch);
        self.bringSubviewToFront(self.camSwitchInfoLabel);
        self.bringSubviewToFront(self.camSwitchHowtoLabel);
        self.bringSubviewToFront(self.camSwitchHowtoDetailLabel);
        self.bringSubviewToFront(self.panoramicSwitchInfoLabel);
        self.bringSubviewToFront(self.panoramicSwitchHowtoLabel);
        self.bringSubviewToFront(self.panoramicSwitchHowtoDetailLabel);
        self.bringSubviewToFront(self.imagePreviewTesting);
        
    }
    
    func imageWithImage(image:UIImage, newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height));
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
}

