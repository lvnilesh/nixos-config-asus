# wireplumber-config.nix
{pkgs}:
pkgs.runCommand "wireplumber-config" {} ''
  mkdir -p $out/share/wireplumber/wireplumber.conf.d
  cat > $out/share/wireplumber/wireplumber.conf.d/99-good-audio.conf << EOF
  {
    "wireplumber.settings": {
      "linking.follow": true
    }
  }
  EOF
''
