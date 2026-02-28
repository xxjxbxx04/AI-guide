//
//  GuideData+CloudAI.swift
//  AIGuide
//
//  Cloud AI guide content — VPS setup and Claude Code on phone
//

import Foundation

extension GuideData {

    // MARK: - VPS Cloud AI Setup

    static let vpsCloudAI = Guide(
        id: "vps-cloud-ai",
        title: "VPS Cloud AI Setup",
        subtitle: "Set up Open WebUI and LiteLLM on a VPS to access all major AI models from one interface — accessible from anywhere.",
        category: .cloudAI,
        icon: "cloud.fill",
        videoSearch: "NetworkChuck Open WebUI LiteLLM",
        prerequisites: [
            "A VPS — Hostinger recommended (~$6/month for KVM2, 8GB RAM)",
            "API keys from your chosen providers (Anthropic, OpenAI, Google, xAI)",
        ],
        sections: [
            GuideSection(title: "What This Does", blocks: [
                .text("Instead of paying for separate subscriptions to ChatGPT, Claude, Gemini, etc., you host your own AI chat interface and pay only for what you use via API keys."),
                .bullets([
                    "Open WebUI = the chat interface (like ChatGPT's website)",
                    "LiteLLM = a proxy that connects to all AI providers through one unified API",
                ]),
                .text("You get access to ALL the newest models from every provider, controlled from one place."),
            ]),

            GuideSection(title: "Set Up Your VPS", blocks: [
                .steps([
                    "Go to hostinger.com and get a VPS",
                    "Choose KVM2 plan or higher (8GB RAM recommended)",
                    "Select Ubuntu as the OS",
                    "Set a root password",
                    "Note your server's IP address",
                ]),
                .text("Connect via SSH:"),
                .command("ssh root@YOUR-VPS-IP"),
                .text("Update the server:"),
                .command("apt update && apt upgrade -y"),
            ]),

            GuideSection(title: "Install Docker", blocks: [
                .command("apt install docker.io docker-compose -y"),
                .text("Verify:"),
                .command("docker --version"),
            ]),

            GuideSection(title: "Install Open WebUI", blocks: [
                .tip("If you selected the \"Llama\" template during VPS creation on Hostinger, Open WebUI is already installed. Skip to the next step."),
                .text("Manual install:"),
                .command("docker run -d \\\n  -p 8080:8080 \\\n  --name open-webui \\\n  --restart always \\\n  ghcr.io/open-webui/open-webui:main"),
                .text("Access at http://YOUR-VPS-IP:8080"),
                .steps([
                    "Create an admin account (first user becomes admin)",
                    "This is your main chat interface",
                ]),
            ]),

            GuideSection(title: "Install LiteLLM", blocks: [
                .text("LiteLLM is a proxy that lets you connect to all AI providers through one API."),
                .command("git clone https://github.com/BerriAI/litellm.git && cd litellm"),
                .text("Create the environment file:"),
                .command("nano .env"),
                .text("Add these lines:"),
                .command("LITELLM_MASTER_KEY=\"sk-your-master-key-here\"\nLITELLM_SALT_KEY=\"sk-your-salt-key-here\""),
                .tip("Generate random strings for these keys — they're YOUR keys for the LiteLLM admin panel, not API provider keys."),
                .text("Start LiteLLM:"),
                .command("docker-compose up -d"),
                .text("Access admin panel at http://YOUR-VPS-IP:4000"),
                .text("Login with username \"admin\" and your LITELLM_MASTER_KEY as password."),
            ]),

            GuideSection(title: "Add AI Models to LiteLLM", blocks: [
                .text("In the LiteLLM admin panel, go to Models > Add Model. Add each provider:"),
                .bullets([
                    "Anthropic (Claude): model = anthropic/claude-sonnet-4-6",
                    "OpenAI (GPT): model = openai/gpt-4o",
                    "Google (Gemini): model = gemini/gemini-2.5-flash",
                    "xAI (Grok): model = xai/grok-4-1-fast-reasoning",
                ]),
                .text("Or edit the config file directly:"),
                .command("nano /path/to/litellm/config.yaml"),
                .text("Example config:"),
                .command("model_list:\n  - model_name: claude-sonnet\n    litellm_params:\n      model: anthropic/claude-sonnet-4-6\n      api_key: sk-ant-xxxxx\n  - model_name: gpt-4o\n    litellm_params:\n      model: openai/gpt-4o\n      api_key: sk-xxxxx"),
            ]),

            GuideSection(title: "Create Virtual API Keys", blocks: [
                .text("Virtual keys let you control who can access which models and set budget limits."),
                .steps([
                    "Go to \"Virtual Keys\" in LiteLLM admin panel",
                    "Click \"Create Key\"",
                    "Set a name (e.g., \"personal\", \"family\")",
                    "Select which models this key can access",
                    "Set a monthly budget limit (optional)",
                    "Copy the generated key — you'll need it next",
                ]),
            ]),

            GuideSection(title: "Connect Open WebUI to LiteLLM", blocks: [
                .text("Now connect Open WebUI to LiteLLM so all your models appear in the chat interface."),
                .steps([
                    "In Open WebUI, click your profile > Admin Panel",
                    "Go to Settings > Connections",
                    "Add a new OpenAI-compatible connection",
                    "Set URL to http://localhost:4000",
                    "Set API Key to your LiteLLM virtual key",
                    "Click Save",
                ]),
                .warning("Use http://localhost:4000 (NOT your public IP) because both services are on the same server."),
            ]),

            GuideSection(title: "Connect Local Open WebUI to VPS", blocks: [
                .text("You can also connect your LOCAL Open WebUI (on your laptop) to the LiteLLM running on your VPS:"),
                .steps([
                    "In your LOCAL Open WebUI (http://localhost:8080), go to Settings > Connections",
                    "Add a new OpenAI-compatible connection",
                    "Set URL to http://YOUR-VPS-IP:4000",
                    "Set API Key to your LiteLLM virtual key",
                    "Save",
                ]),
                .text("Now your local Open WebUI has both local Ollama models AND cloud models via LiteLLM."),
                .warning("Use the VPS IP address, NOT localhost. localhost won't work since LiteLLM is on the VPS."),
            ]),

            GuideSection(title: "User Management", blocks: [
                .bullets([
                    "Admin Panel > Users: Create accounts for family/friends",
                    "Assign user roles (admin, user)",
                    "Control which models each user can access",
                    "Set system prompts for safety guardrails",
                    "LiteLLM supports per-key budget limits to prevent overspending",
                ]),
            ]),
        ],
        tips: [
            "The VPS is always on — services are available 24/7",
            "You only pay for API usage (per token), not subscriptions",
            "Monitor your spending in each provider's dashboard",
            "LiteLLM can set budget limits per key to prevent surprises",
            "Update Open WebUI: docker pull ghcr.io/open-webui/open-webui:main then restart the container",
        ]
    )

