# CLAUDE.md — AI Guide App

## Overview

AI Guide is a SwiftUI iOS app that transforms plain-text homelab/AI guides into a polished, interactive mobile experience.

## Tech Stack

- SwiftUI (iOS 17+)
- Xcode 15+
- MVVM architecture

## Project Structure

```
AIGuide/
├── App/              — App entry point (@main)
├── Views/            — SwiftUI views
├── Models/           — Data models
├── ViewModels/       — View models (business logic)
├── Services/         — Networking, data persistence
├── Utils/            — Helper functions
├── Extensions/       — Swift type extensions
├── Resources/        — Assets, colors, images
AIGuideTests/         — Unit tests
```

## Guide Categories

- **Local AI** — Ollama, local LLMs on Windows/WSL
- **Cloud AI** — Open WebUI + LiteLLM on VPS, Claude Code on phone
- **Virtualization** — Proxmox homelab, VMs, LXC containers
- **Networking** — Twingate remote access, Browser-Use WebUI

## Coding Conventions

- Follow MVVM pattern: Views observe ViewModels, ViewModels call Services
- Keep views small — extract reusable components into separate files
- Use Swift naming conventions (camelCase for properties/methods, PascalCase for types)
- Prefer `@Observable` over `ObservableObject` for iOS 17+
- Use NavigationStack (not NavigationView)
- Each guide should follow: Overview > Prerequisites > Steps > Verification > Troubleshooting > Next Steps
