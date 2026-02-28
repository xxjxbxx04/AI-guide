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
            GuidesListView()
                .tabItem {
                    Label("Guides", systemImage: "book.fill")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            BookmarksView()
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark.fill")
                }
        }
        .tint(.blue)
        .environment(store)
    }
}

#Preview {
    ContentView()
}
