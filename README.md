# awesome_phishing_bot_v5.5.0

<img width="993" height="424" alt="phishing2" src="https://github.com/user-attachments/assets/eeeaba5f-1f4c-4ff7-84f5-4083e1dc96b2" />

Awesome Phishing Bot is an enterprise-grade, cross-platform social engineering simulator designed for security professionals, red teams, and awareness trainers. Unlike traditional phishing tools locked to email, this bot operates natively where your users actually communicate: Telegram, Discord, WhatsApp, Slack, and iMessage.
Core Capabilities
Once enabled on any of the six supported messaging platforms, Awesome Phishing Bot transforms into a realistic adversary emulation engine. It generates fully interactive, clone-quality login pages for over 120 brands (Microsoft 365, Google, Apple iCloud, Slack, Discord, WhatsApp Web, and banking portals). The bot captures credentials, multi-factor authentication (MFA) tokens, geolocation, user-agent strings, and even screenshot evidence—all in real time.

Platform-Specific Enablement
Telegram: Deploy via /deploy command. The bot creates disposable campaign links, tracks clicks, and reports metrics directly in your private channel.

Discord: Use slash commands (/phish launch) to spin up a campaign. Supports role-based targeting and hidden audit logging for server admins.

WhatsApp: Enable via WhatsApp Business API. Send personalized, conversational phishing simulations that mimic customer support or IT helpdesk messages.

Slack: Authorize the bot via OAuth. Launch internal phishing tests against channels or direct messages, including fake "Okta verification" or "HR document request" templates.

iMessage: Enable via a macOS bridge or iMessage relay. Target Apple users with iCloud credential harvesters and "Apple ID suspended" alerts.

Why Awesome Phishing Bot Stands Out
Real-time analytics dashboard – Every interaction is logged: who clicked, when, from which IP, on which device, and whether they submitted credentials. The bot automatically scores user risk and schedules remedial training for repeat fails.

Zero infrastructure setup – No SMTP servers, no domain warm-up, no email gateways. The bot handles TLS certificates, URL shortening, and anti-filter evasion (including CAPTCHA pass-through and browser fingerprint spoofing).

Safe-by-design – All captured data is encrypted and automatically purged after 72 hours unless exported. The bot enforced "consent mode" – you must whitelist target domains or user IDs before any campaign launches.

Cross-platform orchestration – Launch a single campaign that spans all six messengers simultaneously. For example: send a "password expired" alert to a user on Slack, follow up via WhatsApp, and redirect to the same branded phishing page. The bot correlates responses across platforms to measure how channel hopping affects susceptibility.

# Use Cases

Red Team operations: Simulate compromised helpdesk accounts that phish via real chat platforms.

Security awareness training: Run unannounced drills on iMessage and WhatsApp—channels often overlooked by traditional simulations.

Incident response validation: Test if your team detects and reports a Discord-based credential harvester.

# Getting Started

Enable Awesome Phishing Bot in under 2 minutes:

Add the bot to your preferred platform (Telegram, Discord, Slack, WhatsApp Business, or iMessage relay).

Run /setup to define your campaign scope.

Choose a template or upload a custom HTML landing page.

Execute /phish start and watch real-time results stream into your command channel.


# How to clone the repo

```bash
git clone https://github.com/Iankulani/awesome_phishing_bot.git
cd awesome_phishing_bot
```

# How to run
```bash
python awesome_phishing_bot.py
```

 
Disclaimer: For authorized security testing and educational use only. The bot includes mandatory banner warnings on all phishing pages. Unauthorized deployment violates platform terms of service and may be illegal.

Awesome Phishing Bot – Because modern phishing doesn't happen in email inboxes. It happens in chat. Be ready.

