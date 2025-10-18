# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./docker.nix
    ./nixbuild.nix
    ./desktop.nix
  ];
  boot.loader = {
    # Bootloader.
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 5;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.plymouth.enable = true;
  # boot.crashDump.enable = true;
  # Define your hostname.
  networking.hostName = "nixos";

  networking.networkmanager = {
    # Enable networking
    enable = true;
    plugins = [
      pkgs.networkmanager-openvpn
    ];
    wifi.powersave = false;
  };

  # Set your time zone.
  # time.timeZone = "Europe/Tallinn";
  services.automatic-timezoned.enable = true;
  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  security.pam.services.swaylock = {};
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "et_EE.UTF-8";
    LC_IDENTIFICATION = "et_EE.UTF-8";
    LC_MEASUREMENT = "et_EE.UTF-8";
    LC_MONETARY = "et_EE.UTF-8";
    LC_NAME = "et_EE.UTF-8";
    LC_NUMERIC = "et_EE.UTF-8";
    LC_PAPER = "et_EE.UTF-8";
    LC_TELEPHONE = "et_EE.UTF-8";
    LC_TIME = "et_EE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "us";

  programs = {
    adb.enable = true;

    fish.enable = true;
  };
  hardware = {
    bluetooth.enable = true;
    graphics = {
      # Enable OpenGL
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        libvdpau-va-gl
        vaapiVdpau
        # mesa
      ];
    };

    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Do not disable this unless your GPU is unsupported or if you have a good reason to.
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  security = {
    polkit.enable = true;
    sudo.extraConfig = ''
      Defaults timestamp_timeout=60
    '';
    rtkit.enable = true;
  };

  musnix.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mikidep = {
    isNormalUser = true;
    description = "Michele De Pascalis";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "audio"
      "dialout"
      "docker"
    ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.stable;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      randomizedDelaySec = "60min";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      # substituters = lib.mkBefore ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
      trusted-users = ["mikidep"];
    };
  };
  environment = {
    shells = with pkgs; [bash fish];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [
      idevicerestore
      libimobiledevice
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ];
  };

  services = {
    # List services that you want to enable:
    # Enable the X11 windowing system.
    # services.xserver.enable = true;
    flatpak.enable = true;

    udisks2.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    usbmuxd.enable = true;
    usbmuxd.package = pkgs.usbmuxd2;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    pcscd.enable = true;

    upower.enable = true;
    logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
