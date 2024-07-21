//
//  ViewController.swift
//  SwiftQRCode
//
//  Created by Angelos Staboulis on 19/7/24.
//

import UIKit
import AVFoundation
class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    let device = AVCaptureDevice.default(for: .video)
    let captureSession = AVCaptureSession()
    let metaDataOutput = AVCaptureMetadataOutput()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
           
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do{
            guard let getDevice = device else{
                return
            }
            let deviceInput = try AVCaptureDeviceInput(device: getDevice)
            if captureSession.canAddInput(deviceInput){
                captureSession.addInput(deviceInput)
            }else{
                return
            }
            if captureSession.canAddOutput(metaDataOutput){
                captureSession.addOutput(metaDataOutput)
                metaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
                metaDataOutput.metadataObjectTypes = [.qr]
            }else{
                return
            }
            
            
            let previewLayer = AVCaptureVideoPreviewLayer(session:captureSession)
            previewLayer.session = captureSession
            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            if  !captureSession.isRunning{
                DispatchQueue.global(qos: .userInteractive).async {
                    self.captureSession.startRunning()
                }
               
            }
            
        }catch{
            debugPrint("something went wrong!!!")
        }
    }
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if captureSession.isRunning == true{
            DispatchQueue.global(qos: .userInteractive).async {
                self.captureSession.stopRunning()
            }
        }
        if let metadataObject = metadataObjects.first{
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else{
                return
            }
            guard let code = readableObject.stringValue else{
                return
            }
            debugPrint("qr code=",code)
        }
      
        
       
            
    }

}

