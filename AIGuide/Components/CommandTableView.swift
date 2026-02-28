//
//  CommandTableView.swift
//  AIGuide
//
//  Table of commands with labels and tap-to-copy
//

import SwiftUI

struct CommandTableView: View {
    let items: [(label: String, command: String)]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                CommandTableRow(label: item.label, command: item.command)

                if index < items.count - 1 {
                    Divider()
                        .padding(.leading, 14)
                }
            }
        }
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Row

private struct CommandTableRow: View {
    let label: String
    let command: String

    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                Text(command)
                    .font(.system(.callout, design: .monospaced))
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)

                Spacer(minLength: 8)

                Button {
                    UIPasteboard.general.string = command
                    withAnimation(.spring(duration: 0.3)) { copied = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { copied = false }
                    }
                } label: {
                    Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                        .font(.caption)
                        .foregroundStyle(copied ? .green : .secondary)
                        .animation(.spring(duration: 0.3), value: copied)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}

#Preview {
    CommandTableView(items: [
        (label: "List models", command: "ollama list"),
        (label: "Pull a model", command: "ollama pull MODEL"),
        (label: "Run a model", command: "ollama run MODEL"),
    ])
    .padding()
}
