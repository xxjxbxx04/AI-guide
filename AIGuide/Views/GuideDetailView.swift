//
//  GuideDetailView.swift
//  AIGuide
//
//  Full guide view with sections, commands, steps, and tips
//

import SwiftUI

struct GuideDetailView: View {
    @Environment(GuideStore.self) private var store
    let guide: Guide

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                prerequisitesSection
                contentSections
                tipsSection
            }
            .padding()
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(guide.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.toggleBookmark(guide)
                } label: {
                    Image(systemName: store.isBookmarked(guide) ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(store.isBookmarked(guide) ? .blue : .secondary)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            CategoryBadge(category: guide.category)

            Text(guide.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if !guide.videoSearch.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "play.rectangle.fill")
                        .foregroundStyle(.red)
                    Text("Search: \"\(guide.videoSearch)\"")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Prerequisites

    @ViewBuilder
    private var prerequisitesSection: some View {
        if !guide.prerequisites.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeader(icon: "checklist", title: "What You Need", color: .orange)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(guide.prerequisites, id: \.self) { item in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.green)
                                .padding(.top, 2)

                            Text(item)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Content Sections

    private var contentSections: some View {
        ForEach(guide.sections) { section in
            VStack(alignment: .leading, spacing: 12) {
                Text(section.title)
                    .font(.title3.bold())

                ForEach(Array(section.blocks.enumerated()), id: \.element.id) { _, block in
                    ContentBlockView(block: block, accentColor: guide.category.color)
                }
            }
        }
    }

    // MARK: - Tips

    @ViewBuilder
    private var tipsSection: some View {
        if !guide.tips.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeader(icon: "lightbulb.fill", title: "Tips", color: .yellow)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(guide.tips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                                .padding(.top, 3)

                            Text(tip)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

// MARK: - Content Block View

private struct ContentBlockView: View {
    let block: ContentBlock
    let accentColor: Color

    var body: some View {
        switch block.kind {
        case .text(let text):
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)

        case .command(let command):
            CommandBlock(command: command)

        case .commandWithNote(let command, let note):
            CommandBlock(command: command, note: note)

        case .commandTable(let items):
            CommandTableView(items: items)

        case .bullets(let items):
            VStack(alignment: .leading, spacing: 6) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\u{2022}")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(item)
                            .font(.subheadline)
                    }
                }
            }

        case .steps(let items):
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, step in
                    StepRow(
                        number: index + 1,
                        text: step,
                        color: accentColor
                    )
                }
            }

        case .tip(let text):
            TipBanner(text: text, style: .tip)

        case .warning(let text):
            TipBanner(text: text, style: .warning)
        }
    }
}

#Preview {
    NavigationStack {
        GuideDetailView(guide: GuideData.ollamaLocalAI)
            .environment(GuideStore())
    }
}
