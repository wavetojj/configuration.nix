{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Seoul";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "@admin" "@wheel" ];
  };

  networking = {
    hostName = "x1";
    networkmanager = {
      enable   = true;
      packages = [ pkgs.networkmanager ];
    };
  };

  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.haedosa = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/haedosa";
    extraGroups = [ "wheel" "networkmanager" ];
    # to generate : nix-shell -p mkpasswd --run 'mkpasswd -m sha-512'
    hashedPassword = "$6$yQZhmtQSc$yrSsqB5WQQsbvd2Gxz/tO4MamZhwQTxFWgwX41voXuG4Ufpn1zBHSx2pcttvuDYSvldVJlqIXoivhjbsYXGvB/";
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    firefox
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
