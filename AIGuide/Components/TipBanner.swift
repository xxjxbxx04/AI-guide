//
//  TipBanner.swift
//  AIGuide
//
//  Yellow-tinted tip/warning banners for guide content
//

import SwiftUI

struct TipBanner: View {
    let text: String
    let style: Style

    enum Style {
        case tip
        case warning

        var icon: String {
            switch self {
            case .tip: return "lightbulb.fill"
            case .warning: return "exclamationmark.triangle.fill"
            }
        }

        var color: Color {
            switch self {
            case .tip: return .yellow
            case .warning: return .red
            }
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: style.icon)
                .foregroundStyle(style.color)
                .font(.subheadline)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(style.color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style.color.opacity(0.25), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        TipBanner(text: "Use VirtIO drivers for best performance.", style: .tip)
        TipBanner(text: "This will delete all data on the disk.", style: .warning)
    }
    .padding()
}
