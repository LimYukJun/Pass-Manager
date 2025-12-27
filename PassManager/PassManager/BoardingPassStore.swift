//
//  BoardingPassStore.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 27/12/25.
//


import Foundation

final class BoardingPassStore: ObservableObject {
    @Published var passes: [BoardingPass] = []

    func toggle(raw: String) {
        guard let parsed = parseBCBP(raw) else { return }

        if let index = passes.firstIndex(of: parsed) {
            passes.remove(at: index)
        } else {
            passes.append(parsed)
        }
    }

    func remove(_ pass: BoardingPass) {
        passes.removeAll { $0.id == pass.id }
    }
}
