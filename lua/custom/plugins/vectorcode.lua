return {
  'Davidyz/VectorCode',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = 'VectorCode',
  build = 'uv tool upgrade vectorcode',
}
