# mizuya

Shared Operata configs, consumed by other repos directly instead of through a git
submodule: a base [hk](https://github.com/jdx/hk) lint/hook config, distributed as a
[Pkl](https://pkl-lang.org) package, and a base [mise](https://mise.jdx.dev) toolchain
plus lint tasks.

Releases are tagged `v<version>`; see [`CHANGELOG.md`](CHANGELOG.md) for what changed in
each one.

## Usage

### hk config

In a consuming repo's `hk.pkl`:

```pkl
amends "package://github.com/operata/mizuya/releases/download/v0.1.0/mizuya@0.1.0#/hk/base.pkl"
```

Re-declaring `steps { }` in that file merges your repo's own stack-specific steps into
the shared base rather than replacing it. See [`hk.pkl`](hk.pkl) in this repo for an
example consumer.

### mise config + tasks

In a consuming repo's `mise.toml`, pull in the shared toolchain (hk + its linters) and
the `lint:check`/`lint:fix` tasks:

```toml
include = [
  "git::https://github.com/operata/mizuya.git//mise.toml?ref=v0.1.0",
]
[task_config]
includes = [
  "git::https://github.com/operata/mizuya.git//tasks?ref=v0.1.0",
]
```

Bump the `ref` to pick up a newer release of either.

## Development

Requires [mise](https://mise.jdx.dev). Install the pinned toolchain:

```sh
mise install
```

Lint/format checks run through [hk](https://github.com/jdx/hk):

```sh
mise run lint:check  # check
mise run lint:fix     # auto-fix
```

## Releases

Versioning and the `CHANGELOG.md` are managed by [knope](https://knope.tech) from
Conventional Commits. Every push to `main` opens/updates a `release` PR; merging it tags
the release and publishes the Pkl package to GitHub Releases. See `knope.toml` and
`.github/workflows/` for the full pipeline.
