//
//  CategoryBadge.swift
//  AIGuide
//
//  Small colored badge showing a guide's category
//

import SwiftUI

struct CategoryBadge: View {
    let category: GuideCategory

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(.caption2)
            Text(category.rawValue)
                .font(.caption2.bold())
        }
        .foregroundStyle(category.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(category.color.opacity(0.12))
        .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        CategoryBadge(category: .localAI)
        CategoryBadge(category: .cloudAI)
        CategoryBadge(category: .virtualization)
        CategoryBadge(category: .networking)
    }
    .padding()
}
