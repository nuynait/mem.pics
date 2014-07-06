//
//  MainViewController.swift
//  BoardCast
//
//  Created by Tianyun Shan on 2014-06-26.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
   
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    override func loadView() {
        // Create a Main View
        var viewRect:CGRect = UIScreen.mainScreen().bounds;
        var mainView:UIView = UIView(frame:viewRect);
        self.view = mainView;
        
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // New Test Button For A New View Controller
        
     
    }
    
    func launchCentralView(sender:UIButton) {
      
    }
    
    func launchPeripheralView(sender:UIButton) {

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }

}
