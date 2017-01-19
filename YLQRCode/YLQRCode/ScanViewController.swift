//
//  ScanViewController.swift
//  YLQRCode
//
//  Created by yolo on 2017/1/1.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

enum ScanSetupResult {
    case successed
    case failed
    case unknown
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession? = nil
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    var deviceInput: AVCaptureDeviceInput?
    var metadataOutput: AVCaptureMetadataOutput?
    var dimmingVIew: DimmingView?
    
    var timer: Timer?
    
    var lastScaleFactor: CGFloat = 1.0

    let rect = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
    var rectOfInteres = CGRect.zero
    
    var sessionQueue = DispatchQueue(label: "tv.yoloyolo.metadataQueue", attributes: [], target: nil)
    
    fileprivate var moveView: UIImageView!
    
    fileprivate var setupResult = ScanSetupResult.successed
    
    fileprivate var isFirstPush = false

    override func viewDidLoad() {
        super.viewDidLoad()

        isFirstPush = true
        
        func authorizationStatus() -> ScanSetupResult {
            var setupResult = ScanSetupResult.successed
            let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            switch authorizationStatus {
            case .authorized:
                setupResult = ScanSetupResult.successed
            case .notDetermined:
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                    if !granted {
                        setupResult = ScanSetupResult.failed
                    }
                })
                break
            case .denied:
                setupResult = ScanSetupResult.failed
                break
            default:
                setupResult = ScanSetupResult.unknown
                break
            }
            return setupResult
        }
        
        self.setupResult = authorizationStatus()
        dimmingVIew = DimmingView(frame: view.bounds)
        dimmingVIew?.rectOfInteract = CGRect(x: (view.frame.width - 250) * 0.5, y: (view.frame.height - 250) * 0.5 - 80, width: 250, height: 250)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(configPanchGesture(gesture:)))
        dimmingVIew?.addGestureRecognizer(pinchGesture)
        view.addSubview(dimmingVIew!)
        
        rectOfInteres = CGRect(x: ((view.frame.height - 250) * 0.5 - 80) / view.frame.height, y: (view.frame.width - 250) * 0.5 / view.frame.width, width: 250/view.frame.height, height: 250/view.frame.width)
        self.sessionQueue.sync { [weak self] in
            self?.configSession()
        }
        
        let slider = UISlider()
        slider.minimumValue = 1.0
        slider.maximumValue = 5.0
        slider.frame = CGRect(x: 56, y: UIScreen.main.bounds.height - 56, width: UIScreen.main.bounds.width - 56 * 2, height: 56)
        view.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: .valueChanged)
        
        timer = Timer(timeInterval: 20.0, target: self, selector: #selector(showNotice(timer:)), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)

        sessionQueue.sync { [unowned self] in
            switch self.setupResult {
            case .successed:
                if self.isFirstPush {
                    self.captureSession?.startRunning()
                }
            case .failed:
                DispatchQueue.main.async { [unowned self] in
                    let message = "没有权限获取相机"
                    let	alertController = UIAlertController(title: "YLQRCode", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: "设置", style: .`default`, handler: { action in
                        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            case .unknown:
                DispatchQueue.main.async { [unowned self] in
                    let message = "没有权限获取相机"
                    let	alertController = UIAlertController(title: "YLQRCode", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: "设置", style: .`default`, handler: { action in
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
            self.captureSession?.stopRunning()
            self.timer?.invalidate()
        }
    }
    
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func sliderValueChanged(slider: UISlider) {
        guard let session = captureSession else { return }
        if session.isRunning {
            do {
                try deviceInput?.device.lockForConfiguration()
                deviceInput?.device.videoZoomFactor = CGFloat(slider.value)
                deviceInput?.device.unlockForConfiguration()
            }
            catch {
                print("Error when set videoZoomFactor.")
            }
        }
    }
    
    @objc private func showNotice(timer: Timer) {
        let alertView = UIAlertView(title: "提醒", message: "未发现二维码", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
    }
    
    @objc private func configPanchGesture(gesture: UIPinchGestureRecognizer) {
        guard let session = captureSession else { return }
        if session.isRunning {
//            let pinchVelocityDividerFactor: CGFloat = 2.0
            if gesture.state == .changed {
//                do {
//                    try deviceInput?.device.lockForConfiguration()
//                    let desiredFacetor = deviceInput!.device.videoZoomFactor + CGFloat(atan2f(Float(pinchVelocityDividerFactor), Float(gesture.velocity)))
//                    deviceInput?.device.videoZoomFactor = max(1.0, min(desiredFacetor, deviceInput!.device.activeFormat.videoMaxZoomFactor))
//                    deviceInput?.device.unlockForConfiguration()
//                }
//                catch {
//                    print("")
//                }
                
            }
//            print(gesture.scale + 1.0)
//            do {
//                try deviceInput?.device.lockForConfiguration()
//                deviceInput?.device.videoZoomFactor = gesture.scale + 1.0
//                deviceInput?.device.unlockForConfiguration()
//            }
//            catch {
//                print("Error when set videoZoomFactor.")
//            }
//            lastScaleFactor = gesture.scale
        }
    }
    
    private func configSession() {
        
        if setupResult != .successed {
            return
        }
        captureSession = AVCaptureSession()
        
        /// setup session
        captureSession?.beginConfiguration()
        
        do {
            var defaultVedioDevice: AVCaptureDevice?
            
            if #available(iOS 10.0, *) {
                if let backCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back) {
                    defaultVedioDevice = backCameraDevice
                }
                else if let frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) {
                    defaultVedioDevice = frontCameraDevice
                }
            }
            else {
                if let cameraDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
                    defaultVedioDevice = cameraDevice
                }
            }
            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVedioDevice)
            
            if captureSession!.canAddInput(videoDeviceInput) {
                captureSession?.addInput(videoDeviceInput)
            }
            self.deviceInput = videoDeviceInput
        }
        catch {
            print("无法添加input.")
            
        }
        metadataOutput = AVCaptureMetadataOutput()
        if captureSession!.canAddOutput(metadataOutput) {
            captureSession?.addOutput(metadataOutput)
        }
        metadataOutput?.setMetadataObjectsDelegate(self, queue: self.sessionQueue)
        metadataOutput?.metadataObjectTypes = metadataOutput?.availableMetadataObjectTypes
        metadataOutput?.rectOfInterest = self.rectOfInteres
        
        
        captureSession?.commitConfiguration()
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.frame = view.bounds
        view.layer.insertSublayer(capturePreviewLayer!, at: 0)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        for _supportedBarcode in metadataObjects {
           
            guard let supportedBarcode = _supportedBarcode as? AVMetadataObject else { return }
            
            if supportedBarcode.type == AVMetadataObjectTypeQRCode {
                guard let barcodeObject = self.capturePreviewLayer?.transformedMetadataObject(for: supportedBarcode) as? AVMetadataMachineReadableCodeObject else { return }
                DispatchQueue.safeMainQueue { [weak self] in
                    print(barcodeObject.stringValue)
                    self?.captureSession?.stopRunning()
                    self?.timer?.invalidate()
                    self?.dimmingVIew?.removeAnimations()
                }
            }
        }
    }
    @IBAction func openAlbumAction(_ sender: Any) {
        self.captureSession?.stopRunning()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerView = UIImagePickerController()
            imagePickerView.allowsEditing = false
            imagePickerView.sourceType = .photoLibrary
            imagePickerView.delegate = self
            present(imagePickerView, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scanQRCodeFromPhotoLibrary(image: UIImage, block:((String?) -> Void)) -> Bool {
        guard let cgImage = image.cgImage else { return false }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector!.features(in: CIImage(cgImage: cgImage))
        for feature in features { // 这里实际上可以识别两张二维码，在这里只取第一张（左边或者上边）
            if let qrFeature = feature as? CIQRCodeFeature {
                isFirstPush = false
                self.captureSession?.stopRunning()
                block(qrFeature.messageString!)
                return true
            }
        }
        return false
    }
}

extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let hasQRCode = self.scanQRCodeFromPhotoLibrary(image: image) { str in
                print(str!)
            }
            if !hasQRCode {
                let alertView = UIAlertView(title: "提醒", message: "没有二维码", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alertView.show()
            }
        }
    }
}
