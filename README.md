# mason-registry

A [Mason](https://github.com/mason-org/mason.nvim) registry of the tools
[`mason-org/mason-registry`](https://github.com/mason-org/mason-registry)
does not have yet, or ships in a form that does not fit (a server name
nvim-lspconfig does not know, a release that lags). It is the registry of
[DyNeo](https://github.com/dynamotn/dyneo), kept apart so that a package can
live here until it is sent upstream.

Packages are Lua tables in the shape of Mason's `package.yaml`, one file each
under `lua/dy-mason-registry/`. Mason reads them through its `lua:` registry
source, so nothing has to be built or released.

## Use

With lazy.nvim, as a dependency of mason.nvim, listed ahead of the upstream
registry so that a package here wins where both have one:

```lua
{
  'mason-org/mason.nvim',
  dependencies = { 'dynamotn/mason-registry' },
  opts = {
    registries = {
      'lua:dy-mason-registry',
      'github:mason-org/mason-registry',
    },
  },
}
```

## Packages

Every package pins a version in its purl: one without would install whatever
is newest, past any quarantine and never the same twice. A commit stands in
for a release when the project has none (`nufmt`) or its last release
predates fixes that are needed (`promql-langserver`).

A few packages override one of the same name upstream, each for a reason:

| Package                     | Why it is here                                       |
|-----------------------------|------------------------------------------------------|
| `sonarlint-language-server` | a newer release than upstream                        |
| `termux-language-server`    | named for the `termuxls` server                      |
| `terragrunt-ls`             | built from source, named for the `terragruntls` server |
| `yls-yara`                  | names the `yls` server, which upstream leaves out    |

A server named under `neovim.lspconfig` may be one the configuration defines
itself rather than one nvim-lspconfig ships.

[Renovate](renovate.json) bumps the purls, after a week of quarantine for the
datasources that date their releases.

## Develop

```sh
nvim --clean --headless -l tests/registry.lua   # the shape of every package
stylua --check .
prek run --all-files                            # both, and the usual hooks
```

A new package is a file named after it, with a versioned purl, its binaries
under `bin`, and an asset per target when the release ships several.

## License

[MIT](LICENSE)
