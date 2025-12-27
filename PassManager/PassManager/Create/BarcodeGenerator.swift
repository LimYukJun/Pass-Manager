//
//  BarcodeGenerator.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 26/6/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

extension Image {
    init(pdf417 code: String) {
        let context = CIContext()
        let filter = CIFilter.pdf417BarcodeGenerator()
        filter.message = Data(code.utf8)
        
        if let ciImage = filter.outputImage,
           let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            self = Image(cgImage, scale: 1, label: Text("PDF417 barcode"))
        } else {
            self = Image(systemName: "xmark.circle")
        }
    }
}
