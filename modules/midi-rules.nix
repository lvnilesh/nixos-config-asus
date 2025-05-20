{
  config,
  lib,
  pkgs,
  ...
}: {
  services.udev.extraRules = ''
    # Set permissions for USB MIDI Interface
    SUBSYSTEM=="usb", ATTRS{idVendor}=="fc02", ATTRS{idProduct}=="0101", GROUP="audio", MODE="0660", TAG+="uaccess"
    SUBSYSTEM=="sound", ATTRS{idVendor}=="fc02", ATTRS{idProduct}=="0101", GROUP="audio", MODE="0660", TAG+="uaccess"

    # Auto-connect this specific USB MIDI Interface when plugged in
    SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="fc02", ATTRS{idProduct}=="0101", TAG+="systemd", ENV{SYSTEMD_WANTS}="midi-autoconnect.service"
  '';

  systemd.services.midi-autoconnect = {
    description = "Auto-connect MIDI devices";
    after = ["sound.target"];
    serviceConfig = {
      Type = "oneshot";
      # Set success exit code even if the script fails
      SuccessExitStatus = [0 1];
      ExecStart = pkgs.writeShellScript "midi-autoconnect-script" ''
        #!/bin/sh
        exec &> /tmp/midi-autoconnect.log

        echo "Running MIDI auto-connect script at $(date)"
        echo "Listing MIDI inputs:"
        ${pkgs.alsa-utils}/bin/aconnect -i

        echo "Looking for USB MIDI Interface..."
        MIDI_CLIENT=$(${pkgs.alsa-utils}/bin/aconnect -i | ${pkgs.gnugrep}/bin/grep 'USB MIDI Interface' | ${pkgs.gnugrep}/bin/grep -oP 'client \K[0-9]+')
        echo "Found MIDI client: $MIDI_CLIENT"

        if [ -n "$MIDI_CLIENT" ]; then
          # Check if connection already exists
          if ${pkgs.alsa-utils}/bin/aconnect -l | ${pkgs.gnugrep}/bin/grep "$MIDI_CLIENT:0.*14:0" > /dev/null; then
            echo "Connection already exists, no need to connect again"
          else
            echo "Connecting $MIDI_CLIENT:0 to 14:0"
            ${pkgs.alsa-utils}/bin/aconnect $MIDI_CLIENT:0 14:0 || echo "Connection failed, but continuing"
          fi
        else
          echo "MIDI client not found, nothing to connect"
        fi

        echo "Current connections:"
        ${pkgs.alsa-utils}/bin/aconnect -l

        # Exit with success status regardless of connection result
        exit 0
      '';
    };
  };
}
