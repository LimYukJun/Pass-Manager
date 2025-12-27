//
//  String+Slice.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 27/12/25.
//

import Foundation

extension String {
    func slice(_ start: Int, _ length: Int) -> String {
        guard count >= start + length else { return "" }
        let s = index(startIndex, offsetBy: start)
        let e = index(s, offsetBy: length)
        return String(self[s..<e]).trimmingCharacters(in: .whitespaces)
    }
}
