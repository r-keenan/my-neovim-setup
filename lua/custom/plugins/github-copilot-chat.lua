return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    opts = {
      debug = true,
    },
    keys = {
      { '<leader>ct', '<cmd>CopilotChatToggle<cr>', desc = 'CopilotChat - Toggle' },
    },
  },
}
