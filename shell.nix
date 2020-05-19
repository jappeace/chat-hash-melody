{ pkgs ? import ./pin.nix }:
pkgs.mkShell{
    buildInputs = [
        pkgs.rakudo
        pkgs.zef
        pkgs.portmidi
    ];
    LD_LIBRARY_PATH="${pkgs.portmidi}/lib:/home/jappie/project/chat-hash-melody/";
}

