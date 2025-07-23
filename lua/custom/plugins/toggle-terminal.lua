-- set default terminal to powershell. Windows sets cmd as default otherwise.
local powershell_options = {
  shell = vim.fn.executable 'pwsh' == 1 and 'pwsh' or 'powershell',
  shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
  shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait',
  shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
  shellquote = '',
  shellxquote = '',
}

for option, value in pairs(powershell_options) do
  vim.opt[option] = value
end

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Open a horizontal terminal at the Desktop directory' },
  },
  config = function()
    require('toggleterm').setup {
      autochdir = true,
      start_in_insert = true,
      close_on_exit = true,
      size = 20,
      float_ops = {
        height = 20,
      },
    }
  end,
}
