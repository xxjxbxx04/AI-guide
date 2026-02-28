//
//  GuideStore.swift
//  AIGuide
//
//  Observable store managing guides, bookmarks, and search
//

import SwiftUI

@Observable
class GuideStore {

    // MARK: - Properties

    var searchText: String = ""
    var selectedCategory: GuideCategory?
    private(set) var bookmarkedIDs: Set<String>

    let guides: [Guide] = GuideData.allGuides

    // MARK: - Init

    init() {
        let saved = UserDefaults.standard.stringArray(forKey: "bookmarkedGuides") ?? []
        self.bookmarkedIDs = Set(saved)
    }

    // MARK: - Computed

    var categories: [GuideCategory] {
        GuideCategory.allCases
    }

    func guides(for category: GuideCategory) -> [Guide] {
        guides.filter { $0.category == category }
    }

    var bookmarkedGuides: [Guide] {
        guides.filter { bookmarkedIDs.contains($0.id) }
    }

    var searchResults: [Guide] {
        guard !searchText.isEmpty else { return [] }
        let query = searchText.lowercased()
        return guides.filter { guide in
            guide.title.lowercased().contains(query)
            || guide.subtitle.lowercased().contains(query)
            || guide.category.rawValue.lowercased().contains(query)
            || guide.sections.contains { section in
                section.title.lowercased().contains(query)
                || section.blocks.contains { block in
                    blockContains(block, query: query)
                }
            }
        }
    }

    // MARK: - Actions

    func toggleBookmark(_ guide: Guide) {
        if bookmarkedIDs.contains(guide.id) {
            bookmarkedIDs.remove(guide.id)
        } else {
            bookmarkedIDs.insert(guide.id)
        }
        saveBookmarks()
    }

    func isBookmarked(_ guide: Guide) -> Bool {
        bookmarkedIDs.contains(guide.id)
    }

    // MARK: - Private

    private func saveBookmarks() {
        UserDefaults.standard.set(Array(bookmarkedIDs), forKey: "bookmarkedGuides")
    }

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
