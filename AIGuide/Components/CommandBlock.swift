//
//  CommandBlock.swift
//  AIGuide
//
//  Tap-to-copy command block with monospace styling
//

import SwiftUI

struct CommandBlock: View {
    let command: String
    let note: String?

    @State private var copied = false

    init(command: String, note: String? = nil) {
        self.command = command
        self.note = note
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let note {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
                    .padding(.bottom, 4)
            }

            HStack(alignment: .top, spacing: 12) {
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
            .padding(.horizontal, 14)
            .padding(.vertical, note == nil ? 12 : 8)
            .padding(.bottom, 2)
        }
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: 16) {
        CommandBlock(command: "ollama pull llama3.1:8b")
        CommandBlock(command: "docker run -d \\\n  -p 8080:8080 \\\n  --name open-webui \\\n  ghcr.io/open-webui/open-webui:main", note: "Run Open WebUI")
    }
    .padding()
}
