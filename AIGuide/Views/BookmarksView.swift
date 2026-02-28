//
//  BookmarksView.swift
//  AIGuide
//
//  Saved/bookmarked guides for quick access
//

import SwiftUI

struct BookmarksView: View {
    @Environment(GuideStore.self) private var store

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if store.bookmarkedGuides.isEmpty {
                    emptyState
                } else {
                    bookmarksList
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Bookmarks")
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "bookmark.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary.opacity(0.5))

            Text("No Bookmarks")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Tap the bookmark icon on any guide to save it here")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }

    // MARK: - Bookmarks List

    private var bookmarksList: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("\(store.bookmarkedGuides.count) saved guide\(store.bookmarkedGuides.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(store.bookmarkedGuides) { guide in
                    NavigationLink {
                        GuideDetailView(guide: guide)
                    } label: {
                        GuideCard(
                            guide: guide,
                            isBookmarked: true
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    BookmarksView()
        .environment(GuideStore())
}
