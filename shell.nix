{ pkgs ? import
    (builtins.fetchGit {
      name = "nixos-22.11-2023_01_05";
      url = "https://github.com/nixos/nixpkgs/";
      ref = "refs/heads/nixos-22.11";
      rev = "a9eedea7232f5d00f0aca7267efb69a54da1b8a1";
    })
    { }
}:

with pkgs;

mkShell {
  buildInputs = [
    kicad # 6.0.9
    zip
  ];
}

