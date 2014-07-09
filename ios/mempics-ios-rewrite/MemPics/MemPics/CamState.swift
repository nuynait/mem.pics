//
//  CamState.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-07.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit

protocol CamState {
    func subViewSetup(mainView:MainView);
    func paring(currentBTLEModel:AnyObject);
    func boardCasting(currentBTLEModel:AnyObject);
}
