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
    @StateObject var store = ScannedBarcodeStore()
    init() {
            FirebaseApp.configure()
            store.loadFromFirebase()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ScannedBarcodeStore())
        }
    }
}
