//
//  ScanViewController.swift
//  YLQRCode
//
//  Created by yolo on 2017/1/1.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession?
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /// setup session
        captureSession = AVCaptureSession()
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        captureSession?.addInput(deviceInput)
        
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        
        captureSession?.addOutput(captureMetaDataOutput)
        
        let queue = DispatchQueue(label: "com.yoloyolo.qrcode")
        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: queue)
        
        captureMetaDataOutput.metadataObjectTypes = captureMetaDataOutput.availableMetadataObjectTypes
        
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        capturePreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
        capturePreviewLayer?.frame = view.bounds
        view.layer.addSublayer(capturePreviewLayer!)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.captureSession?.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        
//        let supportedQRCoeTypes = [AVMetadataObjectTypeQRCode]
        for _supportedBarcode in metadataObjects {
           
            guard let supportedBarcode = _supportedBarcode as? AVMetadataObject else { return }
            
            if supportedBarcode.type == AVMetadataObjectTypeQRCode {
                guard let barcodeObject = self.capturePreviewLayer?.transformedMetadataObject(for: supportedBarcode) as? AVMetadataMachineReadableCodeObject else { return }
                DispatchQueue.safeMainQueue { [weak self] in
                    print(Thread.current)
                    print(barcodeObject.stringValue)
                    self?.captureSession?.stopRunning()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
