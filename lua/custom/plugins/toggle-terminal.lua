-- set default terminal to powershell. Windows sets cmd as default otherwise.
if vim.fn.has 'win32' == 1 then
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
end

vim.pack.add{ 'https://github.com/akinsho/toggleterm.nvim'}


    require('toggleterm').setup {
      autochdir = true,
      start_in_insert = true,
      close_on_exit = true,
      size = 20,
      float_ops = {
        height = 20,
      }
}

vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', { desc = 'Open a horizontal terminal at the Desktop directory' })
