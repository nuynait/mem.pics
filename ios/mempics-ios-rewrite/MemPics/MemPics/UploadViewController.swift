//
//  UploadViewController.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {
    
    var uploadModel:UploadModel?;
    var uploadView:UploadView = UploadView(frame: UIScreen.mainScreen().bounds);
    var modeFlag:Bool?;

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.uploadModel = UploadModel();
        self.uploadModel!.uploadVC = self;
    }

    override func loadView() {
        self.view = uploadView;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uploadView.loadView();
        self.uploadView.viewDidLoad();
        self.runModel();
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func runModel() {
        self.uploadView.retryButton.removeFromSuperview();
        self.uploadView.dismissVCButton.removeFromSuperview();
        self.uploadView.spinner.startAnimating();
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if self.modeFlag == true {
                println("modeFlag = True, Run upload");
                self.uploadModel!.upLoad();
            }
            else {
                println("modeFlag = False, Run Stitch, check stored image size: \(self.uploadModel!.imageStored.count)");
                self.uploadModel!.stitch();
            }
            });
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSubViewTargets() {
        self.uploadView.retryButton.addTarget(self, action: "retryButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
        self.uploadView.dismissVCButton.addTarget(self, action: "dismissButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    
    func retryButtonPressed(sender:UIButton) {
        // retryButtonPressed
        self.uploadView.retryButton.removeFromSuperview();
        self.uploadView.dismissVCButton.removeFromSuperview();
        self.uploadModel!.upLoad();
    }
    
    func dismissButtonPressed(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func getNotifedFromUpLoadModel(stringReceived:NSString) {
        self.uploadView.statusLabelRedraw(stringReceived);
        if stringReceived.isEqualToString("Success") {
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        if stringReceived.isEqualToString("Failed") {
            self.uploadView.addSubview(self.uploadView.retryButton);
            self.uploadView.addSubview(self.uploadView.dismissVCButton);
        }
        
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
