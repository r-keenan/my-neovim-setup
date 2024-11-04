return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
    'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
    { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = function()
    require('codecompanion').setup {
      -- Add language mapping for Anthropic responses
      language_mapping = {
        ['```csharp'] = 'csharp',
        ['```lua'] = 'lua',
        ['```python'] = 'python',
        ['```javascript'] = 'javascript',
        ['```typescript'] = 'typescript',
        ['```json'] = 'json',
        ['```bash'] = 'bash',
        ['```html'] = 'html',
        ['```css'] = 'css',
        ['```yaml'] = 'yaml',
        ['```sql'] = 'sql',
        ['```markdown'] = 'markdown',
      },
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'anthropic',
        },
        agent = {
          adapter = 'anthropic',
        },
      },
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = 'cmd:op read op://personal/Anthropic/credential --no-newline',
            },
          })
        end,
      },
    }
  end,

  vim.keymap.set('n', '<leader>cb', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'CodeCompanionActions' }),
  vim.api.nvim_set_keymap('v', '<leader>cb', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'CodeCompanionActions' }),
  vim.api.nvim_set_keymap('n', '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'toggle CodeCompanionChat window' }),
  vim.api.nvim_set_keymap('v', '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'toggle CodeCompanionChat window' }),
  vim.api.nvim_set_keymap(
    'v',
    '<leader>ac',
    '<cmd>CodeCompanionChat Add<cr>',
    { noremap = true, silent = true, desc = 'Add code to CodeCompanionChat window' }
  ),

  -- Expand 'cc' into 'CodeCompanion' in the command line
  vim.cmd [[cab cc CodeCompanion]],
}