    // MARK: - Claude Code on Phone

    static let claudeCodePhone = Guide(
        id: "claude-code-phone",
        title: "Claude Code on Phone",
        subtitle: "Use Claude Code from your phone anywhere in the world using a VPS, SSH, and tmux.",
        category: .cloudAI,
        icon: "iphone",
        videoSearch: "NetworkChuck Claude Code phone",
        prerequisites: [
            "A VPS (Virtual Private Server) — Hostinger recommended (~$5-6/month, 4GB RAM minimum)",
            "A phone with an SSH app (Termius recommended — free on iOS/Android)",
            "An Anthropic API key from console.anthropic.com",
        ],
        sections: [
            GuideSection(title: "Rent a VPS", blocks: [
                .steps([
                    "Go to hostinger.com and sign up",
                    "Choose a VPS plan (KVM2 or higher — 4GB RAM minimum, 8GB+ ideal)",
                    "Select your server location (pick one close to you)",
                    "Choose Ubuntu as the OS",
                    "Set a root password and/or add your SSH key",
                    "Note your server's IP address once it's created",
                ]),
            ]),

            GuideSection(title: "Connect & Install Claude Code", blocks: [
                .text("Connect to your VPS:"),
                .command("ssh root@YOUR-VPS-IP"),
                .text("Install Claude Code:"),
                .command("apt update && apt install -y nodejs npm\nnpm install -g @anthropic-ai/claude-code"),
                .text("Set your API key:"),
                .command("export ANTHROPIC_API_KEY=your-key-here"),
                .text("Make it permanent (survives reboots):"),
                .command("echo 'export ANTHROPIC_API_KEY=your-key-here' >> ~/.bashrc"),
                .text("Test it:"),
                .command("claude"),
            ]),

            GuideSection(title: "Security Hardening", blocks: [
                .warning("These steps are important to protect your VPS from attackers."),
                .text("Disable password login (use SSH keys only):"),
                .command("sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' \\\n  /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf && \\\n  sudo systemctl restart ssh"),
                .text("Install fail2ban (blocks brute force attacks):"),
                .command("sudo apt install fail2ban -y"),
                .text("Enable firewall (only allow SSH):"),
                .command("sudo ufw allow 22 && sudo ufw enable"),
            ]),

            GuideSection(title: "Install tmux", blocks: [
                .text("tmux lets you start Claude Code and disconnect from SSH without losing your session. When your phone sleeps or you lose connection, Claude keeps running."),
                .command("sudo apt install tmux -y"),
                .text("Enable mouse scrolling (important for mobile):"),
                .command("echo \"set -g mouse on\" >> ~/.tmux.conf"),
                .text("Start a new tmux session:"),
                .command("tmux new -s claude"),
                .text("Now run Claude inside the tmux session:"),
                .command("claude"),
            ]),

            GuideSection(title: "Set Up Your Phone", blocks: [
                .steps([
                    "Download Termius from the App Store or Google Play (free)",
                    "Open Termius and tap \"New Host\"",
                    "Enter your VPS IP address",
                    "Set username to \"root\"",
                    "Add your SSH key or password",
                    "Connect",
                ]),
            ]),

            GuideSection(title: "Reconnect from Phone", blocks: [
                .text("After connecting via SSH on your phone, reattach to your tmux session:"),
                .command("tmux attach -t claude"),
                .text("Claude will be right where you left it."),
            ]),

            GuideSection(title: "tmux Quick Reference", blocks: [
                .commandTable([
                    (label: "Create new session", command: "tmux new -s claude"),
                    (label: "Reconnect to session", command: "tmux attach -t claude"),
                    (label: "List all sessions", command: "tmux ls"),
                    (label: "Detach (Claude keeps running)", command: "Ctrl+B, then D"),
                    (label: "Scroll mode (q to exit)", command: "Ctrl+B, then ["),
                ]),
            ]),

            GuideSection(title: "OAuth Troubleshooting", blocks: [
                .text("If Claude Code asks you to log in via browser on your headless VPS, use SSH port forwarding from your local machine:"),
                .command("ssh -L 15735:localhost:15735 root@YOUR-VPS-IP"),
                .text("Open the auth URL on your local browser. After that, use the API key method instead:"),
                .command("export ANTHROPIC_API_KEY=your-key-here\nclaude"),
            ]),
        ],
        tips: [
            "Always use tmux before starting Claude so you don't lose your session",
            "Monitor memory with: htop",
            "Restart Claude periodically if it gets slow",
            "Your VPS must be running for this to work (it's always on since it's in the cloud)",
        ]
    )
}
