return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>lg',
      '<cmd>LazyGit<cr>',
      function()
        require('lazygit-confirm').confirm()
      end,
      { noremap = true },
      desc = 'Open lazy git',
    },
  },
}
