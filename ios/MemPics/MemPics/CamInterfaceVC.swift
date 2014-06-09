//
//  CamInterfaceVC.swift
//  MemPics
//
//  Created by Jerry Shan on 2014-06-09.
//  Copyright (c) 2014 Jerry Shan. All rights reserved.
//

import UIKit

class CamInterfaceVC: UIViewController {
    var myLabel:UILabel = UILabel();

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    override func loadView() {
        var mainView:UIView = UIView(frame:UIScreen.mainScreen().bounds);
        self.view = mainView;
        self.view.addSubview(myLabel);
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println("MyLabel init");
        myLabel.text = "I am a Label";
        myLabel.sizeToFit();
        myLabel.frame = CGRectMake((self.view.frame.width - myLabel.frame.width) / 2,
            100,
            myLabel.frame.width,
            myLabel.frame.height);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
