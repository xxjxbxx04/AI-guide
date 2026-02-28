//
//  ContentView.swift
//  AIGuide
//
//  Root TabView with three tabs: Guides, Search, Bookmarks
//

import SwiftUI

struct ContentView: View {
    @State private var store = GuideStore()

    var body: some View {
        TabView {
            Tab("Guides", systemImage: "book.fill") {
                GuidesListView()
            }

            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
            }

            Tab("Bookmarks", systemImage: "bookmark.fill") {
                BookmarksView()
            }
        }
        .tint(.blue)
        .environment(store)
    }
}

#Preview {
    ContentView()
}
