//
//  BoardingPassView.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 27/12/25.
//

import SwiftUI

struct BoardingPassView: View {
    @EnvironmentObject var store: BoardingPassStore
    @State private var lastScanned: String?
    @State private var message: String?
    
    let firestore = FirestoreManager()
    
    var body: some View {
        VStack {
            BoardingPassScannerView()
            
            Divider().padding(.vertical)
            
            HStack {
                Text("Scanned Boarding Passes (\(store.passes.count))")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            List {
                ForEach(store.passes) { pass in
                    BoardingPassRow(
                        pass: pass,
                        onDelete: {
                            store.remove(pass)
                            FirestoreManager().deleteBarcode(pass.raw)
                        }
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .buttonStyle(.plain)          // 🔑 prevents row hijacking
                }
            }
            .listStyle(.plain)

        }
        .navigationTitle("Boarding Pass")
    }
}



#Preview {
    BoardingPassView()
}
