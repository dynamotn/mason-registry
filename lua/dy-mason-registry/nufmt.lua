return {
  name = 'nufmt',
  description = 'The formatter for Nushell',
  homepage = 'https://github.com/nushell/nufmt',
  licenses = {
    'MIT',
  },
  languages = {
    'Nushell',
  },
  categories = {
    'Formatter',
  },
  -- Not on crates.io and never tagged, so a commit of its repository is
  -- pinned; building it needs `cargo`, which dytoy installs (`dytoy --tool
  -- rust`)
  source = {
    id = 'pkg:cargo/nufmt@13f2f8c3873ae73ba7e95e5e8fd4bdac6c019f5f?repository_url=https://github.com/nushell/nufmt&rev=true',
  },
  bin = {
    nufmt = 'cargo:nufmt',
  },
}
