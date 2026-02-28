//
//  CategoryGuidesView.swift
//  AIGuide
//
//  Shows all guides for a specific category
//

import SwiftUI

struct CategoryGuidesView: View {
    @Environment(GuideStore.self) private var store
    let category: GuideCategory

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Category Header
                VStack(spacing: 8) {
                    Image(systemName: category.icon)
                        .font(.system(size: 36))
                        .foregroundStyle(category.color)

                    Text(category.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)

                // MARK: - Guide List
                ForEach(store.guides(for: category)) { guide in
                    NavigationLink {
                        GuideDetailView(guide: guide)
                    } label: {
                        GuideCard(
                            guide: guide,
                            isBookmarked: store.isBookmarked(guide)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .padding(.bottom, 30)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        CategoryGuidesView(category: .virtualization)
            .environment(GuideStore())
    }
}
