# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  customFonts = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  };

#  waylandPkg = builtins.fetchTarball {  
#    url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
#    sha256 = "14h4gnljrr0mhxkfcdwc6nm3ysh8jjy9wq6b0iba1ppvyw59vdws";
#  };
#  waylandOverlay = import waylandPkg;

#  chromiumPkg = builtins.fetchTarball {
#    url    = "https://github.com/colemickens/nixpkgs-chromium/archive/master.tar.gz";
#    sha256 = "0d5gmcnalh3x154mg40cx70d48a9nvn5x8kkcp2xxp0cha6hqh96";
#  };
#  chromium = import chromiumPkg;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Machine-specific configuration
      ./dell-xps.nix
    ];

#  nix = {
#    binaryCachePublicKeys = [ "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=" ];
#    binaryCaches = [ "https://nixpkgs-wayland.cachix.org" ];
#  };
  
  # overlays
  # nixpkgs.overlays = [ waylandOverlay ];

  # Use the GRUB 2 boot loader.
  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
      };
    };
  };
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking = {
    # Enables wireless support and openvpn via network manager.
    networkmanager = {
      enable = true;  
      packages = [ pkgs.networkmanager_openvpn ];
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #wayvnc 
    wget
  ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable Docker support.
  virtualisation = {
    docker = {
      enable = true;
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services = {
    # Gnome3 config
    dbus.packages = [ pkgs.gnome3.dconf ];
    udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable screen-sharing for Wayland (Gnome3)
    # pipewire.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    # GUI interface
    xserver = {
      enable = true;
      layout = "us";

      # Enable touchpad support.
      libinput.enable = true;

      # Enable the Gnome3 desktop manager
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = false; # screen-sharing is broken
      desktopManager.gnome3.enable = true;
    };
  };

  # Making fonts accessible to applications.
  fonts.fonts = with pkgs; [
    customFonts
  ];

  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gvolpe = {
    isNormalUser = true;
    extraGroups = [ "docker" "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Avoid unwanted garbage collection when using nix-direnv
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
