#!/bin/bash
# install.sh - Complete installation script for AWESOME-PHISHING-BOT v5.5.0
# Author: Ian Carter Kulani

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════╗
║                    AWESOME-PHISHING-BOT v5.5.0                               ║
║                      Installation Script                                     ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /etc/debian_version ]]; then
            OS="debian"
        elif [[ -f /etc/redhat-release ]]; then
            OS="redhat"
        elif [[ -f /etc/arch-release ]]; then
            OS="arch"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    echo -e "${GREEN}✓ Detected OS: $OS${NC}"
}

# Check Python version
check_python() {
    echo -e "${BLUE}→ Checking Python version...${NC}"
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
        if [[ $(echo "$PYTHON_VERSION >= 3.7" | bc) -eq 1 ]]; then
            echo -e "${GREEN}✓ Python $PYTHON_VERSION detected${NC}"
        else
            echo -e "${RED}✗ Python 3.7+ required (found $PYTHON_VERSION)${NC}"
            exit 1
        fi
    else
        echo -e "${RED}✗ Python 3 not found${NC}"
        exit 1
    fi
}

# Install system dependencies
install_system_deps() {
    echo -e "${BLUE}→ Installing system dependencies...${NC}"
    
    case $OS in
        debian)
            sudo apt-get update
            sudo apt-get install -y \
                python3-pip python3-dev python3-venv \
                build-essential libssl-dev libffi-dev \
                libpcap-dev tcpdump net-tools \
                iputils-ping dnsutils nmap whois \
                curl wget git \
                chromium-browser chromium-chromedriver \
                sqlite3 postgresql-client redis-tools \
                libxml2-dev libxslt1-dev zlib1g-dev \
                libjpeg-dev libpng-dev libfreetype6-dev
            ;;
        redhat)
            sudo dnf install -y \
                python3-pip python3-devel \
                gcc gcc-c++ make \
                openssl-devel libffi-devel \
                libpcap-devel tcpdump net-tools \
                iputils bind-utils nmap whois \
                curl wget git \
                chromium chromedriver \
                sqlite postgresql redis
            ;;
        arch)
            sudo pacman -S --noconfirm \
                python-pip python-virtualenv \
                base-devel openssl libffi \
                libpcap tcpdump net-tools \
                iputils bind-tools nmap whois \
                curl wget git \
                chromium chromedriver \
                sqlite postgresql redis
            ;;
        macos)
            if ! command -v brew &> /dev/null; then
                echo -e "${YELLOW}→ Installing Homebrew...${NC}"
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install python3 libpcap tcpdump nmap whois wget git chromedriver sqlite postgresql redis
            ;;
        windows)
            echo -e "${YELLOW}→ Windows detected. Installing via chocolatey...${NC}"
            if ! command -v choco &> /dev/null; then
                echo -e "${YELLOW}→ Installing Chocolatey...${NC}"
                powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
            fi
            choco install -y python nmap wireshark git chromium sqlite postgresql redis-64
            ;;
        *)
            echo -e "${RED}✗ Unsupported OS${NC}"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}✓ System dependencies installed${NC}"
}

# Create virtual environment
setup_venv() {
    echo -e "${BLUE}→ Setting up Python virtual environment...${NC}"
    
    if [[ ! -d "venv" ]]; then
        python3 -m venv venv
        echo -e "${GREEN}✓ Virtual environment created${NC}"
    else
        echo -e "${YELLOW}→ Virtual environment already exists${NC}"
    fi
    
    source venv/bin/activate
    echo -e "${GREEN}✓ Virtual environment activated${NC}"
}

# Install Python dependencies
install_python_deps() {
    echo -e "${BLUE}→ Installing Python dependencies...${NC}"
    
    # Upgrade pip
    pip install --upgrade pip setuptools wheel
    
    # Install requirements
    if [[ -f "requirements.txt" ]]; then
        pip install -r requirements.txt
    else
        echo -e "${RED}✗ requirements.txt not found${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Python dependencies installed${NC}"
}

# Create directory structure
create_directories() {
    echo -e "${BLUE}→ Creating directory structure...${NC}"
    
    directories=(
        ".awesome-phishing-bot"
        "awesome_reports"
        "awesome_reports/scans"
        "awesome_reports/blocked"
        "awesome_reports/graphics"
        "backups"
        "monitoring"
        "alerts"
        "scripts"
        "logs"
        "temp"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
        echo -e "${GREEN}  ✓ Created $dir${NC}"
    done
    
    echo -e "${GREEN}✓ Directory structure created${NC}"
}

# Create configuration files
create_configs() {
    echo -e "${BLUE}→ Creating configuration files...${NC}"
    
    # Main config
    cat > .awesome-phishing-bot/config.json << 'EOF'
{
    "version": "5.5.0",
    "debug": false,
    "log_level": "INFO",
    "phishing_port": 8080,
    "web_port": 5000,
    "ssh_port": 22,
    "database": {
        "type": "sqlite",
        "path": ".awesome-phishing-bot/awesome_data.db"
    },
    "traffic": {
        "max_packets": 10000,
        "default_rate": 10,
        "timeout": 300
    },
    "alerts": {
        "enabled": true,
        "webhook_url": "",
        "threshold": 5
    },
    "monitoring": {
        "enabled": true,
        "interval": 60,
        "alert_email": ""
    }
}
EOF
    
    echo -e "${GREEN}✓ Configuration files created${NC}"
}

# Setup SSH keys
setup_ssh() {
    echo -e "${BLUE}→ Setting up SSH keys...${NC}"
    
    mkdir -p .awesome-phishing-bot/ssh_keys
    
    if [[ ! -f ".awesome-phishing-bot/ssh_keys/awesome_key" ]]; then
        ssh-keygen -t rsa -b 4096 -f .awesome-phishing-bot/ssh_keys/awesome_key -N ""
        echo -e "${GREEN}✓ SSH keys generated${NC}"
    else
        echo -e "${YELLOW}→ SSH keys already exist${NC}"
    fi
}

# Setup firewall rules (optional)
setup_firewall() {
    echo -e "${BLUE}→ Setting up firewall rules...${NC}"
    
    case $OS in
        debian|redhat|arch)
            if command -v ufw &> /dev/null; then
                sudo ufw allow 8080/tcp comment "Awesome Phishing Bot"
                sudo ufw allow 5000/tcp comment "Awesome Web Interface"
                sudo ufw allow 22/tcp comment "SSH Access"
                echo -e "${GREEN}✓ UFW rules added${NC}"
            elif command -v firewall-cmd &> /dev/null; then
                sudo firewall-cmd --permanent --add-port=8080/tcp
                sudo firewall-cmd --permanent --add-port=5000/tcp
                sudo firewall-cmd --reload
                echo -e "${GREEN}✓ FirewallD rules added${NC}"
            fi
            ;;
        macos)
            echo -e "${YELLOW}→ macOS firewall: configure manually if needed${NC}"
            ;;
        *)
            echo -e "${YELLOW}→ Firewall setup skipped${NC}"
            ;;
    esac
}

