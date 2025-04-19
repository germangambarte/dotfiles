{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config.allowUnfree = true; 

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configuración del sistema
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Argentina/San_Juan";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  console.keyMap = "us-acentos";

  services.xserver.enable = false;
  services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      user = "greeter";
    };
  };
};

#
#  systemd.services.ly = {
#   description = "LY Display Manager";
#   after = [ "systemd-user-sessions.service" "getty@tty1.service" ];
#   conflicts = [ "getty@tty1.service" ];
#   wantedBy = [ "multi-user.target" ];  # <- Este es clave
#   serviceConfig = {
#     ExecStart = "${pkgs.ly}/bin/ly";
#     StandardInput = "tty";
#     TTYPath = "/dev/tty1";
#     TTYReset = true;
#     TTYVHangup = true;
#     TTYVTDisallocate = true;
#     Restart = "always";
#   };
# };
#
# systemd.services."getty@tty1".enable = false;
#
#
  # Habilitar Wayland + optimización de GTK/Qt
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.catppuccin
    ];

  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM = "wayland"; 
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
  };

  # Soporte para fuentes y mejor renderizado
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    iosevka-comfy.comfy-wide-motion
    noto-fonts noto-fonts-extra noto-fonts-cjk-sans noto-fonts-cjk-serif noto-fonts-color-emoji
    (nerdfonts.override { fonts = [ "CascadiaCode" "Iosevka" ]; })
  ];

  # Soporte para impresión y Bluetooth
  services.printing.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Audio con PipeWire
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Seguridad y redes
  services.openssh = {
    enable = true;
    # settings = {
    #   PasswordAuthentication = false;
    #   PermitRootLogin = "no";
    # };
    extraConfig = ''
    	Subsystem sftp internal-sftp
    '';
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };

  services.fail2ban.enable = true;

  # Configuración de usuarios
  users.users.ger = {
    isNormalUser = true;
    description = "German";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ 
      # Herramientas esenciales
      neovim git lazygit zoxide fzf eza yazi wget unzip unrar openssl tmux htop
      # Aplicaciones
      ghostty kitty google-chrome telegram-desktop keepassxc dbeaver-bin mpv zed-editor postman obsidian
      pgadmin4-desktopmode zathura vscode-fhs
      # Editores
      jetbrains.pycharm-community-bin jetbrains.idea-community-bin
      # Lenguajes de programación
      (python312.withPackages (ps: with ps; [ pip conda isort black ]))
      nodejs_23 yarn pnpm bun deno
      go gopls gcc zig 
      jdk maven
      # Shell
      zsh oh-my-posh
      # LSPs
      lua-language-server pyright typescript-language-server clang-tools
      # Hyprland
      hyprpaper  # Para fondos de pantalla
      wlsunset # filtro de luz azul
      waybar  # Barra de estado compatible con Hyprland
      wofi
      bluez bluez-tools
      wl-clipboard  # Portapapeles en Wayland
      dunst  # Notificaciones
      brightnessctl  # Control de brillo
      grim  # Capturas de pantalla
      slurp  # Selección de área para capturas
      wbg  # Alternativa para fondos de pantalla
      greetd.tuigreet
    ];
  };

  users.users.root.shell = pkgs.zsh;
  programs.zsh.enable = true;

  # MySQL (MariaDB)
  services.mysql = {
    enable = true;
    package = pkgs.mariadb_114;
    dataDir = "/var/lib/mysql";
    ensureUsers = [{ name = "root"; }];
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
    dataDir = "/var/lib/postgresql/16";
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "init.sql" ''
      CREATE USER root WITH PASSWORD 'secret';
      CREATE DATABASE mydb OWNER root;
    '';
  };


  # Virtualización con Docker
  virtualisation.docker.enable = true;

  # XDG Portals (mejor integración de Wayland)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Mantenimiento automático del sistema
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  system.stateVersion = "24.11"; 
}
