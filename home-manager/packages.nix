{ pkgs, ... }:
{
  # Programs with no configs
  home.packages = with pkgs; [
    # Packages in root enviroment already: helix, tmux
    # unstable.pkg

    # Messaging
    telegram-desktop discord #whatsapp can installed as webapp from brave

    # School
    wine #davinci look

    #iot
    cisco-packet-tracer_9
    (python313.withPackages (python-pkgs: with python-pkgs; [
      # select Python packages here
      psutil
    ]))

    #fyp
    blender godot_4_7 # u just change godot version manually

    # Work
    libreoffice-still
    kdePackages.kolourpaint

    # Internet
    librewolf brave

    # Streaming/Recording
    obs-studio # Might have to create a module for this guy for settings tho

    # CLI Stuff
    fastfetch btop
    mpv yt-dlp ffmpeg-full
    tree fzf wl-clipboard tldr
    zoxide
    mpc # debug music player daemon

    # Sway / Wayland
    swaybg # wallpaper
    brightnessctl # backlight keybinds
    grim slurp # screenshot
    libnotify # notify-send
    pywal # colorscheme from wallpaper (wal)

    # Helpful GUI
    kdePackages.filelight

    # Password Manager
    bitwarden-desktop

    # Development
    ollama # Local AI/MCP stuff | qwen2.5:7b
    nodejs_22 pnpm # npx for deepseek-harness
    ungoogled-chromium
    lazygit git
    nim nimble # dnd-nim
    # Neovim LSP
    superhtml pyright nimlangserver

    # Cool magic system stuff
    lean4

    # Gaming
    lutris protonplus
    # we use flatpak for steam instead
  ];
}
