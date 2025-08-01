//
//  FirestoreManager.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 26/6/25.
//

import FirebaseFirestore

class FirestoreManager {
    private let db = Firestore.firestore()

    func uploadBarcode(_ code: String) {
        let data: [String: Any] = [
            "barcode": code,
            "timestamp": Timestamp(date: Date()),
            "comment": ""
        ]

        db.collection("barcodes").addDocument(data: data) { error in
            if let error = error {
                print("❌ Upload failed: \(error)")
            } else {
                print("✅ Uploaded barcode: \(code)")
            }
        }
    }

    func deleteBarcode(_ code: String) {
        db.collection("barcodes")
            .whereField("barcode", isEqualTo: code)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error finding barcode to delete: \(error)")
                    return
                }

                for document in snapshot?.documents ?? [] {
                    document.reference.delete { err in
                        if let err = err {
                            print("❌ Error deleting barcode: \(err)")
                        } else {
                            print("🗑️ Deleted barcode: \(code)")
                        }
                    }
                }
            }
    }

    func fetchBarcodes(completion: @escaping ([String]) -> Void) {
        db.collection("barcodes")
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Fetch error: \(error)")
                    completion([])
                    return
                }

                let barcodes = snapshot?.documents.compactMap {
                    $0.data()["barcode"] as? String
                } ?? []

                print("📥 Fetched barcodes: \(barcodes.count)")
                completion(barcodes)
            }
    }
}
