//
//  GuideData+Virtualization.swift
//  AIGuide
//
//  Virtualization guide content — Proxmox homelab, VMs, containers
//

import Foundation

extension GuideData {

    // MARK: - Proxmox Homelab Setup

    static let proxmoxHomelab = Guide(
        id: "proxmox-homelab",
        title: "Proxmox Homelab Setup",
        subtitle: "Turn a spare PC into a home server using Proxmox VE. Reference build: Dell Optiplex 3040.",
        category: .virtualization,
        icon: "server.rack",
        videoSearch: "NetworkChuck Proxmox homelab",
        prerequisites: [
            "A spare PC (minimum 4GB RAM, 64-bit CPU, 32GB storage)",
            "A USB drive (8GB+) for the installer",
            "A monitor and keyboard (only needed during install)",
            "An ethernet cable (connect to your router)",
        ],
        sections: [
            GuideSection(title: "Download Proxmox", blocks: [
                .steps([
                    "Go to proxmox.com/en/downloads",
                    "Download \"Proxmox VE ISO Installer\" (latest version)",
                    "Download Balena Etcher from etcher.balena.io",
                ]),
            ]),

            GuideSection(title: "Create Bootable USB", blocks: [
                .steps([
                    "Open Balena Etcher",
                    "Click \"Flash from file\" and select the Proxmox ISO",
                    "Select your USB drive",
                    "Click \"Flash\" and wait for it to finish",
                ]),
            ]),

            GuideSection(title: "Install Proxmox", blocks: [
                .steps([
                    "Plug the USB into your spare PC",
                    "Connect ethernet cable to your router",
                    "Connect monitor and keyboard",
                    "Power on and enter BIOS (usually F2, F12, or DEL during boot)",
                    "Set boot order to USB first, save and reboot",
                    "Accept the license agreement",
                    "Select the hard drive to install on",
                    "Set your country, timezone, and keyboard layout",
                    "Set a root password (remember this!)",
                    "Set the management network: pick your ethernet interface, set a static IP (e.g., 192.168.5.132), set gateway to your router's IP",
                    "Review and click Install",
                    "Wait for installation to finish, then remove USB and reboot",
                ]),
            ]),

            GuideSection(title: "Access Proxmox Web UI", blocks: [
                .text("After reboot, the screen will show the IP address. From any computer on your network, open a browser and go to:"),
                .command("https://YOUR-PROXMOX-IP:8006"),
                .text("Login with username \"root\" and the password you set during install. Realm: Linux PAM standard authentication."),
                .tip("Your browser will warn about the SSL certificate. This is normal — click \"Advanced\" then \"Continue\" to proceed."),
            ]),

            GuideSection(title: "Initial Configuration", blocks: [
                .steps([
                    "Remove the subscription nag (optional): Click OK to dismiss the \"No valid subscription\" popup. Proxmox works fully without a subscription.",
                    "Update Proxmox: Click your node > Updates > Repositories. Disable the \"enterprise\" repository. Add the \"No-Subscription\" repository. Go to Updates, click Refresh then Upgrade.",
                    "Upload ISOs: Click your node > local storage > ISO Images > Upload. Select ISO files for any VMs you want to create later.",
                ]),
            ]),

            GuideSection(title: "Containers vs Virtual Machines", blocks: [
                .text("Containers (LXC):"),
                .bullets([
                    "Lightweight, fast, use less resources",
                    "Share the host's Linux kernel",
                    "Best for: Linux services (Pi-hole, Nextcloud, VaultWarden, Jellyfin)",
                    "Start in seconds — use this for most things",
                ]),
                .text("Virtual Machines (VMs):"),
                .bullets([
                    "Full operating system with its own kernel",
                    "More resource-heavy, takes longer to start",
                    "Best for: Windows, non-Linux OS, or when you need full hardware isolation",
                ]),
                .tip("Rule of thumb: If it's a Linux service, use a container. If it needs a full OS (like Windows), use a VM."),
            ]),
        ],
        tips: [
            "The Proxmox server needs to stay powered on for services to be available",
            "Bookmark the web UI URL for quick access",
            "You can manage everything from the web UI — no monitor needed on the server after initial setup",
            "If you forget the IP, check your router's admin page for connected devices",
        ]
    )

    // MARK: - Proxmox Virtual Machines

