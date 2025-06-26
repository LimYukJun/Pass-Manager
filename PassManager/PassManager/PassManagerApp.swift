//
//  PassManagerApp.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 26/6/25.
//

import SwiftUI
import Firebase

@main
struct PassManagerApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ScannedBarcodeStore())
        }
    }
}
