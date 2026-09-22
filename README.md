# flake-templates

A personal collection of [Nix flake](https://nixos.wiki/wiki/Flakes) templates.

## Usage

Start a new project from a template:

```console
$ nix flake new ./my-project -t github:<user>/flake-templates#<name>
```

Or adopt one in an existing directory:

```console
$ nix flake init -t github:<user>/flake-templates#<name>
```

List available templates:

```console
$ nix flake show github:<user>/flake-templates
```

## Templates

| Name      | Description    |
| --------- | -------------- |
| `default` | basic template |

## Template architecture

Every generated project is a [flake-parts](https://flake.parts/) flake:

- The top-level `flake.nix` calls `inputs.import-tree ./nix` — every `.nix`
  file under `nix/` is auto-loaded as a flake-parts module. Add features as
  new modules there; no import list to maintain.
- `nix/system.nix` owns global config: `systems` is pinned to `x86_64-linux`
  only, nixpkgs is tracked on the current stable release, and an `unstable`
  overlay (`inputs.nixpkgsUnstable`, used as `pkgs.unstable`) is provided with
  `allowUnfree` enabled.
- `nix/devshell.nix` defines the dev shell (`nix develop`, direnv `.envrc`
  included) with `nixd` and `nixfmt`. Format Nix with `nixfmt`.
- A weekly GitHub Actions workflow (`.github/workflows/update.yaml`) opens a
  PR that updates `flake.lock` via
  [update-flake-lock](https://github.com/DeterminateSystems/update-flake-lock).

## Repository layout

Shared files live under `shared/` and are mirrored into every template:

- Files used by every template are maintained once under `shared/`. The
  `shared/` tree mirrors the layout of each template — including the
  template's own `flake.nix` and `nix/` modules.
- After editing anything in `shared/`, run `./scripts/sync.sh` to copy it into
  every template. Never edit the generated copies inside `templates/*/`
  directly — the next sync will overwrite them.
- `sync.sh` iterates `templates/*/`, so new templates pick up shared files
  automatically once the directory exists.

## Adding a template

1. Copy the skeleton from `shared/` into `templates/<name>/`.
2. Register it in the root `flake.nix` `templates` attrset.
3. Run `./scripts/sync.sh`.
4. Verify with `nix flake show` at the repo root, then test end-to-end:

   ```console
   $ nix flake new /tmp/test -t <path-to-this-repo>#<name>
   $ cd /tmp/test && nix flake check
   ```

## License

[AGPL-3.0](LICENSE)
