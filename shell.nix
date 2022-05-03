{
  pkgs ? import (fetchTarball {
    # nixos-21.11 as of 2021-04-03
    url = https://github.com/NixOS/nixpkgs/archive/fd3e33d696b81e76b30160dfad2efb7ac1f19879.tar.gz;
    sha256 = "1liw3glyv1cx0bxgxnq2yjp0ismg0np2ycg72rqghv75qb73zf9h";
  }) {}
}:

with pkgs;
mkShell {
  buildInputs = [
    kicad-unstable
    zip
  ];
}
