//
//  GuideData+LocalAI.swift
//  AIGuide
//
//  Local AI guide content — Ollama on Windows/WSL
//

import Foundation

extension GuideData {

    // MARK: - Local AI with Ollama

    static let ollamaLocalAI = Guide(
        id: "ollama-local-ai",
        title: "Local AI with Ollama",
        subtitle: "Run AI models locally on your computer using Ollama and Open WebUI through WSL on Windows.",
        category: .localAI,
        icon: "desktopcomputer",
        videoSearch: "NetworkChuck host ALL your AI locally",
        prerequisites: [
            "Windows 10/11 PC",
            "A decent GPU (NVIDIA recommended for best performance)",
            "Internet connection (for downloading models)",
        ],
        sections: [
            GuideSection(title: "Install WSL", blocks: [
                .text("WSL lets you run Linux inside Windows. All terminal commands in these guides run inside WSL, NOT in PowerShell or Command Prompt."),
                .text("Open PowerShell as Administrator and run:"),
                .command("wsl --install"),
                .text("This installs WSL 2 with Ubuntu as the default distro. Restart your computer when prompted."),
                .text("After reboot, Ubuntu will open and ask you to create a username and password. These are for Linux only — separate from your Windows login."),
                .tip("Your Windows files are at /mnt/c/Users/YourName/ inside WSL. Copy/paste works with Ctrl+Shift+C and Ctrl+Shift+V."),
            ]),

            GuideSection(title: "Install Ollama", blocks: [
                .text("Inside WSL (Ubuntu terminal):"),
                .command("curl -fsSL https://ollama.com/install.sh | sh"),
                .text("Verify it's installed:"),
                .command("ollama --version"),
                .text("Ollama runs as a service automatically. If it's not running:"),
                .command("ollama serve"),
            ]),

            GuideSection(title: "Pull and Run AI Models", blocks: [
                .text("Download a model:"),
                .command("ollama pull llama3.1:8b"),
                .text("Run it (starts a chat):"),
                .command("ollama run llama3.1:8b"),
                .text("Type your questions, then type /bye to exit."),
                .commandTable([
                    (label: "List all models", command: "ollama list"),
                    (label: "Download a model", command: "ollama pull MODEL"),
                    (label: "Delete a model", command: "ollama rm MODEL"),
                    (label: "Chat with a model", command: "ollama run MODEL"),
                    (label: "Show running models", command: "ollama ps"),
                ]),
                .text("Recommended models for 8GB VRAM + 32GB RAM:"),
                .bullets([
                    "qwen3-coder:30b (19 GB) — Coding, MoE architecture, fast despite size",
                    "llama3.1:8b (4.9 GB) — Fast general purpose",
                    "llava:7b (4.7 GB) — Image understanding",
                    "codegemma:7b (5.0 GB) — Quick code tasks",
                    "mixtral:8x7b (~26 GB) — Complex reasoning, MoE",
                    "llama2:7b (3.8 GB) — Lightweight fallback",
                ]),
                .tip("Models under ~5GB fit fully in 8GB VRAM (fastest). Larger models spill into RAM (slower but works with 32GB)."),
            ]),

            GuideSection(title: "Install Docker", blocks: [
                .text("You need Docker to run Open WebUI."),
                .text("Option A — Docker Desktop for Windows (easiest):"),
                .steps([
                    "Download from docker.com/products/docker-desktop",
                    "Install and enable WSL 2 integration during setup",
                    "Open Docker Desktop > Settings > Resources > WSL Integration",
                    "Enable integration with your Ubuntu distro",
                ]),
                .text("Option B — Docker inside WSL directly:"),
                .command("sudo apt update && sudo apt install docker.io -y && sudo usermod -aG docker $USER"),
                .text("Log out and back in for group changes to take effect."),
            ]),

            GuideSection(title: "Install Open WebUI", blocks: [
                .text("Open WebUI gives you a ChatGPT-like interface for your local Ollama models:"),
                .command("docker run -d \\\n  -p 8080:8080 \\\n  --add-host=host.docker.internal:host-gateway \\\n  --name open-webui \\\n  --restart always \\\n  ghcr.io/open-webui/open-webui:main"),
                .text("Open your browser and go to:"),
                .command("http://localhost:8080"),
                .steps([
                    "Create an admin account (first user becomes admin)",
                    "Open WebUI auto-detects Ollama running locally",
                    "Your models should appear in the model dropdown",
                ]),
                .tip("If models don't appear, go to Settings > Connections and set Ollama URL to http://host.docker.internal:11434"),
            ]),

            GuideSection(title: "Pull Models from Open WebUI", blocks: [
                .text("You can download new models directly from the web interface:"),
                .steps([
                    "Click your profile icon > Admin Panel",
                    "Go to Settings > Models",
                    "In \"Pull a model\" field, type the model name (e.g., llama3.1:8b)",
                    "Click the download button and wait for it to finish",
                ]),
            ]),

            GuideSection(title: "Admin Panel & User Management", blocks: [
                .text("Open WebUI has a full admin panel:"),
                .bullets([
                    "Users: Add accounts for family/friends",
                    "Settings > Models: Control which models each user can access",
                    "Settings > General: Set default model and system prompts",
                ]),
                .text("You can restrict what models certain users see and set usage limits."),
            ]),

            GuideSection(title: "Stable Diffusion (Optional)", blocks: [
                .text("Add image generation to Open WebUI with Automatic1111:"),
                .command("cd ~ && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git stablediff && cd stablediff"),
                .text("Run it (first run downloads models, takes a while):"),
                .command("STABLE_DIFFUSION_REPO=\"https://github.com/w-e-w/stablediffusion.git\" \\\n  python_cmd=/usr/bin/python3 \\\n  ./webui.sh --listen --api"),
                .text("Access at http://localhost:7861"),
                .text("Connect to Open WebUI:"),
                .steps([
                    "In Open WebUI, go to Settings > Images",
                    "Set URL to http://127.0.0.1:7861",
                    "Enable image generation",
                    "Now you can generate images in your chats",
                ]),
            ]),

            GuideSection(title: "Starting Services", blocks: [
                .commandTable([
                    (label: "Ollama (auto-starts, or manually)", command: "ollama serve"),
                    (label: "Open WebUI (check if running)", command: "docker ps"),
                    (label: "Open WebUI (if stopped)", command: "docker start open-webui"),
                    (label: "Stable Diffusion (manual start)", command: "cd ~/stablediff && python_cmd=/usr/bin/python3 ./webui.sh --listen --api"),
                ]),
            ]),

            GuideSection(title: "Access from Other Devices", blocks: [
                .text("Replace \"localhost\" with your computer's local IP:"),
                .command("hostname -I"),
                .bullets([
                    "Open WebUI: http://YOUR-IP:8080",
                    "Stable Diffusion: http://YOUR-IP:7861",
                ]),
                .tip("For access outside your home network, use Twingate. See the Twingate Remote Access guide."),
            ]),
        ],
        tips: [
            "Your computer must be powered on for these services to be available",
            "Larger models are smarter but slower on limited VRAM",
            "Close other GPU-heavy apps when running big models",
            "Monitor GPU usage with: nvidia-smi",
            "Monitor system resources with: htop",
            "All terminal commands run inside WSL, not PowerShell",
        ]
    )
}
