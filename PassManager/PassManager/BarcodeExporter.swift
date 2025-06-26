//
//  BarcodeExporter.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 26/6/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit
import UniformTypeIdentifiers

struct BarcodeExporter {
    static func generatePDF417(from string: String) -> UIImage? {
        let filter = CIFilter.pdf417BarcodeGenerator()
        filter.message = Data(string.utf8)

        let context = CIContext()
        guard let ciImage = filter.outputImage,
              let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    static func combinedImage(label: String, barcode: UIImage) -> UIImage {
        let font = UIFont.systemFont(ofSize: 20)
        let spacing: CGFloat = 20
        let padding: CGFloat = 20
        let labelWidth = barcode.size.width

        // Prepare wrapped attributed string
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]

        let attributedText = NSAttributedString(string: label, attributes: attributes)
        let textRect = attributedText.boundingRect(
            with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        let totalWidth = barcode.size.width + padding * 2
        let totalHeight = textRect.height + spacing + barcode.size.height + padding * 2

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: totalWidth, height: totalHeight))

        return renderer.image { _ in
            // Draw text
            let textOrigin = CGPoint(x: padding, y: padding)
            attributedText.draw(
                with: CGRect(origin: textOrigin, size: CGSize(width: labelWidth, height: textRect.height)),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            )

            // Draw barcode
            let barcodeX = (totalWidth - barcode.size.width) / 2
            let barcodeY = padding + textRect.height + spacing
            barcode.draw(at: CGPoint(x: barcodeX, y: barcodeY))
        }
    }


    static func shareImage(_ image: UIImage, from viewController: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }

    static func saveToFiles(_ image: UIImage, from viewController: UIViewController) {
        guard let imageData = image.pngData() else { return }

        let tempDir = FileManager.default.temporaryDirectory
        let filename = tempDir.appendingPathComponent("barcode_\(UUID().uuidString).png")

        do {
            try imageData.write(to: filename)

            let activityVC = UIActivityViewController(activityItems: [filename], applicationActivities: nil)

            // Optional: exclude sharing-only types
            activityVC.excludedActivityTypes = [
                .postToFacebook, .postToTwitter, .airDrop,
                .assignToContact, .addToReadingList, .openInIBooks, .markupAsPDF
            ]

            viewController.present(activityVC, animated: true)
        } catch {
            print("Error saving file: \(error.localizedDescription)")
        }
    }
}