    static let proxmoxVMs = Guide(
        id: "proxmox-vms",
        title: "Proxmox Virtual Machines",
        subtitle: "Create and configure Virtual Machines (VMs) in Proxmox for running full operating systems.",
        category: .virtualization,
        icon: "rectangle.on.rectangle",
        videoSearch: "NetworkChuck Proxmox virtual machine",
        prerequisites: [
            "A running Proxmox server (see Proxmox Homelab Setup guide)",
            "An ISO file for the OS you want to install",
        ],
        sections: [
            GuideSection(title: "When to Use a VM", blocks: [
                .text("Use a VM when:"),
                .bullets([
                    "You need Windows or a non-Linux OS",
                    "The software requires its own kernel",
                    "You need full hardware isolation",
                    "You're running a desktop environment with a GUI",
                    "Security requires complete separation from the host",
                ]),
            ]),

            GuideSection(title: "Upload an ISO", blocks: [
                .text("Download an ISO to your computer:"),
                .bullets([
                    "Ubuntu Server: ubuntu.com/download/server",
                    "Ubuntu Desktop: ubuntu.com/download/desktop",
                    "Windows 10/11: microsoft.com/software-download",
                    "Debian: debian.org/download",
                ]),
                .text("In Proxmox Web UI:"),
                .steps([
                    "Click your node name (left sidebar)",
                    "Click \"local\" storage",
                    "Click \"ISO Images\"",
                    "Click \"Upload\" and select the ISO file",
                    "Wait for upload to complete",
                ]),
                .tip("You can also click \"Download from URL\" and paste a direct download link instead of uploading."),
            ]),

            GuideSection(title: "Create a Virtual Machine", blocks: [
                .steps([
                    "Click \"Create VM\" button (top right)",
                    "General: Set a VM ID and name (e.g., \"ubuntu-server\")",
                    "OS: Select the ISO you uploaded. Set OS type (Linux or Microsoft Windows)",
                    "System: For Linux, leave defaults. For Windows: Machine = q35, BIOS = OVMF (UEFI), add EFI disk, check \"Add TPM\" for Win 11",
                    "Disks: Set size (32GB min for Linux server, 64GB+ for desktop/Windows). Storage = local-lvm. Bus = VirtIO Block",
                    "CPU: Set cores (2 minimum). Type = \"host\" for best performance",
                    "Memory: Linux server = 2GB, Linux desktop = 4GB, Windows = 4-8GB",
                    "Network: Bridge = vmbr0, Model = VirtIO (fastest)",
                    "Confirm and click Finish",
                ]),
            ]),

            GuideSection(title: "Install the Operating System", blocks: [
                .steps([
                    "Select your VM in the left sidebar",
                    "Click \"Start\", then click \"Console\" to see the screen",
                    "The OS installer will boot from the ISO",
                    "Follow the on-screen installation process",
                ]),
                .text("For Ubuntu Server: Select language, configure network, set up disk, create user, install OpenSSH server."),
                .text("For Windows: Follow the standard installer. You may need VirtIO drivers — download the virtio-win ISO and add as a second CD drive."),
            ]),

            GuideSection(title: "Post-Install Configuration", blocks: [
                .text("1. Remove the ISO:"),
                .text("Select VM > Hardware > CD/DVD Drive > Edit > Do not use any media."),
                .text("2. Install guest agent (improves performance):"),
                .command("sudo apt update && sudo apt install qemu-guest-agent -y\nsudo systemctl enable qemu-guest-agent\nsudo systemctl start qemu-guest-agent"),
                .text("Then in Proxmox: VM > Options > QEMU Guest Agent > Enable"),
                .text("3. Set a static IP (if not done during install):"),
                .command("sudo nano /etc/netplan/00-installer-config.yaml"),
                .text("4. Enable SSH:"),
                .command("sudo apt install openssh-server -y && sudo systemctl enable ssh"),
            ]),

            GuideSection(title: "Managing VMs", blocks: [
                .commandTable([
                    (label: "Start/Shutdown", command: "Select VM > Start or Shutdown"),
                    (label: "Take a snapshot", command: "VM > Snapshots > Take Snapshot"),
                    (label: "Backup", command: "VM > Backup > Backup Now"),
                    (label: "Resize disk", command: "VM > Hardware > Hard Disk > Resize"),
                    (label: "Clone a VM", command: "Right-click VM > Clone"),
                ]),
                .tip("Always take snapshots before major changes so you can roll back if something breaks."),
            ]),
        ],
        tips: [
            "Don't over-allocate resources — leave enough for Proxmox and your containers",
            "Use \"Start at boot\" option (VM > Options) for VMs that should always be running",
            "VirtIO drivers give the best performance for both disk and network",
            "Use SSH instead of the Proxmox console for a better terminal experience",
        ]
    )

    // MARK: - Proxmox Containers

