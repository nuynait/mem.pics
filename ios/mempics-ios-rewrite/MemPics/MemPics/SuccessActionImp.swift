//
//  SuccessActionImp.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

protocol SuccessActionImp {
   
    func startCountDown(mainVC:MainViewController);
    func countDownComplete(PhotoLeft:NSInteger, mainVC:MainViewController);
    
}
