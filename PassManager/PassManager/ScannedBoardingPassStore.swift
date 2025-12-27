//
//  ScannedBoardingPassStore.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 27/12/25.
//

import SwiftUI

final class ScannedBoardingPassStore: ObservableObject {
    @Published var passes: [BoardingPass] = []

    func toggle(_ pass: BoardingPass) {
        if passes.contains(pass) {
            passes.removeAll { $0 == pass }
        } else {
            passes.append(pass)
        }
    }
}
