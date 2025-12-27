//
//  BarcodeGeneratorView.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 26/6/25.
//

import SwiftUI

struct BarcodeGeneratorView: View {
    @State private var barcodeInput = "Barcode Info"
    @State private var exportText = "Exported Label"

    var body: some View {
        VStack(spacing: 20) {
            TextField("Barcode text", text: $barcodeInput)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            TextField("Label for export", text: $exportText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Image(pdf417: barcodeInput)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(height: 200)

            Menu("Export Barcode + Label") {
                Button("📤 Share") {
                    export(type: .share)
                }

                Button("💾 Save to Files") {
                    export(type: .saveToFiles)
                }
            }
            .padding()
        }
        .padding()
    }

    enum ExportType {
        case share, saveToFiles
    }

    private func export(type: ExportType) {
        guard let barcodeImage = BarcodeExporter.generatePDF417(from: barcodeInput),
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController
        else {
            print("Failed to export")
            return
        }

        let combined = BarcodeExporter.combinedImage(label: exportText, barcode: barcodeImage)

        switch type {
        case .share:
            BarcodeExporter.shareImage(combined, from: rootVC)
        case .saveToFiles:
            BarcodeExporter.saveToFiles(combined, from: rootVC)
        }
    }
}




#Preview {
    BarcodeGeneratorView()
}
