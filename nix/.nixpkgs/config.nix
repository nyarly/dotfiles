{
  allowUnfree = true;
  packageOverrides = pkgs: rec {
    networkmanager_openconnect = pkgs.networkmanager_openconnect.override {
      openconnect = pkgs.openconnect_gnutls;
    };
    # copied from nixos stable
    /*
    linuxPackages.kernel = pkgs.stdenv.lib.overrideDerivation pkgs.linuxPackages.kernel (oldAttrs: {
      version = "4.4.14";
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v4.x/linux-4.4.14.tar.xz";
        sha256 = "1yam0lmj465xsdv3h9zkz2ca5j6sdn18ydv8225scq3ig49bllsr";
      };
    });
    */
  };
}
