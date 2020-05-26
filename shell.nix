{ pkgs ? import ./pin.nix }:
let
  betterMidi = import ./nix/raku-portmidi.nix { mkDerivation=pkgs.stdenv.mkDerivation; portmidi=pkgs.portmidi;};
in
pkgs.mkShell{
    buildInputs = [
        # pkgs.rakudo
        pkgs.zef
        betterMidi 

        (pkgs.writeShellScriptBin "perl6"
          "LD_LIBRARY_PATH=${betterMidi} ${pkgs.rakudo}/bin/perl6 \"$@\""
        )

        # pkgs.yoshimi # use system yoshimi
        (pkgs.writeShellScriptBin "fluidsynth"
          "${pkgs.fluidsynth}/bin/fluidsynth -a pulseaudio ${pkgs.soundfont-fluid}"
        )
      
    ];
}