    static let proxmoxContainers = Guide(
        id: "proxmox-containers",
        title: "Proxmox Containers",
        subtitle: "Create and configure LXC containers in Proxmox for each service in your homelab.",
        category: .virtualization,
        icon: "shippingbox",
        videoSearch: "NetworkChuck Proxmox containers",
        prerequisites: [
            "A running Proxmox server (see Proxmox Homelab Setup guide)",
            "Downloaded CT templates (e.g., ubuntu-22.04-standard)",
        ],
        sections: [
            GuideSection(title: "How to Create a Container", blocks: [
                .text("These general steps apply to all containers. Each service below has specific settings."),
                .steps([
                    "In Proxmox Web UI, click \"Create CT\" (top right)",
                    "General: Set CT ID, hostname, root password. Check \"Unprivileged container\"",
                    "Template: Select a downloaded template (ubuntu-22.04 or debian-12)",
                    "Disks: Set disk size (8GB minimum, more for storage-heavy services)",
                    "CPU: Set cores (1-2 is fine for most)",
                    "Memory: Set RAM (512MB-2GB depending on service)",
                    "Network: Set static IP (192.168.5.XX/24), gateway (192.168.5.1), bridge vmbr0",
                    "DNS: Leave default or set to your Pi-hole IP",
                    "Confirm, Create, Start, then click Console",
                ]),
            ]),

            GuideSection(title: "Pi-hole (DNS Ad Blocker)", blocks: [
                .text("IP: 192.168.5.10 | RAM: 512MB | Disk: 8GB | Cores: 1"),
                .command("apt update && apt upgrade -y\napt install curl -y\ncurl -sSL https://install.pi-hole.net | bash"),
                .text("During installation: select network interface, choose upstream DNS (Google 8.8.8.8 or Cloudflare 1.1.1.1), accept default blocklists, install web interface."),
                .text("Change admin password:"),
                .command("pihole -a -p YOUR-NEW-PASSWORD"),
                .text("Access at http://192.168.5.10/admin"),
                .tip("Set your router's DNS to 192.168.5.10 to block ads network-wide for all devices."),
            ]),

            GuideSection(title: "Nextcloud (File Sync & Cloud Storage)", blocks: [
                .text("IP: 192.168.5.135 | RAM: 2GB | Disk: 32GB+ | Cores: 2"),
                .command("apt update && apt upgrade -y\napt install docker.io docker-compose -y"),
                .text("Create the docker-compose file:"),
                .command("mkdir -p /opt/nextcloud && cd /opt/nextcloud\nnano docker-compose.yml"),
                .text("Paste the config with Nextcloud + MariaDB services, then:"),
                .command("docker-compose up -d"),
                .text("Access at http://192.168.5.135:8080"),
                .steps([
                    "Create an admin account",
                    "Select MySQL/MariaDB for database",
                    "Set database user/password/name/host",
                    "Install the Nextcloud desktop client to sync files",
                ]),
            ]),

            GuideSection(title: "Vaultwarden (Password Manager)", blocks: [
                .text("IP: 192.168.5.12 | RAM: 512MB | Disk: 8GB | Cores: 1"),
                .command("apt update && apt upgrade -y\napt install docker.io -y"),
                .command("docker run -d \\\n  --name vaultwarden \\\n  -v /opt/vaultwarden/data/:/data/ \\\n  -p 80:80 \\\n  --restart always \\\n  vaultwarden/server:latest"),
                .text("Access at http://192.168.5.12"),
                .steps([
                    "Create a new account in the web interface",
                    "Install the Bitwarden browser extension",
                    "In extension settings, set server URL to http://192.168.5.12",
                    "Login with your account",
                ]),
                .warning("For remote access, set up Nginx Proxy Manager with HTTPS. Bitwarden requires HTTPS for browser extensions to work remotely."),
            ]),

            GuideSection(title: "Jellyfin (Media Server)", blocks: [
                .text("IP: 192.168.5.11 | RAM: 2GB | Disk: 16GB+ | Cores: 2"),
                .command("apt update && apt upgrade -y\napt install docker.io -y"),
                .command("docker run -d \\\n  --name jellyfin \\\n  -p 8096:8096 \\\n  -v /opt/jellyfin/config:/config \\\n  -v /opt/jellyfin/cache:/cache \\\n  -v /path/to/your/media:/media \\\n  --restart always \\\n  jellyfin/jellyfin:latest"),
                .text("Access at http://192.168.5.11:8096"),
                .steps([
                    "Follow the setup wizard and create an admin account",
                    "Add your media library (Movies, TV Shows, Music)",
                    "Point it to /media inside the container",
                ]),
                .tip("Jellyfin apps are available on iOS, Android, Roku, Fire TV, and more."),
            ]),

            GuideSection(title: "Nginx Proxy Manager (Reverse Proxy)", blocks: [
                .text("IP: 192.168.5.13 | RAM: 512MB | Disk: 8GB | Cores: 1"),
                .command("apt update && apt upgrade -y\napt install docker.io docker-compose -y"),
                .command("mkdir -p /opt/nginx-proxy && cd /opt/nginx-proxy\nnano docker-compose.yml"),
                .text("Add the nginx-proxy-manager config with ports 80, 81, 443, then:"),
                .command("docker-compose up -d"),
                .text("Access at http://192.168.5.13:81"),
                .text("Default login: admin@example.com / changeme (change immediately)"),
                .text("What it does:"),
                .bullets([
                    "Routes domain names to your services",
                    "Adds free HTTPS/SSL certificates via Let's Encrypt",
                    "Example: nextcloud.yourdomain.com -> 192.168.5.135:8080",
                ]),
                .steps([
                    "Click \"Proxy Hosts\" > \"Add Proxy Host\"",
                    "Set domain, forward hostname (service IP), and forward port",
                    "Enable \"Block Common Exploits\"",
                    "SSL tab: Request a new certificate, enable Force SSL",
                ]),
            ]),
        ],
        tips: [
            "Start each container after creating it by clicking \"Start\"",
            "Use \"Console\" in Proxmox to access the container terminal",
            "You can also SSH into containers: ssh root@CONTAINER-IP",
            "Back up containers: Proxmox > select CT > Backup",
            "Snapshot before making big changes in case you need to roll back",
        ]
    )
}
