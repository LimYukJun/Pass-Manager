//
//  ContentView.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 26/6/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = ScannedBarcodeStore()
    @StateObject private var store2 = BoardingPassStore()

    var body: some View {
        TabView {
            BarcodeGeneratorView()
                .tabItem {
                    Label("Generate", systemImage: "barcode.viewfinder")
                }

            BarcodeScannerView()
                .environmentObject(store)
                .tabItem {
                    Label("Scan", systemImage: "camera.viewfinder")
                }
            BoardingPassView()
                .environmentObject(store2)
                .tabItem {
                    Label("Flight", systemImage: "airplane.departure")
                }
        }
    }
}


#Preview {
    ContentView()
}
