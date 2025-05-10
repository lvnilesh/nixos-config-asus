{
  programs.brave = {
    enable = true;
    # package = pkgs.brave; # Usually not needed, defaults to pkgs.brave

    # -- Extensions --
    # You need the extension IDs from the Chrome Web Store URL.
    # e.g., uBlock Origin: https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
    # The ID is "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      # Add more extensions here
    ];

    # -- Command Line Arguments --
    # These are passed to Brave on startup.
    # Find flags at chrome://flags or brave://flags (experimental) or search online.
    commandLineArgs = [
      "--disk-cache-size=104857600" # 100 MB disk cache
      "--force-dark-mode" # If you prefer a dark theme for web content
      "--enable-features=VaapiVideoDecoder" # For hardware video acceleration on Linux (VA-API)
      "--disable-brave-rewards"
      "--disable-features=PasswordManager"
    ];

    # If you use multiple profiles and want to configure a specific one:
    # profiles = {
    #   "Profile 1" = { # The name of the profile directory
    #     preferences = {
    #       "homepage" = "https://example.com/profile1";
    #     };
    #     extensions = [
    #       { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin for Profile 1
    #     ];
    #   };
    #   "Default" = { # Configure the default profile
    #     preferences = {
    #        "homepage" = "https://example.com/default";
    #     };
    #   };
    # };
    # If 'profiles' is used, top-level 'preferences', 'extensions', etc. apply to all unpecified profiles or act as defaults.
  };
}