# Create systemd service (Linux)
create_service() {
    if [[ "$OS" == "debian" ]] || [[ "$OS" == "redhat" ]] || [[ "$OS" == "arch" ]]; then
        echo -e "${BLUE}→ Creating systemd service...${NC}"
        
        CURRENT_DIR=$(pwd)
        CURRENT_USER=$(whoami)
        
        sudo tee /etc/systemd/system/awesome-phishing-bot.service << EOF
[Unit]
Description=Awesome Phishing Bot v5.5.0
After=network.target network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$CURRENT_USER
Group=$CURRENT_USER
WorkingDirectory=$CURRENT_DIR
Environment="PATH=$CURRENT_DIR/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ExecStart=$CURRENT_DIR/venv/bin/python3 $CURRENT_DIR/awesome-phishing-bot.py
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=awesome-phishing-bot

[Install]
WantedBy=multi-user.target
EOF
        
        sudo systemctl daemon-reload
        echo -e "${GREEN}✓ Systemd service created${NC}"
        echo -e "${YELLOW}→ To enable: sudo systemctl enable awesome-phishing-bot${NC}"
        echo -e "${YELLOW}→ To start: sudo systemctl start awesome-phishing-bot${NC}"
    fi
}

# Setup Docker (optional)
setup_docker() {
    echo -e "${BLUE}→ Setting up Docker support...${NC}"
    
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}✓ Docker detected${NC}"
        
        # Build Docker image
        if [[ -f "Dockerfile" ]]; then
            read -p "Build Docker image? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                docker build -t awesome-phishing-bot:latest .
                echo -e "${GREEN}✓ Docker image built${NC}"
            fi
        fi
        
        # Create docker-compose override if needed
        if [[ -f "docker-compose.yml" ]]; then
            echo -e "${GREEN}✓ Docker Compose file ready${NC}"
            echo -e "${YELLOW}→ To run: docker-compose up -d${NC}"
        fi
    else
        echo -e "${YELLOW}→ Docker not installed. Skipping...${NC}"
    fi
}

# Create startup script
create_startup_script() {
    echo -e "${BLUE}→ Creating startup script...${NC}"
    
    cat > start.sh << 'EOF'
#!/bin/bash
# Startup script for AWESOME-PHISHING-BOT

cd "$(dirname "$0")"

# Activate virtual environment
source venv/bin/activate

# Check if already running
if pgrep -f "awesome-phishing-bot.py" > /dev/null; then
    echo "⚠️ Awesome Phishing Bot is already running"
    exit 1
fi

# Start the bot
echo "🚀 Starting Awesome Phishing Bot..."
python3 awesome-phishing-bot.py

# Deactivate virtual environment on exit
deactivate
EOF
    
    cat > stop.sh << 'EOF'
#!/bin/bash
# Stop script for AWESOME-PHISHING-BOT

# Find and kill the process
pkill -f "awesome-phishing-bot.py"
echo "✅ Awesome Phishing Bot stopped"
EOF
    
    chmod +x start.sh stop.sh
    echo -e "${GREEN}✓ Startup scripts created (start.sh, stop.sh)${NC}"
}

# Main installation
main() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║         Starting Installation Process                      ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    detect_os
    check_python
    install_system_deps
    setup_venv
    install_python_deps
    create_directories
    create_configs
    setup_ssh
    setup_firewall
    create_service
    setup_docker
    create_startup_script
    
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║         Installation Complete!                             ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}📋 Next Steps:${NC}"
    echo -e "  1. Edit configuration: ${YELLOW}nano .awesome-phishing-bot/config.json${NC}"
    echo -e "  2. Start the bot: ${YELLOW}./start.sh${NC}"
    echo -e "  3. Or using systemd: ${YELLOW}sudo systemctl start awesome-phishing-bot${NC}"
    echo -e "  4. Or using Docker: ${YELLOW}docker-compose up -d${NC}"
    echo -e ""
    echo -e "${CYAN}📚 Documentation:${NC}"
    echo -e "  • Type 'help' in the bot console for commands"
    echo -e "  • Phishing templates available for 50+ platforms"
    echo -e "  • Bot supports Discord, Telegram, Slack, WhatsApp, iMessage, Google Chat"
    echo -e ""
    echo -e "${GREEN}🎣 Happy Phishing (for educational purposes only)!${NC}"
}

# Run main installation
main "$@"