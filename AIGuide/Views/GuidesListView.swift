//
//  GuidesListView.swift
//  AIGuide
//
//  Main guides tab — browse all guides by category
//

import SwiftUI

struct GuidesListView: View {
    @Environment(GuideStore.self) private var store

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroHeader
                    categoryGrid
                    allGuidesSection
                }
                .padding()
                .padding(.bottom, 30)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Guides")
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        GradientHeader(
            title: "AI & Homelab Guides",
            subtitle: "\(store.guides.count) guides across \(store.categories.count) categories",
            icon: "book.fill"
        )
    }

    // MARK: - Category Grid

    private var categoryGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
        ], spacing: 12) {
            ForEach(store.categories) { category in
                NavigationLink {
                    CategoryGuidesView(category: category)
                } label: {
                    CategoryCard(
                        category: category,
                        guideCount: store.guides(for: category).count
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - All Guides

    private var allGuidesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(icon: "list.bullet", title: "All Guides", color: .blue)

            ForEach(store.guides) { guide in
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
    }
}

// MARK: - Category Card

private struct CategoryCard: View {
    let category: GuideCategory
    let guideCount: Int

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundStyle(category.color)

            Text(category.rawValue)
                .font(.headline)
                .foregroundStyle(.primary)

            Text("\(guideCount) guide\(guideCount == 1 ? "" : "s")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    GuidesListView()
        .environment(GuideStore())
}
