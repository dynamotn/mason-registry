-- Checks every package of the registry against the shape Mason reads.
--
--   nvim --clean --headless -l tests/registry.lua
--
-- Needs nothing but Neovim. The server a package names under
-- `neovim.lspconfig` is not looked up: it may be one the configuration using
-- the registry defines itself, which only that configuration can check.
-- Exits non-zero when anything failed, listing every failure.

local root = vim.fs.dirname(
  vim.fs.dirname(vim.fs.normalize(vim.fn.fnamemodify(arg[0], ':p')))
)
local dir = vim.fs.joinpath(root, 'lua', 'dy-mason-registry')
vim.opt.runtimepath:prepend(root)

local failures, passed = {}, 0

--- Run one check and remember how it went
---@param name string
---@param fn fun()
local function check(name, fn)
  local ok, err = pcall(fn)
  if ok then
    passed = passed + 1
  else
    table.insert(failures, name .. ': ' .. tostring(err))
  end
end

--- Package files of the registry, by name
---@return string[]
local function package_names()
  local names = {}
  for name, kind in vim.fs.dir(dir) do
    local package = kind == 'file' and name:match('^(.+)%.lua$')
    if package and package ~= 'init' then table.insert(names, package) end
  end
  table.sort(names)
  return names
end

local names = package_names()

check('finds some packages', function() assert(#names > 0) end)

check('indexes every package file by its name', function()
  local index = require('dy-mason-registry')
  local expected = {}
  for _, name in ipairs(names) do
    expected[name] = 'dy-mason-registry.' .. name
  end
  assert(vim.deep_equal(expected, index), vim.inspect(index))
end)

local categories = {
  Compiler = true,
  DAP = true,
  Formatter = true,
  Linter = true,
  LSP = true,
  Runtime = true,
}
local targets = {
  darwin_arm64 = true,
  darwin_x64 = true,
  linux_arm64 = true,
  linux_x64 = true,
  linux_x64_gnu = true,
  linux_x64_musl = true,
  win_x64 = true,
  win_arm64 = true,
}

for _, name in ipairs(names) do
  local ok, spec = pcall(require, 'dy-mason-registry.' .. name)
  check(name .. ' loads', function() assert(ok, spec) end)
  if ok then
    check(
      name .. ' is named after its file',
      function() assert(spec.name == name, spec.name) end
    )

    check(name .. ' has a description, homepage and licenses', function()
      assert(type(spec.description) == 'string' and #spec.description > 0)
      assert(spec.homepage:match('^https://'), spec.homepage)
      assert(vim.islist(spec.licenses) and #spec.licenses > 0)
    end)

    check(name .. ' lists known categories and languages', function()
      assert(vim.islist(spec.languages))
      assert(#spec.categories > 0)
      for _, category in ipairs(spec.categories) do
        assert(categories[category], category)
      end
    end)

    -- A version always: a package without one installs whatever is latest,
    -- past any quarantine and never the same twice
    check(
      name .. ' has a versioned package URL',
      function()
        assert(spec.source.id:match('^pkg:[%w]+/[^@]+@.+$'), spec.source.id)
      end
    )

    check(name .. ' names its binaries at the top level', function()
      assert(type(spec.bin) == 'table' and vim.tbl_count(spec.bin) > 0)
      for bin, target in pairs(spec.bin) do
        assert(type(bin) == 'string' and type(target) == 'string', bin)
      end
    end)

    check(name .. ' has one asset per known target', function()
      local asset = spec.source.asset
      if asset == nil or not vim.islist(asset) then return end
      local seen = {}
      for _, entry in ipairs(asset) do
        assert(targets[entry.target], entry.target)
        assert(not seen[entry.target], 'duplicate ' .. entry.target)
        seen[entry.target] = true
        assert(type(entry.file) == 'string', entry.target)
      end
    end)
  end
end

check('derives the sonarlint asset from the tagged release', function()
  local spec = require('dy-mason-registry.sonarlint-language-server')
  local release = spec.source.id:match('@(.+)$'):match('^[^+]+')
  assert(spec.source.asset.file == 'sonarlint-vscode-' .. release .. '.vsix')
  assert(not spec.source.asset.file:find('+', 1, true))
end)

print(('%d passed, %d failed'):format(passed, #failures))
for _, failure in ipairs(failures) do
  io.stderr:write(failure .. '\n')
end
os.exit(#failures == 0 and 0 or 1)
