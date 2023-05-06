//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Guilherme Golfetto on 30/04/23.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    //-----------------------------------------------------------------------
    // MARK: - Binding
    //-----------------------------------------------------------------------

    @Binding var scannedCode: String
    @Binding var alertItem: AlertItem?
    
    //-----------------------------------------------------------------------
    // MARK: - UIViewControllerRepresentable
    //-----------------------------------------------------------------------
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    //-----------------------------------------------------------------------
    // MARK: - Coordinator
    //-----------------------------------------------------------------------

    final class Coordinator: NSObject, ScannerVCDelegate {
        
        //-----------------------------------------------------------------------
        // MARK: - Private Properties
        //-----------------------------------------------------------------------

        private let scannerView: ScannerView
        
        //-----------------------------------------------------------------------
        // MARK: - Initialization
        //-----------------------------------------------------------------------
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        //-----------------------------------------------------------------------
        // MARK: - ScannerVCDelegate
        //-----------------------------------------------------------------------

        func didFind(barcorde: String) {
            scannerView.scannedCode = barcorde
        }
        
        func didSurface(error: CameraError) {
            switch error {
            case .invalidDeviceInput:
                scannerView.alertItem = AlertContext.invalidDeviceInput
            case .invalidScannedValue:
                scannerView.alertItem = AlertContext.invalidScannedValue
            }
        
        }
        
    }
}

