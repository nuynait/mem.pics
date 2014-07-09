//
//  UploadView.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class UploadView: UIView {
    
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
    var statusLabel:UILabel = UILabel();
    var retryButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    var dismissVCButton:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    func loadView() {
        self.backgroundColor = UIColor.blackColor();
        
        self.addSubview(self.statusLabel);
        self.addSubview(self.spinner);
    }

    func viewDidLoad() {
        self.spinner.sizeToFit();
        self.spinner.frame = CGRectMake(
            (self.frame.width - self.spinner.frame.width) / 2,
            (self.frame.height - self.spinner.frame.height) / 2,
            self.spinner.frame.width,
            self.spinner.frame.height);
        
        self.statusLabelRedraw("Prepare Upload");
    }
    
    func statusLabelRedraw(labelText:NSString) {
        self.statusLabel.textColor = UIColor.whiteColor();
        self.statusLabel.text = labelText;
        self.statusLabel.sizeToFit();
        self.statusLabel.frame = CGRectMake(
            (self.frame.width - self.statusLabel.frame.width) / 2,
            self.spinner.frame.maxY + 10,
            self.statusLabel.frame.width, self.statusLabel.frame.height);
        
        self.retryButton.setTitle("Retry", forState: UIControlState.Normal);
        self.retryButton.sizeToFit();
        self.retryButton.frame = CGRectMake(
            (self.frame.width - self.retryButton.frame.width) / 2,
            self.statusLabel.frame.maxY + 50,
            self.retryButton.frame.width, self.retryButton.frame.height);
        self.retryButton.addTarget(self, action: "retryButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
        
        self.dismissVCButton.setTitle("Back to Camera", forState: UIControlState.Normal);
        self.dismissVCButton.sizeToFit();
        self.dismissVCButton.frame = CGRectMake(
            (self.frame.width - self.dismissVCButton.frame.width) / 2,
            self.retryButton.frame.maxY + 10,
            self.dismissVCButton.frame.width,
            self.dismissVCButton.frame.height);
        self.dismissVCButton.addTarget(self, action: "dismissButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
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
