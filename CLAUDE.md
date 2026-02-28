# CLAUDE.md — AI Guide App

## Overview

AI Guide is a SwiftUI iOS app that transforms plain-text homelab/AI guides into a polished, interactive mobile experience with tap-to-copy commands, category-coded navigation, and bookmarks.

## Tech Stack

- SwiftUI (iOS 17+)
- Xcode 15+
- @Observable (iOS 17 Observation framework)
- UserDefaults for bookmark persistence

## Project Structure

```
AIGuide/
├── App/              — App entry point (@main)
├── Models/           — GuideCategory, Guide, GuideSection, ContentBlock
├── Data/             — Static guide content (one file per category)
├── ViewModels/       — GuideStore (@Observable) for bookmarks, search
├── Views/            — All SwiftUI views
│   ├── ContentView        — Root TabView (Guides, Search, Bookmarks)
│   ├── GuidesListView     — Home tab with hero header + category grid
│   ├── CategoryGuidesView — Guides filtered by category
│   ├── GuideDetailView    — Full guide with sections, commands, steps
│   ├── SearchView         — Full-text search across all content
│   └── BookmarksView      — Saved guides
├── Components/       — Reusable UI components
│   ├── GradientHeader     — Blue gradient hero banner
│   ├── CommandBlock       — Tap-to-copy monospace command
│   ├── CommandTableView   — Table of labeled commands
│   ├── GuideCard          — Guide summary card
│   ├── CategoryBadge      — Colored category pill
│   ├── SectionHeader      — Icon + title header
│   ├── StepRow            — Numbered step with circle
│   └── TipBanner          — Tip/warning banner
├── Resources/        — Assets
AIGuideTests/         — Unit tests
```

## Guide Categories

- **Local AI** (green) — Ollama, local LLMs on Windows/WSL
- **Cloud AI** (blue) — Open WebUI + LiteLLM on VPS, Claude Code on phone
- **Virtualization** (orange) — Proxmox homelab, VMs, LXC containers
- **Networking** (purple) — Twingate remote access, Browser-Use WebUI

## 8 Guides

1. Local AI with Ollama (Windows + WSL)
2. VPS Cloud AI Setup (Open WebUI + LiteLLM)
3. Claude Code on Phone via VPS
4. Proxmox Homelab Setup
5. Proxmox Virtual Machines
6. Proxmox Containers (Pi-hole, Nextcloud, Vaultwarden, Jellyfin, Nginx)
7. Twingate Remote Access
8. Browser-Use WebUI

## Coding Conventions

- MVVM-ish: Views contain state, GuideStore handles shared state
- @Observable + @Environment for dependency injection
- `// MARK: -` sections for every logical group
- Private computed properties for view subsections
- #Preview at bottom of every view file
- Light/system design style (educational app pattern)
- Card-based layouts with category color coding
