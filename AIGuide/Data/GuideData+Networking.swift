//
//  GuideData+Networking.swift
//  AIGuide
//
//  Networking guide content — Twingate and Browser-Use
//

import Foundation

extension GuideData {

    // MARK: - Twingate Remote Access

    static let twingateRemoteAccess = Guide(
        id: "twingate-remote-access",
        title: "Twingate Remote Access",
        subtitle: "Access your homelab services from anywhere in the world using Twingate — a zero-trust VPN alternative.",
        category: .networking,
        icon: "lock.shield",
        videoSearch: "NetworkChuck Twingate",
        prerequisites: [
            "A running Proxmox server or always-on machine on your home network",
            "Services you want to access remotely (Pi-hole, Nextcloud, etc.)",
        ],
        sections: [
            GuideSection(title: "What Is Twingate?", blocks: [
                .text("Twingate is a free remote access tool that lets you securely connect to your home network from anywhere."),
                .text("Unlike a traditional VPN:"),
                .bullets([
                    "No port forwarding required",
                    "No firewall changes needed",
                    "Zero-trust security model",
                    "Easy setup (5 minutes)",
                    "Free tier available (up to 5 users)",
                ]),
                .text("How it works:"),
                .steps([
                    "A \"connector\" runs on your home network",
                    "You install the Twingate client on your devices",
                    "When you connect, Twingate tunnels you into your home network as if you were physically there",
                    "You use the same local IP addresses as at home",
                ]),
                .warning("The computer/server hosting the Twingate connector MUST be powered on for this to work."),
            ]),

            GuideSection(title: "Create a Twingate Account", blocks: [
                .steps([
                    "Go to twingate.com",
                    "Click \"Get Started Free\"",
                    "Sign up with your email",
                    "Choose a network name (e.g., \"myhomelab\")",
                ]),
                .text("This creates your Twingate network: myhomelab.twingate.com"),
            ]),

            GuideSection(title: "Set Up a Connector", blocks: [
                .text("The connector sits on your home network and allows Twingate to reach your services. Best to run it on your Proxmox server since it's always on."),
                .text("Create a new LXC container in Proxmox: RAM 512MB, Disk 8GB, 1 core, static IP."),
                .command("apt update && apt upgrade -y\napt install docker.io -y"),
                .text("In Twingate admin console:"),
                .steps([
                    "Go to Network > Connectors",
                    "Click \"Deploy Connector\"",
                    "Select \"Docker\" as the deployment method",
                    "Copy the docker run command",
                ]),
                .text("The command will look like:"),
                .command("docker run -d \\\n  --name twingate-connector \\\n  --restart always \\\n  -e TWINGATE_NETWORK=\"myhomelab\" \\\n  -e TWINGATE_ACCESS_TOKEN=\"your-token\" \\\n  -e TWINGATE_REFRESH_TOKEN=\"your-refresh-token\" \\\n  twingate/connector:1"),
                .text("The connector should show as \"Connected\" in the admin console."),
            ]),

            GuideSection(title: "Add Resources", blocks: [
                .text("Resources are the services you want to access remotely. In Twingate admin console:"),
                .steps([
                    "Go to Network > Resources",
                    "Click \"Add Resource\"",
                    "Add the local IP and port for each service",
                    "Assign each resource to a group (e.g., \"Everyone\")",
                ]),
                .text("Example resources:"),
                .bullets([
                    "Proxmox Web UI — 192.168.5.132:8006",
                    "Pi-hole — 192.168.5.10",
                    "Nextcloud — 192.168.5.135:8080",
                    "VaultWarden — 192.168.5.12",
                    "Jellyfin — 192.168.5.11:8096",
                    "Nginx Proxy Manager — 192.168.5.13:81",
                    "Open WebUI (laptop) — 192.168.5.107:8080",
                ]),
                .tip("You can add a CIDR range (e.g., 192.168.5.0/24) to cover your entire network instead of adding each service individually."),
            ]),

            GuideSection(title: "Install Twingate Client", blocks: [
                .text("Install on every device you want to use for remote access:"),
                .bullets([
                    "Windows: Download from twingate.com/download",
                    "Mac: Download from the Mac App Store or twingate.com",
                    "iPhone/iPad: Download \"Twingate\" from the App Store",
                    "Android: Download \"Twingate\" from the Google Play Store",
                    "Linux: Follow instructions at twingate.com/download",
                ]),
                .text("Sign in with your Twingate account and enter your network name."),
            ]),

            GuideSection(title: "Connect and Use", blocks: [
                .steps([
                    "Open the Twingate app on your device",
                    "Make sure it says \"Connected\"",
                    "Open a browser and use the same URLs as at home",
                ]),
                .text("From your phone, anywhere in the world:"),
                .bullets([
                    "Proxmox: https://192.168.5.132:8006",
                    "Pi-hole: http://192.168.5.10/admin",
                    "Nextcloud: http://192.168.5.135:8080",
                    "Jellyfin: http://192.168.5.11:8096",
                    "Open WebUI: http://192.168.5.107:8080",
                ]),
                .tip("VPS services don't need Twingate since they're already on the public internet."),
            ]),

            GuideSection(title: "Troubleshooting", blocks: [
                .text("Can't connect to a service:"),
                .bullets([
                    "Check Twingate client shows \"Connected\"",
                    "Verify the Proxmox server / laptop is powered on",
                    "Check the connector shows online in Twingate admin",
                    "Make sure the resource IP and port are correct",
                    "Try refreshing Twingate client (disconnect/reconnect)",
                ]),
                .text("Connector shows offline:"),
                .commandTable([
                    (label: "Check if running", command: "docker ps"),
                    (label: "Restart connector", command: "docker restart twingate-connector"),
                ]),
            ]),
        ],
        tips: [
            "The Proxmox server MUST be powered on for Twingate to reach homelab services",
            "Your laptop MUST be powered on for laptop-hosted services (Ollama, Open WebUI)",
            "The VPS is always on, so those services are always reachable without Twingate",
            "Twingate is free for up to 5 users",
            "No port forwarding or firewall changes needed",
            "Works on any internet connection (hotel, coffee shop, mobile data)",
        ]
    )

