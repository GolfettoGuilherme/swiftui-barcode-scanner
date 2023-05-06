//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Guilherme Golfetto on 30/04/23.
//

import UIKit
import SwiftUI
import AVFoundation

protocol ScannerVCDelegate: AnyObject {
    func didFind(barcorde: String)
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController {
    
    //-----------------------------------------------------------------------
    // MARK: - Stored properties
    //-----------------------------------------------------------------------

    let captureSession = AVCaptureSession()
    var previewLaywer: AVCaptureVideoPreviewLayer?
    
    //-----------------------------------------------------------------------
    // MARK: - Injected properties
    //-----------------------------------------------------------------------

    weak var scannerDelegate: ScannerVCDelegate!
    
    //-----------------------------------------------------------------------
    // MARK: - Initialization
    //-----------------------------------------------------------------------
    
    init(scannerDelegate: ScannerVCDelegate!) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //-----------------------------------------------------------------------
    // MARK: - View lifecycle
    //-----------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCatureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLaywer = previewLaywer else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLaywer.frame = view.layer.bounds
    }
    
    //-----------------------------------------------------------------------
    // MARK: - Private methods
    //-----------------------------------------------------------------------
    
    private func setupCatureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLaywer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLaywer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLaywer!)
            
        captureSession.startRunning()
    }
    
}

extension ScannerVC : AVCaptureMetadataOutputObjectsDelegate {
    
    //-----------------------------------------------------------------------
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    //-----------------------------------------------------------------------
    
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first else {
            scannerDelegate.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate.didSurface(error: .invalidScannedValue)
            return
        }
        
        scannerDelegate.didFind(barcorde: barcode)
    }
}
