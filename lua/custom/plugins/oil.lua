return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function()
      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<M-h>'] = 'actions.select_split',
        },
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 2,
          max_width = 0.5,
          max_height = 0,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
          get_win_title = nil,
          preview_split = 'auto',
          override = function(conf)
            return conf
          end,
        },
        preview = {
          width = 0.4,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
          update_on_cursor_moved = true,
        },
        keymaps_help = {
          border = 'rounded',
        },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

      vim.keymap.set('n', '<leader>b', require('oil').toggle_float, { desc = 'Toggle Oil floating window' })
      --[[
      vim.keymap.set('n', '<leader>bp', function()
        local current_path = vim.fn.expand '%:h'
        vim.fn.setreg('+', current_path)
        vim.notify('Copied directory path to clipboard: ' .. current_path)
      end, { desc = 'Copy directory path to clipboard' })
      ]]
      --
    end,
  },
}
