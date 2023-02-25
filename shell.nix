{ pkgs ? import
    (builtins.fetchGit {
      name = "nixos-unstable-2023_02_25";
      url = "https://github.com/nixos/nixpkgs/";
      ref = "refs/heads/nixos-unstable";
      rev = "988cc958c57ce4350ec248d2d53087777f9e1949";
    })
    { }
}:

with pkgs;

mkShell {
  buildInputs = [
    kicad # 7.0.0
    zip
  ];
}

