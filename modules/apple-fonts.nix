# apple-fonts.nix
{
  pkgs,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "apple-fonts";
  version = "system"; # Or a date like "2023-10-26" if you downloaded a specific version

  # IMPORTANT: Replace this with the actual path to YOUR downloaded fonts
  src = ../fonts/apple-fonts; # Or use a relative path if it's in your config repo

  dontBuild = true; # No build step needed, just installation

  installPhase = ''
    runHook preInstall

    # Create the font directory in the output
    install -d $out/share/fonts/opentype # Or truetype, or a generic 'fonts'

    # Copy all .otf, .ttf, and .ttc files
    # Use find to handle subdirectories if your fonts are organized that way
    find $src -type f \( -iname "*.otf" -o -iname "*.ttf" -o -iname "*.ttc" \) \
      -exec install -Dm644 {} $out/share/fonts/opentype/ \;
    # The -Dm644 creates parent directories if needed and sets permissions.
    # Adjust the target subdir (opentype) if needed.

    runHook postInstall
  '';

  meta = with lib; {
    description = "Apple San Francisco and related fonts (locally sourced)";
    homepage = "https://developer.apple.com/fonts/";
    license = licenses.unfree; # Mark as unfree because of Apple's license
    platforms = platforms.all;
    maintainers = [maintainers.lvnilesh]; # Optional
  };
}
