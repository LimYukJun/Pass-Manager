//
//  BCBPParser.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 27/12/25.
//

import Foundation

// MARK: - Boarding Pass Model

struct BoardingPass: Identifiable, Hashable {
    let id = UUID()
    let passengerName: String
    let pnr: String
    let from: String
    let to: String
    let airline: String
    let flight: String
    let seat: String
    let cabin: String
    let raw: String
}

// MARK: - Cabin Decoder

func cabinName(_ code: String) -> String {
    switch code {
    case "F": return "First"
    case "J", "C": return "Business"
    case "W": return "Premium Economy"
    case "Y", "M": return "Economy"
    default: return "Unknown"
    }
}

// MARK: - Normalize

func normalizeBCBP(_ raw: String) -> String {
    raw
        .replacingOccurrences(of: "\n", with: "")
        .replacingOccurrences(of: "\r", with: "")
        .replacingOccurrences(of: " ", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

// MARK: - Safe slice

func slice(_ s: String, _ start: Int, _ length: Int) -> String {
    guard start >= 0, s.count >= start + length else { return "" }
    let a = s.index(s.startIndex, offsetBy: start)
    let b = s.index(a, offsetBy: length)
    return String(s[a..<b])
}

// MARK: - Find PNR (shifted left by 1)

func findPNRAnchor(_ s: String) -> (pnr: String, index: Int)? {
    let regex = try! NSRegularExpression(pattern: "[A-Z0-9]{7}")
    let range = NSRange(s.startIndex..<s.endIndex, in: s)

    for match in regex.matches(in: s, range: range) {
        let start = match.range.location
        let adjustedStart = max(start - 1, 0)

        if adjustedStart > 10 {
            let pnr = slice(s, adjustedStart, 7)
            return (pnr, adjustedStart)
        }
    }
    return nil
}

// MARK: - Parser (ALL OFFSETS FIXED)

func parseBCBP(_ raw: String) -> BoardingPass? {

    let s = normalizeBCBP(raw)
    guard s.count > 70 else { return nil }

    // 1️⃣ Find PNR
    guard let anchor = findPNRAnchor(s) else { return nil }

    let pnr = anchor.pnr
    let pnrIndex = anchor.index

    // 2️⃣ Passenger name (clean end)
    let passengerName = slice(s, 2, pnrIndex - 2)
        .replacingOccurrences(of: "/", with: " ")
        .trimmingCharacters(in: .whitespaces)

    // 3️⃣ Base AFTER PNR (already shifted)
    let base = pnrIndex + 7

    // 🔻 EVERY FIELD OFFSET MOVED LEFT BY 1 🔻

    let from = slice(s, base, 3)          // was +1
    let to = slice(s, base + 3, 3)         // was +4

    let airline = slice(s, base + 6, 2)    // was +7
    let flight = slice(s, base + 8, 4)     // was +9

    let cabinCode = slice(s, base + 15, 1) // was +18
    let seat = slice(s, base + 16, 4)      // was +19
        .trimmingCharacters(in: .whitespaces)

    return BoardingPass(
        passengerName: passengerName,
        pnr: pnr,
        from: from,
        to: to,
        airline: airline,
        flight: flight,
        seat: seat,
        cabin: cabinName(cabinCode),
        raw: raw
    )
}
