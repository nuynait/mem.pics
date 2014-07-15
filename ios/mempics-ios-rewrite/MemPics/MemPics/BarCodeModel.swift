//
//  BarCodeModel.swift
//  MemPics
//
//  Created by Tianyun Shan on 2014-07-14.
//  Copyright (c) 2014 Tianyun Shan. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeModel: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    /* 
     * this is for ZBarSDK
     *
    func imagePickerController(reader:UIImagePickerController, info:NSDictionary) {
        // var results : (AnyObject!) = info.objectForKey(ZBarReaderControllerResults);
        // var symbol:ZBarSymbol?;
        println("Start Image Picker Delegate, Get the Result");
        // var result:NSString = info.objectForKey(ZBarReaderControllerResults) as NSString;
        
        
        // println("The Result is: \(result)");
        
        
    }
    */
    
    // Variables For AVFoundations
    var isReading:Bool?;
    
    
    
    
    // AVFoundationModel
    var avFoundationDeviceModel:AVFoundationDeviceModel?;
    
    
    // Add Main View Controller
    var mainVC:MainViewController?;
    
    
    init(avModel:AVFoundationDeviceModel, mainViewController:MainViewController) {
        super.init();
        self.isReading = false;
        self.avFoundationDeviceModel = avModel;
        self.mainVC = mainViewController;
        self.avTestSetup();
        
    }
    
    func avTestSetup() {
        // init the AVsessionOutput
        var captureMetadataOutput:AVCaptureMetadataOutput = AVCaptureMetadataOutput();
        self.avFoundationDeviceModel!.session.addOutput(captureMetadataOutput);
        
        
        println("Start Init Session Queue and Meta Data Output");
        // Create a New serial Dispatch Queue
        var dispatchQueue:dispatch_queue_t?;
        dispatchQueue = dispatch_queue_create("myQueue", nil);
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue);
        captureMetadataOutput.metadataObjectTypes = NSArray(object: AVMetadataObjectTypeQRCode);
        
        println("QRCode Init Success");
    }
    
    /*
    
    func avSessionSetup() -> Bool {
        
        var error:NSError?;
        
        
        println("Start Init AVSession For Reading QRCode");
        // Init Device
        
        var captureDevice:AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo);
        
        var input:AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error) as AVCaptureDeviceInput;
        
        if input == nil {
            println("Error!!! Error Message: \(error!.localizedDescription)");
            return false;
        }
        
        println("Start Init Capture Session");
        
        // Device Has Been Captured
        // Now init the AVSession
        self.captureSession = AVCaptureSession();
        self.captureSession!.addInput(input);
        
        println("Start Init Session Output");
        
        // init the AVsessionOutput
        var captureMetadataOutput:AVCaptureMetadataOutput = AVCaptureMetadataOutput();
        self.captureSession!.addOutput(captureMetadataOutput);
        
        
        println("Start Init Session Queue and Meta Data Output");
        // Create a New serial Dispatch Queue
        var dispatchQueue:dispatch_queue_t?;
        dispatchQueue = dispatch_queue_create("myQueue", nil);
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue);
        captureMetadataOutput.metadataObjectTypes = NSArray(object: AVMetadataObjectTypeQRCode);
        
        println("QRCode Init Success");
        
        return true;
    }
*/
    
    
    func startReading() {
       
        
        /*
        // Initialize the video preview layer
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession);
        self.videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.videoPreviewLayer!.frame = UIScreen.mainScreen().bounds;
        self.mainVC!.mainView!.layer.addSublayer(self.videoPreviewLayer);
        */
        
        
        
        // var previewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(captureSession) as AVCaptureVideoPreviewLayer;
        // previewLayer.backgroundColor = UIColor.blackColor().CGColor;
        // previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        // previewLayer.frame = UIScreen.mainScreen().bounds;
        // self.videoPreviewLayer = previewLayer;
        // self.mainVC!.mainView!.layer.addSublayer(self.videoPreviewLayer);
        // 
        // 
        // 
        // println("Before Running The Session");
        // 
        // self.captureSession!.startRunning();
        
        
        println("Start Reading");
        self.isReading = true;
        
    }
    
    
    func stopReading() {
        // self.videoPreviewLayer!.removeFromSuperlayer();
        // self.captureSession!.stopRunning();
        self.isReading = false;
        // self.mainVC!.setState(false);
        // self.mainVC!.avSessionSetupImp!.setupAVSession(self.mainVC!.avFoundationModel!, mainView: self.mainVC!.mainView!)
        //self.mainVC!.currentState!.subViewSetup(self.mainVC!.mainView!);
        //self.mainVC!.drawCurrentStateSubview();
    }
        
    
   
}


// This is for AVCaptureMetadataOutputObjectsDelegate method implementation
extension BarCodeModel {
    
    // informs the delegate that the capture output object emitted new metadata objects
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: AnyObject[]!, fromConnection connection: AVCaptureConnection!) {
        self.mainVC!.mainView!.qrCodeModeIndecatorSetup();
        
        
        // First we need to check to see if the metadataobject array is not nil
        // The metadataObjects array should have at least one object!
        if (metadataObjects != nil && metadataObjects.count > 0) {
            // We get that metadata objects
            var metadataObj:AVMetadataMachineReadableCodeObject = metadataObjects[0] as AVMetadataMachineReadableCodeObject;
            
            if (metadataObj.type == AVMetadataObjectTypeQRCode) {
                if  mainVC!.mainView!.qrCodeModeOn == true {
                    println("Find QRCode, text is: \(metadataObj.stringValue)");
                    // self.mainVC!.notifiedFromQRCodeModel();
                    
                    
                    //dispatch_async(dispatch_get_main_queue(), {
                    //    self.mainVC!.setState(false);
                    //    self.mainVC!.notifiedFromQRCodeModel();
                    //    })
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if self.mainVC!.mainView!.qrCodeModeIndicatorIsFlashing == false {
                            self.mainVC!.mainView!.qrCodeModeIndecatorFlashing(2);
                        }
                        })
                    
                    
                    println("FINISHED");
                    
                    
                    self.stopReading();
                }
            }
            
        }
        
    }
    
}
