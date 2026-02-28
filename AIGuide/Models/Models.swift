//
//  Models.swift
//  AIGuide
//
//  Data models for guides, categories, and content blocks
//

import SwiftUI

// MARK: - Guide Category

enum GuideCategory: String, CaseIterable, Identifiable, Sendable {
    case localAI = "Local AI"
    case cloudAI = "Cloud AI"
    case virtualization = "Virtualization"
    case networking = "Networking"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .localAI: return "cpu"
        case .cloudAI: return "cloud.fill"
        case .virtualization: return "server.rack"
        case .networking: return "network"
        }
    }

    var color: Color {
        switch self {
        case .localAI: return .green
        case .cloudAI: return .blue
        case .virtualization: return .orange
        case .networking: return .purple
        }
    }

    var subtitle: String {
        switch self {
        case .localAI: return "Run AI models on your own hardware"
        case .cloudAI: return "Cloud-hosted AI services and tools"
        case .virtualization: return "Proxmox homelab and virtual machines"
        case .networking: return "Remote access and web automation"
        }
    }
}

// MARK: - Guide

struct Guide: Identifiable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let category: GuideCategory
    let icon: String
    let videoSearch: String
    let prerequisites: [String]
    let sections: [GuideSection]
    let tips: [String]
}

// MARK: - Guide Section

struct GuideSection: Identifiable, Sendable {
    let id: String
    let title: String
    let blocks: [ContentBlock]

    init(title: String, blocks: [ContentBlock]) {
        self.id = title.lowercased().replacingOccurrences(of: " ", with: "-")
        self.title = title
        self.blocks = blocks
    }
}

// MARK: - Content Block

struct ContentBlock: Identifiable, Sendable {
    let id: String
    let kind: Kind

    enum Kind: Sendable {
        case text(String)
        case command(String)
        case commandWithNote(command: String, note: String)
        case commandTable([(label: String, command: String)])
        case bullets([String])
        case steps([String])
        case tip(String)
        case warning(String)
    }

    static func text(_ s: String) -> ContentBlock {
        ContentBlock(id: "txt-\(s.prefix(30).hashValue)", kind: .text(s))
    }

    static func command(_ s: String) -> ContentBlock {
        ContentBlock(id: "cmd-\(s.prefix(30).hashValue)", kind: .command(s))
    }

    static func commandWithNote(command: String, note: String) -> ContentBlock {
        ContentBlock(id: "cmdn-\(command.prefix(30).hashValue)", kind: .commandWithNote(command: command, note: note))
    }

    static func commandTable(_ items: [(label: String, command: String)]) -> ContentBlock {
        ContentBlock(id: "ctbl-\(items.count)-\(items.first?.label.hashValue ?? 0)", kind: .commandTable(items))
    }

    static func bullets(_ items: [String]) -> ContentBlock {
        ContentBlock(id: "bul-\(items.count)-\(items.first?.prefix(20).hashValue ?? 0)", kind: .bullets(items))
    }

    static func steps(_ items: [String]) -> ContentBlock {
        ContentBlock(id: "stp-\(items.count)-\(items.first?.prefix(20).hashValue ?? 0)", kind: .steps(items))
    }

    static func tip(_ s: String) -> ContentBlock {
        ContentBlock(id: "tip-\(s.prefix(30).hashValue)", kind: .tip(s))
    }

    static func warning(_ s: String) -> ContentBlock {
        ContentBlock(id: "wrn-\(s.prefix(30).hashValue)", kind: .warning(s))
    }
}
