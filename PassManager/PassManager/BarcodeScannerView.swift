//
//  BarcodeScannerView.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 26/6/25.
//

import SwiftUI

struct BarcodeScannerView: View {
    @EnvironmentObject var store: ScannedBarcodeStore
    @State private var lastScanned: String?
    @State private var message: String?
    
    let firestore = FirestoreManager()

    var body: some View {
        VStack {
            // Barcode Scanner Camera View
            ZStack {
                ScannerView { scannedValue in
                    guard scannedValue != lastScanned else { return }
                    lastScanned = scannedValue

                    store.toggleBarcode(scannedValue)

                    if store.scannedBarcodes.contains(scannedValue) {
                        message = "✅ Added: \(scannedValue)"
                        firestore.uploadBarcode(scannedValue) // 🔥 Upload to Firebase
                    } else {
                        message = "❌ Removed: \(scannedValue)"
                        firestore.deleteBarcode(scannedValue) // 🗑️ Delete
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        message = nil
                    }
                }

                if let message = message {
                    Text(message)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding()
                        .transition(.opacity)
                }
            }
            .frame(height: 300)
            .clipped()

            Divider().padding(.vertical)

            // Header with count
            HStack {
                Text("Scanned Barcodes (\(store.scannedBarcodes.count))")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)

            // Barcode List
            List {
                ForEach(store.scannedBarcodes, id: \.self) { code in
                    HStack(alignment: .top) {
                        Text(code)
                            .fixedSize(horizontal: false, vertical: true) // wrap text

                        Spacer()

                        Button(action: {
                            store.toggleBarcode(code)
                            firestore.deleteBarcode(code) // 🗑️ Delete on manual remove
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Scanner")
    }
}


#Preview {
    BarcodeScannerView()
}
