local function shorter_name(name)
  -- Basic implementation that removes common prefixes/suffixes
  return name:gsub('^%.?/?', ''):gsub('/bin/python', '')
end

return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    'mfussenegger/nvim-dap-python', --optional
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  lazy = false,
  branch = 'regexp',
  keys = {

    -- Keymap to open VenvSelector to pick a venv.
    { '<leader>vs', '<cmd>VenvSelect<cr>' },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
  },
  opts = {
    options = {
      search_timeout = 60,
      on_telescope_result_callback = shorter_name,
    },
    search = {
      my_venvs = {
        command = 'fd --type directory --no-ignore "(venv|.venv)/bin/(python|pythhon3)$" ~/dev',
        -- If you put the callback here, its only called for your "my_venvs" search
        on_telescope_result_callback = shorter_name,
      },
    },
  },
}
