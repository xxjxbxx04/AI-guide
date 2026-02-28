//
//  StepRow.swift
//  AIGuide
//
//  Numbered step row with circle indicator
//

import SwiftUI

struct StepRow: View {
    let number: Int
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.18))
                    .frame(width: 28, height: 28)

                Text("\(number)")
                    .font(.caption.bold())
                    .foregroundStyle(color)
            }

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        StepRow(number: 1, text: "Download Proxmox ISO from the website", color: .blue)
        StepRow(number: 2, text: "Flash it to a USB drive with Balena Etcher", color: .blue)
        StepRow(number: 3, text: "Boot from USB and follow the installer", color: .blue)
    }
    .padding()
}
