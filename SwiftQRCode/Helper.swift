//
//  Helper.swift
//  SwiftQRCode
//
//  Created by Angelos Staboulis on 22/7/24.
//

import Foundation
import UIKit
import AVFoundation
class Helper:NSObject,AVCaptureMetadataOutputObjectsDelegate{
    var metaDataOutput = AVCaptureMetadataOutput()
    var captureSession = AVCaptureSession()
    init(metaDataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput(), captureSession: AVCaptureSession = AVCaptureSession()) {
        self.metaDataOutput = metaDataOutput
        self.captureSession = captureSession
    }
    func setupCaptureSession(device: AVCaptureDevice){
        do{
            let deviceInput = try AVCaptureDeviceInput(device: device)
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
        }catch{
            debugPrint("something went wrong!!!!")
        }
    }
    func createPreview(view:UIView,captureSession: AVCaptureSession){
        let previewLayer = AVCaptureVideoPreviewLayer(session:captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    func runCaptureSession(captureSession: AVCaptureSession){
        if  !captureSession.isRunning{
            DispatchQueue.global(qos: .userInteractive).async {
                captureSession.startRunning()
            }
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
