{
  pkgs ? import (fetchGit {
    name = "nixos-21.11-2022-05-17";
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixos-21.11";
    # `git ls-remote https://github.com/nixos/nixpkgs nixos-21.11`
    rev = "8b3398bc7587ebb79f93dfeea1b8c574d3c6dba1";
  }) {}
}:

with pkgs;
let
  custom_kicad = { kicadVersion, rev, sha256 } : kicad-unstable.override {
    srcs = {
      inherit kicadVersion;
      kicad = fetchFromGitLab {
        group = "kicad";
        owner = "code";
        repo = "kicad";
        inherit rev sha256;
      };
    };
  };
  kicad-6_0_5 = custom_kicad {
    kicadVersion = "6.0.5";
    rev = "a6ca702e916df70e499615d8613102e780e96a40";
    sha256 = "19mg672h1gjdvnkp13cpkhk67xpwms72y4gd6g8983fcsxr8nq23";
  };
  kicad-5_99_0 = custom_kicad {
    kicadVersion = "5.99.0";
    rev = "9a795c1333ba09f176d6ca290bc9f08d08f033e1";
    sha256 = "0clv96vvzil1a33g6x8flhwqd57g0a1a9jjzgpjwyxjh3wvnnnyi";
  };
in
mkShell {
  buildInputs = [
    #kicad # stable upstream
    #kicad-5_99_0
    kicad-6_0_5
    zip
  ];
}
