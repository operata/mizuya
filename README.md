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

For steps built from [hk's Builtins](https://github.com/jdx/hk), import
`hk/Builtins.pkl` from the same package/version instead of pinning `jdx/hk`'s package
URL yourself, so you stay on the hk version `base.pkl` was built against:

```pkl
import "package://github.com/operata/mizuya/releases/download/v0.1.0/mizuya@0.1.0#/hk/Builtins.pkl" as Builtins
```

### Stack packs

Each stack ships an opt-in hk steps fragment plus a matching mise tools fragment. Pull
in only the ones your repo needs; spread a fragment's `steps` into your own `hk.pkl`:

```pkl
amends "package://github.com/operata/mizuya/releases/download/v0.1.0/mizuya@0.1.0#/hk/base.pkl"
import "package://github.com/operata/mizuya/releases/download/v0.1.0/mizuya@0.1.0#/hk/github-actions.pkl" as GithubActions

steps {
  ...GithubActions.steps
}
```

```toml
include = [
  "git::https://github.com/operata/mizuya.git//mise/github-actions.toml?ref=v0.1.0",
]
```

A fragment may tag a slow/network-heavy step with `profiles = List("slow")` (see
`hk/go.pkl`'s full-ruleset `golangci-lint` step); `hk check`/`hk fix` skip those by
default, `hk check --slow`/`HK_PROFILE=slow` runs them. The shared `lint:check`/
`lint:fix` tasks (see below) already pass `--slow`, so nothing extra is needed to run
them via `mise run lint:check`.

Available stacks: `github-actions` (jactionlint), `go` (golangci-lint, go mod tidy —
govulncheck is pinned as a tool but left for you to wire into your own task, same as
other Go repos in Operata), `docker` (hadolint), `kubernetes` (kubeconform; helm and
flux2 pinned as tools).

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

Bump the `ref` to pick up a newer release of either. A stack's explicit `[tools]`
entries in your own `mise.toml` take precedence over the included fragment's, so a
shared version pin is a default you can override, not a floor.

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
