//
//  SearchView.swift
//  AIGuide
//
//  Full-text search across all guides, sections, and commands
//

import SwiftUI

struct SearchView: View {
    @Environment(GuideStore.self) private var store
    @State private var searchText = ""

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    emptyState
                } else if filteredGuides.isEmpty {
                    noResultsState
                } else {
                    resultsList
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search guides, commands, topics...")
        }
    }

    // MARK: - Computed

    private var filteredGuides: [Guide] {
        guard !searchText.isEmpty else { return [] }
        let query = searchText.lowercased()
        return store.guides.filter { guide in
            guide.title.lowercased().contains(query)
            || guide.subtitle.lowercased().contains(query)
            || guide.category.rawValue.lowercased().contains(query)
            || guide.prerequisites.contains { $0.lowercased().contains(query) }
            || guide.tips.contains { $0.lowercased().contains(query) }
            || guide.sections.contains { section in
                section.title.lowercased().contains(query)
                || section.blocks.contains { blockContains($0, query: query) }
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary.opacity(0.5))

            Text("Search Guides")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Find guides, commands, and setup steps")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }

    // MARK: - No Results

    private var noResultsState: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary.opacity(0.5))

            Text("No Results")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Try a different search term")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }

    // MARK: - Results

    private var resultsList: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("\(filteredGuides.count) result\(filteredGuides.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(filteredGuides) { guide in
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
    }

    // MARK: - Helpers

    private func blockContains(_ block: ContentBlock, query: String) -> Bool {
        switch block.kind {
        case .text(let s), .command(let s), .tip(let s), .warning(let s):
            return s.lowercased().contains(query)
        case .commandWithNote(let cmd, let note):
            return cmd.lowercased().contains(query) || note.lowercased().contains(query)
        case .commandTable(let items):
            return items.contains { $0.label.lowercased().contains(query) || $0.command.lowercased().contains(query) }
        case .bullets(let items), .steps(let items):
            return items.contains { $0.lowercased().contains(query) }
        }
    }
}

#Preview {
    SearchView()
        .environment(GuideStore())
}
