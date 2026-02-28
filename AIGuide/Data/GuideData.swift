//
//  GuideData.swift
//  AIGuide
//
//  Central registry for all guide data
//

import Foundation

enum GuideData {

    static let allGuides: [Guide] = [
        // Local AI
        GuideData.ollamaLocalAI,
        // Cloud AI
        GuideData.vpsCloudAI,
        GuideData.claudeCodePhone,
        // Virtualization
        GuideData.proxmoxHomelab,
        GuideData.proxmoxVMs,
        GuideData.proxmoxContainers,
        // Networking
        GuideData.twingateRemoteAccess,
        GuideData.browserUseWebUI,
    ]
}
