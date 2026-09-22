---
name: Add Template
description: Add a new Nix flake template to this repo — create it from shared/, register it in the root flake, sync, and verify
---

# Adding a template

Follow every step in order; steps 2, 4, and 5 are commonly forgotten.

## 1. Create the template directory

Copy the skeleton from `shared/` — it mirrors the full layout of a template:

```sh
cp -r shared/. templates/<name>/
```

Include `flake.nix`, `nix/`, `.envrc`, and `.github/`. The template's own `flake.nix` is a shared file — do not hand-maintain it.

## 2. Register the template in the root flake

Add an entry to the `templates` attrset in the root `flake.nix` — nothing automates this step:

```nix
templates.<name> = {
  path = ./templates/<name>;
  description = "...";
};
```

## 3. Sync shared files

Run `./scripts/sync.sh` from the repo root. It copies `shared/` into every template, including the new one, and reports any drift.

## 4. Verify

- `nix flake show` at the repo root must list the new template.
- End-to-end test:

```sh
nix flake new /tmp/test-<name> -t <path-to-this-repo>#<name>
cd /tmp/test-<name>
nix flake check
```

## 5. Clean up

Never commit `flake.lock` from a template directory — `.gitignore` excludes `*/flake.lock`, but delete any lockfile generated during testing before committing.
