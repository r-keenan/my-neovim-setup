return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
    'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } }, -- Optional: For prettier markdown rendering
    { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
    'Davidyz/VectorCode',
  },
  config = function()
    -- Create a variable to track the current provider
    local current_provider = 'anthropic' -- Default provider
    local sys_prompt =
      [[You are a helpful coding assistant. Always format your code responses using markdown code blocks with explicit language identifiers, like ```python, ```javascript, ```csharp, etc. Be concise while still being thorough. Only give a maximum of three ways to solve a problem.']]

    local token_limit = 10000

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'codecompanion',
      callback = function()
        vim.treesitter.start(0, 'markdown')
      end,
    })

    -- Function to get a complete config with the current provider
    local function get_config()
      return {
        language_servers = {
          roslyn = true,
        },
        filetypes = {
          'cs',
          'csharp',
        },
        language_mapping = {
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
          ['```php'] = 'php',
          ['```csharp'] = 'c_sharp',
          ['```cs'] = 'c_sharp',
          ['```c#'] = 'c_sharp',
        },
        markdown = {
          code_block_format = {
            c_sharp = '```csharp\n%s\n```',
          },
        },
        strategies = {
          chat = {
            adapter = current_provider,
            system_prompt = sys_prompt,
          },
          inline = {
            adapter = current_provider,
          },
          agent = {
            adapter = current_provider,
          },
          cmd = {
            adapter = current_provider,
          },
        },
        adapters = {
          anthropic = function()
            return require('codecompanion.adapters').extend('anthropic', {
              env = {
                api_key = 'cmd:op read op://personal/Anthropic/credential --no-newline',
              },
              schema = {
                model = {
                  default = 'claude-sonnet-4-20250514',
                },
                max_completion_tokens = {
                  default = token_limit,
                },
              },
              system_prompt = sys_prompt,
            })
          end,
          ollama = function()
            return require('codecompanion.adapters').extend('ollama', {
              name = 'codellama',
              env = {
                url = 'http://localhost:11434',
              },
              schema = {
                model = {
                  default = 'codellama:latest',
                },
              },
              system_prompt = sys_prompt,
            })
          end,
          openai = function()
            return require('codecompanion.adapters').extend('openai', {
              name = 'gpt',
              env = {
                api_key = 'cmd:op read op://personal/OpenAI-API-Key/credential --no-newline',
              },
              schema = {
                model = {
                  default = 'gpt-4',
                },
                max_completion_tokens = {
                  default = token_limit,
                },
              },
              system_prompt = sys_prompt,
            })
          end,
        },
      }
    end

    require('codecompanion').setup(get_config())

    vim.keymap.set('n', '<leader>cb', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'CodeCompanionActions' })
    vim.api.nvim_set_keymap('v', '<leader>cb', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'CodeCompanionActions' })
    vim.api.nvim_set_keymap('n', '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'toggle CodeCompanionChat window' })
    vim.api.nvim_set_keymap('v', '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'toggle CodeCompanionChat window' })
    vim.api.nvim_set_keymap(
      'v',
      '<leader>ac',
      '<cmd>CodeCompanionChat Add<cr>',
      { noremap = true, silent = true, desc = 'Add code to CodeCompanionChat window' }
    )

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
