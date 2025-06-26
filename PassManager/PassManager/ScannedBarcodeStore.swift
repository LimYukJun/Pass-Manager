//
//  ScannedBarcodeStore.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 26/6/25.
//

import Foundation

class ScannedBarcodeStore: ObservableObject {
    @Published var scannedBarcodes: [String] = []

    func toggleBarcode(_ value: String) {
        if let index = scannedBarcodes.firstIndex(of: value) {
            scannedBarcodes.remove(at: index)
        } else {
            scannedBarcodes.append(value)
        }
    }
}
