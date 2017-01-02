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
    
    let captureSession = AVCaptureSession()
    let metadataOutput = AVCaptureMetadataOutput()
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    let rect = CGRect(x: 50, y: 100, width: 200, height: 200)
    var rectOfInteres = CGRect.zero
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let width = view.frame.width
        let height = view.frame.height
        rectOfInteres = CGRect(x: rect.origin.x / width, y: rect.origin.y / height, width: rect.width / width, height: rect.height / height)
        configSession()
//        let v = UIView(frame: rect)
//        v.layer.borderWidth = 1
//        v.layer.borderColor = UIColor.red.cgColor
//        
//        view.addSubview(v)
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    private func configSession() {
        /// setup session
        captureSession.beginConfiguration()
        do {
            var defaultVedioDevice: AVCaptureDevice?
            
            if #available(iOS 10.0, *) {
                if let backCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back) {
                    defaultVedioDevice = backCameraDevice
                } else if let frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) {
                    defaultVedioDevice = frontCameraDevice
                }
            } else {
                // Fallback on earlier versions
                if let cameraDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
                    defaultVedioDevice = cameraDevice
                }
            }
            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVedioDevice)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            }
        }
        catch {
            print("could not add device input to the session.")
            
        }
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue(label: "com.yoloyolo.metadataQueue", qos: DispatchQoS.default, attributes: [], target: nil))
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
            metadataOutput.rectOfInterest = rectOfInteres
        }
        
        captureSession.commitConfiguration()
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.frame = view.bounds
        view.layer.addSublayer(capturePreviewLayer!)
        
        
//        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
//            return
//        }
//        captureSession?.addInput(deviceInput)
//        
//        let captureMetaDataOutput = AVCaptureMetadataOutput()
//        
//        captureSession?.addOutput(captureMetaDataOutput)
//        
//        let queue = DispatchQueue(label: "com.yoloyolo.qrcode")
//        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: queue)
//        
//        captureMetaDataOutput.metadataObjectTypes = captureMetaDataOutput.availableMetadataObjectTypes
//        
//        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        
//        capturePreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
//        capturePreviewLayer?.frame = view.bounds
//        view.layer.addSublayer(capturePreviewLayer!)
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
                    self?.captureSession.stopRunning()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