    // MARK: - Browser-Use WebUI

    static let browserUseWebUI = Guide(
        id: "browser-use-webui",
        title: "Browser-Use WebUI",
        subtitle: "Set up an AI agent that can browse the web and complete tasks for you — a free ChatGPT Operator alternative.",
        category: .networking,
        icon: "globe",
        videoSearch: "NetworkChuck browser use operator alternative",
        prerequisites: [
            "A computer running Windows (WSL), Mac, or Linux",
            "Python 3.11",
            "An API key for an AI provider (OpenAI GPT-4o recommended)",
        ],
        sections: [
            GuideSection(title: "What Is Browser-Use?", blocks: [
                .text("Browser-Use is an AI agent that controls a real web browser. You give it a task in plain English and it opens a browser, navigates websites, clicks buttons, fills forms, and completes the task autonomously."),
                .text("Examples:"),
                .bullets([
                    "\"Go to amazon.com and search for wireless earbuds under $50\"",
                    "\"Go to google flights and find cheap flights to London\"",
                    "\"Go to reddit and summarize the top posts in r/technology\"",
                ]),
                .text("It's like ChatGPT's Operator feature, but free and self-hosted."),
            ]),

            GuideSection(title: "Install Python 3.11", blocks: [
                .text("All commands run inside WSL on Windows."),
                .text("Check if you have Python 3.11:"),
                .command("python3.11 --version"),
                .text("If not installed, use pyenv:"),
                .command("curl https://pyenv.run | bash"),
                .text("Add to your shell:"),
                .command("echo 'export PYENV_ROOT=\"$HOME/.pyenv\"' >> ~/.bashrc\necho 'export PATH=\"$PYENV_ROOT/bin:$PATH\"' >> ~/.bashrc\necho 'eval \"$(pyenv init -)\"' >> ~/.bashrc\nsource ~/.bashrc"),
                .text("Install Python 3.11:"),
                .command("pyenv install 3.11\npyenv global 3.11"),
            ]),

            GuideSection(title: "Clone and Set Up", blocks: [
                .command("cd ~\ngit clone https://github.com/browser-use/web-ui.git\ncd web-ui"),
                .text("Create a virtual environment:"),
                .command("python3.11 -m venv .venv\nsource .venv/bin/activate"),
                .text("Install dependencies:"),
                .command("pip install -r requirements.txt"),
            ]),

            GuideSection(title: "Install Browser", blocks: [
                .command("playwright install --with-deps"),
                .text("If that fails, try just Chromium:"),
                .command("playwright install chromium --with-deps"),
                .text("If you get errors about missing libraries:"),
                .command("sudo apt install -y libnss3 libnspr4 libatk1.0-0 \\\n  libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 \\\n  libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \\\n  libgbm1 libpango-1.0-0 libcairo2 libasound2"),
            ]),

            GuideSection(title: "Configure API Keys", blocks: [
                .command("cp .env.example .env\nnano .env"),
                .text("Add your API key (you only need one provider):"),
                .bullets([
                    "OpenAI (recommended): OPENAI_API_KEY=sk-your-key",
                    "Anthropic: ANTHROPIC_API_KEY=sk-ant-your-key",
                    "Google Gemini: GOOGLE_API_KEY=your-key",
                ]),
            ]),

            GuideSection(title: "Run the Web UI", blocks: [
                .command("python webui.py --ip 127.0.0.1 --port 7788"),
                .text("Open your browser and go to:"),
                .command("http://127.0.0.1:7788"),
                .steps([
                    "Select your LLM provider (e.g., OpenAI)",
                    "Select a model — GPT-4o recommended",
                    "Type your task in the prompt box",
                    "Click Run — watch the AI control the browser",
                ]),
                .tip("Be specific about each step in your prompts. Include \"Press Page Down 3 times\" between steps for pages with lots of content."),
            ]),

            GuideSection(title: "Which Models Work?", blocks: [
                .text("Works well:"),
                .bullets([
                    "OpenAI GPT-4o (best choice)",
                    "OpenAI GPT-4o-mini (cheaper, still decent)",
                    "Anthropic Claude (with current model IDs)",
                ]),
                .text("Does NOT work well:"),
                .bullets([
                    "Local Ollama models (deepseek-r1, llama, etc.) — don't support tool/function calling",
                    "Outdated model IDs",
                ]),
                .warning("Stick with cloud API models for browser-use tasks. Local models lack the tool calling support that browser-use requires."),
            ]),

            GuideSection(title: "Docker Alternative", blocks: [
                .command("cd ~/web-ui\ncp .env.example .env\n# Edit .env with your API keys\ndocker compose up --build"),
                .text("Access:"),
                .bullets([
                    "Web UI: http://localhost:7788",
                    "VNC viewer: http://localhost:6080/vnc.html",
                    "Default VNC password: \"youvncpassword\" (change in .env)",
                ]),
            ]),

            GuideSection(title: "Custom Browser (Keep Your Logins)", blocks: [
                .text("Use your own Chrome browser so the AI has access to your logged-in sessions:"),
                .steps([
                    "Close ALL Chrome windows first",
                    "Open the Browser-Use WebUI in Firefox or Edge",
                    "In .env, set BROWSER_PATH and BROWSER_USER_DATA",
                    "In the WebUI, enable \"Use Own Browser\" in settings",
                ]),
            ]),

            GuideSection(title: "How to Start Browser-Use", blocks: [
                .text("Every time you want to use it:"),
                .command("cd ~/web-ui\nsource .venv/bin/activate\npython webui.py --ip 127.0.0.1 --port 7788"),
                .text("Then open http://127.0.0.1:7788"),
            ]),

            GuideSection(title: "Troubleshooting", blocks: [
                .bullets([
                    "\"3 consecutive failures\" with no history: Browser can't launch. Run: playwright install --with-deps",
                    "\"3 consecutive failures\" with model errors: Wrong model ID or API key not set. Check .env file.",
                    "Browser opens but agent does nothing: Model doesn't support tool calling. Switch to GPT-4o.",
                    "Can't scroll: Add \"Press Page Down 3 times\" in your prompts between each step.",
                ]),
            ]),
        ],
        tips: [
            "GPT-4o is the best model for browser-use tasks",
            "Be specific in your prompts — break complex tasks into steps",
            "Add scroll instructions (Page Down) for pages with lots of content",
            "Use your own Chrome profile to leverage existing logins",
            "Close other Chrome windows before using custom browser mode",
        ]
    )
}
