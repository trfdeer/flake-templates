# AGENTS.md

## What this repo is

A Nix flake template collection. The root `flake.nix` exposes `templates.<name>`; each template lives in `templates/<name>/` and is copied verbatim by `nix flake init/new` — templates are data, not evaluated as flakes.

## Shared files must be synced, not edited in place

- Files used by every template are maintained once under `shared/` (e.g. `shared/.github/workflows/`). The `shared/` tree mirrors the layout of each template — including the template's own `flake.nix` and `nix/` modules.
- After editing anything in `shared/`, run `./scripts/sync.sh` to copy it into every template. Never edit the generated copies inside `templates/*/` directly — the next sync will overwrite them.
- `sync.sh` iterates `templates/*/`, so new templates pick up shared files automatically once the directory exists.

## Template architecture (flake-parts + import-tree)

- Template flakes call `inputs.import-tree ./nix`: every `.nix` file under `nix/` is auto-loaded as a flake-parts module. Add features as new modules there; no import list to maintain.
- `nix/system.nix` owns global config: `systems` is pinned to `x86_64-linux` only, and the nixpkgs instance gets an `unstable` overlay (`inputs.nixpkgsUnstable`, used as `pkgs.unstable`) with `allowUnfree` enabled.
- `nix/devshell.nix` defines the dev shell (`nix develop`, direnv `.envrc` included) — currently `nixd` and `nixfmt`. Format Nix with `nixfmt`.

## Adding a template

Use the `add-template` skill (`.opencode/skills/add-template/SKILL.md`): copy the skeleton from `shared/`, register it in the root `flake.nix` `templates` attrset (nothing automates this step), run `sync.sh`, and verify with `nix flake show` plus an end-to-end `nix flake new` test.

## Verifying changes

- `nix flake show` at the repo root must list every template in `templates/` (the root flake's `outputs = { self }: ...` — no inputs, so no lockfile).
- Test a template end-to-end: `nix flake new /tmp/test -t <path-to-this-repo>#<name>`, then `nix flake check` inside the generated project.
- Templates ship without `flake.lock` (`.gitignore` excludes `*/flake.lock`); don't commit lockfiles from template dirs.

## Conventions

- 2-space indent, LF, final newline (`.editorconfig`).
