//
//  BoardingPassScannerView.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 27/12/25.
//


import SwiftUI

struct BoardingPassScannerView: View {

    @EnvironmentObject var store: BoardingPassStore
    @State private var lastScanned: String?
    @State private var message: String?

    private let firestore = FirestoreManager()

    var body: some View {
        ZStack {
            ScannerView { rawValue in
                handleScan(rawValue)
            }

            if let message = message {
                feedbackView(message)
            }
        }
        .frame(height: 300)
        .clipped()
    }

    // MARK: - Scan Handler

    private func handleScan(_ raw: String) {
        guard raw != lastScanned else { return }
        lastScanned = raw

        guard let pass = parseBCBP(raw) else {
            showMessage("⚠️ Invalid boarding pass")
            return
        }

        store.toggle(raw: raw)

        showMessage("✅ \(pass.passengerName) \(pass.from)→\(pass.to)")

        firestore.uploadBarcode(raw)
    }

    // MARK: - Feedback UI

    private func showMessage(_ text: String) {
        message = text

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            message = nil
        }
    }

    private func feedbackView(_ text: String) -> some View {
        Text(text)
            .padding()
            .background(.black.opacity(0.75))
            .foregroundColor(.white)
            .cornerRadius(14)
            .padding()
            .transition(.opacity)
    }
}
