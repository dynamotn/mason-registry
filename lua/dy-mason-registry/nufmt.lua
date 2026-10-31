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
    id = 'pkg:cargo/nufmt@3dfd39c1499f065285052d0324541b8c26870e57?repository_url=https://github.com/nushell/nufmt&rev=true',
  },
  bin = {
    nufmt = 'cargo:nufmt',
  },
}
