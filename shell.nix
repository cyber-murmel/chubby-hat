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
let
  custom_kicad = { kicadVersion, rev, sha256 }: kicad-unstable.override {
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
  kicad-7_0_1 = custom_kicad {
    kicadVersion = "7.0.1";
    rev = "3f5d3fa0";
    sha256 = "sha256-tmpBW23fVw6TT7oA6ifpccP61d1yeImA/jhhv7tTOgg=";
  };
in
mkShell {
  buildInputs = [
    #kicad # 7.0.0
    kicad-7_0_1
    zip
    poppler_utils
    (python3.withPackages(ps: with ps; [
      sexpdata
    ]))
  ];
}
