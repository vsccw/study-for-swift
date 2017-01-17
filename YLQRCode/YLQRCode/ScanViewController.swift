//
//  ScanViewController.swift
//  YLQRCode
//
//  Created by yolo on 2017/1/1.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit
import AVFoundation

enum ScanSetupResult {
    case successed
    case failed
    case unknown
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let captureSession = AVCaptureSession()
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    var metadataOutput: AVCaptureMetadataOutput?

    let rect = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
    var rectOfInteres = CGRect.zero
    
    var sessionQueue = DispatchQueue(label: "tv.yoloyolo.metadataQueue", attributes: [], target: nil)
    
    fileprivate var moveView: UIImageView!
    
    fileprivate var setupResult = ScanSetupResult.successed

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authorizationStatus {
        case .authorized:
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [weak self] (granted) in
                if !granted {
                    self?.setupResult = .failed
                }
                self?.sessionQueue.resume()
            })
            break
        case .denied:
            setupResult = .failed
            break
        default:
            setupResult = .unknown
            break
        }
        
        rectOfInteres = CGRect(x: (view.frame.height - 220) / (2 * view.frame.height), y: (view.frame.width - 220) / (2 * view.frame.width), width: 220/view.frame.height, height: 220/view.frame.width)
        self.sessionQueue.sync { [weak self] in
            self?.configSession()
        }
        
        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.80)
        view.addSubview(dimmingView)
        view.backgroundColor = UIColor.black
        let targetRectView = UIImageView(frame: CGRect(x: 0, y: 0, width: 220, height: 220))
        targetRectView.image = UIImage(named: "target_rect")
        targetRectView.center = view.center
        targetRectView.backgroundColor = UIColor.clear
        view.addSubview(targetRectView)
        
        let moveView = UIImageView(frame: CGRect(x: 0, y: 0, width: 220, height: 3))
        moveView.image = UIImage(named: "Line")
        
        targetRectView.addSubview(moveView)
        self.moveView = moveView
        
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = 0
        animation.toValue = 220
        animation.repeatCount = MAXFLOAT
        animation.duration = 3.0
        moveView.layer.add(animation, forKey: "moveView.transform.translation.y")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionQueue.sync { [unowned self] in
            switch self.setupResult {
            case .successed:
                self.captureSession.startRunning()
              
            case .failed:
                DispatchQueue.main.async { [unowned self] in
                    let message = NSLocalizedString("没有权限获取相机", comment: "请给我相机权限")
                    let	alertController = UIAlertController(title: "YLQRCode", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("好", comment: "Alert OK button"), style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: "设置", style: .`default`, handler: { action in
                        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            case .unknown:
                DispatchQueue.main.async { [unowned self] in
                    let message = NSLocalizedString("没有权限获取相机", comment: "请给我相机权限")
                    let	alertController = UIAlertController(title: "YLQRCode", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .`default`, handler: { action in
                        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if setupResult == .successed {
            self.captureSession.stopRunning()
        }
    }
    
    private func configSession() {
        
        if setupResult != .successed {
            return
        }
        
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
            }
            else {
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
        metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
        }
        metadataOutput?.setMetadataObjectsDelegate(self, queue: self.sessionQueue)
        metadataOutput?.metadataObjectTypes = metadataOutput?.availableMetadataObjectTypes
        metadataOutput?.rectOfInterest = self.rectOfInteres
        print(rectOfInteres)
        
        captureSession.commitConfiguration()
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.frame = view.bounds
        view.layer.insertSublayer(capturePreviewLayer!, at: 0)
        
        
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
                    self?.moveView.layer.removeAnimation(forKey: "moveView.transform.translation.y")
                    self?.moveView.removeFromSuperview()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
