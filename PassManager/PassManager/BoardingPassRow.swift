//
//  BoardingPassRow.swift
//  PassManager
//
//  Created by Yuk Jun Lim on 27/12/25.
//

import SwiftUI

struct BoardingPassRow: View {
    let pass: BoardingPass
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                Text(pass.passengerName)
                    .font(.headline)

                Spacer()

                Text(pass.pnr)
                    .foregroundColor(.secondary)

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)   // 🔑 prevents row-tap behavior
            }

            Text("\(pass.from) → \(pass.to)")
                .font(.title2)
                .bold()

            HStack {
                Text("\(pass.airline) \(pass.flight)")
                Spacer()
                Text("Seat \(pass.seat)")
            }
            .font(.subheadline)

            Text(pass.cabin)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .contentShape(Rectangle()) // row has shape, but no action
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8)
        )
        .padding(.vertical, 6)
    }
}
