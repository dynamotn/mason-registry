--- A Mason registry of the tools `mason-org/mason-registry` lacks, or ships
--- in a form that does not fit: listed in Mason's `registries` setting as
--- `lua:dy-mason-registry`, ahead of the upstream one so that its packages win
--- where both have one.
---
--- Mason asks this index for a package name and requires the module it maps
--- to. Every other file of this folder is one package, named after its file.
local M = {}

-- The directory of this very file, not a runtimepath lookup: another copy on
-- the runtimepath (a dev checkout beside the installed one) must not mix in
local scan_path = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))

for name, kind in vim.fs.dir(scan_path) do
  local package = kind == 'file' and name:match('^(.+)%.lua$')
  if package and package ~= 'init' then
    M[package] = 'dy-mason-registry.' .. package
  end
end

return M
