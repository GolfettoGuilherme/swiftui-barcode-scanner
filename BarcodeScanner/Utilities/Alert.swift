//
//  Alert.swift
//  BarcodeScanner
//
//  Created by Guilherme Golfetto on 06/05/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(
        title: "Invalid Device",
        message: "Something is wrong with the camera",
        dismissButton: .default(Text("Ok"))
    )
    
    static let invalidScannedValue = AlertItem(
        title: "Invalid Scan Type",
        message: "The value scanned is not valid.",
        dismissButton: .default(Text("Ok"))
    )
}

enum CameraError {
    case invalidDeviceInput
    case invalidScannedValue
}
