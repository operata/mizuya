# Changelog

## 0.3.1 (2026-11-13)

### Features

- update dependency hk to v2.12.0 (#61)
- update dependency pkl to v0.33.0 (#57)
- update dependency tflint to v0.66.0 (#59)
- update dependency tombi to v1.11.2 (#60)
- update dependency jactionlint to v2.6.0 (#56)
- update dependency github:knope-dev/knope to v0.24.0 (#69)
- update dependency github:owenlamont/ryl to v0.29.0 (#55)

### Fixes

- update dependency go to v1.27.4 (#62)
- update dependency terraform to v1.17.2 (#67)
- update dependency ruff to v0.17.5 (#52)
- update dependency helm to v4.3.2 (#64)
- update dependency trivy to v0.76.2 (#53)
- update dependency ty to v0.0.103 (#54)
- update dependency uv to v0.13.8 (#68)
- update dependency rumdl to v0.3.4 (#66)
- update dependency ty to v0.0.104 (#71)

## 0.3.0 (2026-11-04)

### Breaking Changes

- upgrade mise tools and hk to latest (#25)

### Features

- run helm checks per values.*.yaml overlay (#26)
- add basic ruff, ruff-format and ty support (#27)
- upgrade tooling dependencies to latest (#34)
- update dependency hk to v2.11.1 (#45)
- update dependency tombi to v1.10.0 (#51)

### Fixes

- update dependency tombi to v1.9.9 (#41)
- update dependency ty to v0.0.96 (#42)
- update dependency uv to v0.13.7 (#43)
- update dependency ty to v0.0.97 (#50)

## 0.2.2 (2026-10-28)

### Features

- exclude helm templates, tmpl yaml and openapi from ryl (#23)

## 0.2.1 (2026-10-27)

### Features

- exclude agent markdown from linting, add helm steps (#20)

### Fixes

- exclude the helm chart definition and values from kubeconform linting (#22)

## 0.2.0 (2026-10-26)

### Breaking Changes

- move stack configs into per-stack dirs (#13)

### Features

- add kubernetes stack pack (#14)
- add terraform stack pack (#15)

## 0.2.0-alpha.1 (2026-10-26)

### Breaking Changes

- move stack configs into per-stack dirs (#13)

### Features

- add kubernetes stack pack (#14)
- add terraform stack pack (#15)

### Fixes

- ship per-stack hk.pkl files in the package

## 0.2.0-alpha.0 (2026-10-26)

### Breaking Changes

- move stack configs into per-stack dirs (#13)

### Features

- add kubernetes stack pack (#14)
- add terraform stack pack (#15)

## 0.1.3 (2026-10-21)

### Fixes

- allow parallel golangci-lint runs across workspace modules (#11)

## 0.1.2 (2026-10-20)

### Features

- pin shared hk Builtins version via local facade module (#5)
- add github-actions stack pack (#6)
- add go stack pack (#7)
- add docker stack pack (#8)

## 0.1.1 (2026-10-19)

### Features

- distribute hk config as a pkl package with knope releases (#1)
