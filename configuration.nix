

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=25"
  ];

  networking.hostName = "t440p"; # Define your hostname.


  networking.networkmanager.enable = true;


  time.timeZone = "Europe/Brussels";



  i18n.defaultLocale = "en_US.UTF-8";


  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
  "openssl-1.1.1w"
];


   users.users.aoiren = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

   programs.zsh = {
     enable = true;
     ohMyZsh = {
       enable = true;
       plugins = [ "git" "sudo" ];
       theme = "robbyrussell";
     };
   };

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;

    services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks
    ];
  };

    services.pulseaudio.enable = false;

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    programs.steam.enable = true;

    services.flatpak.enable = true;

    services.libinput = {
  enable = true;

  mouse = {
    accelProfile = "flat";
  };

  touchpad = {
    accelProfile = "flat";
  };
};

    xdg.portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];

      config = {
        common = {
          default = [ "gtk" ];
        };
      };
    };



     services.power-profiles-daemon.enable = true;

  services.tlp.enable = false;

  services.fstrim.enable = true;

  hardware.enableRedistributableFirmware = true;

  services.thermald.enable = true;

    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
      micro
      git
      wget
      curl
      htop
      fastfetch
      firefox
      kitty
      pavucontrol
      blueman
      networkmanagerapplet
      pciutils
      usbutils
      lshw
      unzip
      zip
      file
      tree
      killall
      brightnessctl
      xclip
      arandr
      autorandr
      lxappearance
      pcmanfm
      lm_sensors
      albert
      sublime4
      moonlight-qt
      tailscale
      protonup-qt
      ntfs3g
      gvfs
      jmtpfs
      vesktop
    ];


services.tailscale.enable = true;

nix.settings.experimental-features = [
  "nix-command"
  "flakes"
];

system.activationScripts.restartAlbert = ''
  if pgrep -u aoiren albert >/dev/null; then
    pkill -u aoiren albert || true
    sleep 1
    sudo -u aoiren DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus albert &
  fi
'';

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];


  system.stateVersion = "25.11";

}
