//
//  GuideCard.swift
//  AIGuide
//
//  Card showing a guide summary in list views
//

import SwiftUI

struct GuideCard: View {
    let guide: Guide
    let isBookmarked: Bool

    var body: some View {
        HStack(spacing: 14) {
            // MARK: - Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(guide.category.color.opacity(0.12))
                    .frame(width: 48, height: 48)

                Image(systemName: guide.icon)
                    .font(.title3)
                    .foregroundStyle(guide.category.color)
            }

            // MARK: - Text
            VStack(alignment: .leading, spacing: 4) {
                Text(guide.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(guide.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            // MARK: - Trailing
            VStack(spacing: 6) {
                if isBookmarked {
                    Image(systemName: "bookmark.fill")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.5))
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    GuideCard(
        guide: GuideData.ollamaLocalAI,
        isBookmarked: true
    )
    .padding()
}
