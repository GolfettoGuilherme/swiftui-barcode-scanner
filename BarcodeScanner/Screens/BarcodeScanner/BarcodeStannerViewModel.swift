//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Guilherme Golfetto on 06/05/23.
//

import SwiftUI

final class BarcodeScannerViewModel: ObservableObject {
 
    @Published var scannedCode = ""
    @Published var alertItem: AlertItem?
    
    var statusText: String {
        scannedCode.isEmpty ? "Not yet Scanned" : scannedCode
    }
    
    var statucColor: Color {
        scannedCode.isEmpty ? .red : .green
    }
    
}
