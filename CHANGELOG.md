# Changelog

All notable changes to this project will be documented in this file.

## [v1.0] - 2026-07-27

### Added
- Complete variable descriptions and input validations for `validation` method and Route53 `ttl`.
- Automatic Route53 record creation for DNS validation.
- Custom local certificate import capability.
- Subject Alternative Names (SANs) and wildcard domain support.
- GitHub Actions CI workflow for `terraform fmt` and `terraform validate` check ([fmt.yml](file://.github/workflows/fmt.yml)).
- GitHub Actions workflow for automated releases defaulting to `v1.0` ([release.yml](file://.github/workflows/release.yml)).
- Comprehensive `README.md` with usage examples, inputs, and outputs reference tables.
