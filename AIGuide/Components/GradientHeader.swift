//
//  GradientHeader.swift
//  AIGuide
//
//  Blue gradient hero banner used at the top of main views
//

import SwiftUI

struct GradientHeader: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(.white.opacity(0.9))

            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 59/255, green: 130/255, blue: 246/255),
                    Color(red: 37/255, green: 99/255, blue: 235/255),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    GradientHeader(
        title: "AI & Homelab Guides",
        subtitle: "8 guides across 4 categories",
        icon: "book.fill"
    )
    .padding()
}
