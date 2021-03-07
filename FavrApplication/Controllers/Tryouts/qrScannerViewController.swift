//
//  qrScannerViewController.swift
//  FavrApplication
//
//  Created by Aniket Gupta on 23/02/2021.
//

import UIKit
import AVFoundation
import NotificationCenter
import Firebase

class qrScannerViewController: UIViewController {
    
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView: UIView?
    
    private let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "FavrDarkOrange")
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "FavrDarkOrange")
        label.textColor = UIColor(named: "LightAccent")
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        label.text = "Scanning..."
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 18)
        button.tintColor = UIColor(named: "LightAccent")
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and contains at least one object
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR Code is detected"
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the qr code metadata then update the label
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                DatabaseManager.shared.userExists(with: metadataObj.stringValue!, completion: { [weak self] exists in
                    if !exists {
                        self?.messageLabel.text = "User Not Found"
                    }
                    if metadataObj.stringValue! == Auth.auth().currentUser?.email {
                        self?.messageLabel.text = "Hey, it's you!"
                    }
                    else {
                        let userValue = metadataObj.stringValue!
                        self?.messageLabel.text = "User Found"
                        let vc = UserInformationViewController()
                        vc.otherUserEmail = userValue
                        vc.dismissButton.isHidden = false
                        vc.backButton.isHidden = true
                        let nav = UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true, completion: nil)
                    }
                })
               
            }
        }
    }
    
    
    
//    func fromBase64 (string: String) -> String {
//        let base64Decoded = Data(base64Encoded: string)!
//        let decodedString = String(data: base64Decoded, encoding: .utf8)!
//        
//        return decodedString
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing the QR Code
        
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("qrDismissButtonTapped"), object: nil, queue: nil) { (_) in
            
            // Dismiss this View
            self.dismiss(animated: true, completion: nil)
        }
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session
            captureSession.addInput(input)
            
            // Initialse an AVCaptureMetadataOutput object and set ut as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default method to execute code
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialise the video preview layer and add it as a sublayer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start capture
            captureSession.startRunning()
            
            // Move message label and tab bar to the front
            topBar.addSubview(cancelButton)
            view.addSubview(messageLabel)
            view.addSubview(topBar)
            
            view.bringSubviewToFront(messageLabel)
            view.bringSubviewToFront(topBar)
            // Initialise QR Code frame to highlight the code
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor(named: "FavrOrange")?.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
        }
        catch {
            // If any error occurs simply display it to the user and do not continue any more
            
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topBar.frame = CGRect(x: 0,
                              y: 0,
                              width: view.frame.size.width,
                              height: 100)
        cancelButton.frame = CGRect(x: topBar.width-110,
                                    y: 40,
                                    width: 100,
                                    height: 30)
        messageLabel.frame = CGRect(x: 0,
                                    y: view.frame.size.height-60,
                                    width: view.frame.size.width,
                                    height: 60)
    }
    
    

}

extension qrScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}
