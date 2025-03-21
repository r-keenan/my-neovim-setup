return {
  'Ramilito/kubectl.nvim',
  opts = {},
  cmd = { 'Kubectl', 'Kubectx', 'Kubens' },
  keys = {
    { '<leader>K', '<cmd>lua require("kubectl").toggle()<cr>' },
    { '<C-K>', '<Plug>(kubectl.kill)', ft = 'k8s_*' },
    { '7', '<Plug>(kubectl.view_nodes)', ft = 'k8s_*' },
    { '8', '<Plug>(kubectl.view_overview)', ft = 'k8s_*' },
    { '<C-T>', '<Plug>(kubectl.view_top)', ft = 'k8s_*' },
  },
}
