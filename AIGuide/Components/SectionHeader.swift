//
//  SectionHeader.swift
//  AIGuide
//
//  Styled section header with icon and title
//

import SwiftUI

struct SectionHeader: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.bold())
                .foregroundStyle(color)

            Text(title)
                .font(.title3.bold())

            Spacer()
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        SectionHeader(icon: "cpu", title: "Local AI", color: .green)
        SectionHeader(icon: "cloud.fill", title: "Cloud AI", color: .blue)
    }
    .padding()
}
