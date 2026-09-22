{
  description = "a basic flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./nix);
}
