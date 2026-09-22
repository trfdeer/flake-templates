{ lib, inputs, ... }: {
  systems = [
    "x86_64-linux"
  ];

  perSystem = { system, ... }: {
    _module.args.nixpkgs = lib.mkDefault import inputs.nixpkgs {
      inherit system;

      overlays = [
        (final: prev: {
          unstable = import inputs.nixpkgsUnstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];

      config.allowUnfree = true;
    };
  };
}
