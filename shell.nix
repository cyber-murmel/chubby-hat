{ pkgs ? import
    (builtins.fetchGit {
      name = "nixos-22.05-2022_08_27";
      url = "https://github.com/nixos/nixpkgs/";
      ref = "refs/heads/nixos-22.05";
      rev = "b47d4447dc2ba34f793436e6631fbdd56b12934a";
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
  kicad-6_0_7 = custom_kicad {
    kicadVersion = "6.0.7";
    rev = "f9a2dced07acac97c62eef0931269fea6bcfb828";
    sha256 = "10bqn99nif9zyi5v0lkic3na2vac5lgacw01ayil359vaw7d0pzy";
  };
in
mkShell {
  buildInputs = [
    # kicad-6_0_7
    kicad # 6.0.5
    zip
  ];
}
