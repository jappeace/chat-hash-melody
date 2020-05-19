let 
pinnedPkgs = 
    (builtins.fetchGit {
    name = "nixos-pin-19.05.2020";
    url = https://github.com/nixos/nixpkgs/;
    rev = "aeeb341c3e127db39699005e5928ad7ba30547d3";
    }) ;
in
import pinnedPkgs {
    # since I also use this for clients I don't want to have to care
    config.allowUnfree = true; # took me too long to figure out
}
