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
    let helper = Helper()
    override func viewDidLoad() {
        super.viewDidLoad()
        helper.captureSession = captureSession
        helper.metaDataOutput = metaDataOutput
        // Do any additional setup after loading the view.
           
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let getDevice = device else{
            return
        }
        helper.setupCaptureSession(device: getDevice)
        helper.createPreview(view: self.view, captureSession: captureSession)
        helper.runCaptureSession(captureSession: captureSession)
    }
   

}

