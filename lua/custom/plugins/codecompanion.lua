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
          omnisharp = true,
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
            slash_commands = {
              codebase = require('vectorcode.integrations').codecompanion.chat.make_slash_command(),
            },
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
                  default = 'claude-3-7-sonnet-latest',
                },
              },
            })
          end,
          ollama = function()
            return require('codecompanion.adapters').extend('ollama', {
              -- Any custom configuration for Ollama if needed
              --{
              name = 'codellama', -- Give this adapter a different name to differentiate it from the default ollama adapter
              env = {
                url = 'http://localhost:11434',
              },
              schema = {
                model = {
                  default = 'codellama:latest',
                },
              },
              system_prompt = [[You are a helpful coding assistant. Always format your code responses using markdown code blocks with explicit language identifiers, like ```python, ```javascript, ```csharp, etc.]],
            })
          end,
        },
      }
    end

    -- Function to update provider config
    local function update_provider_config()
      require('codecompanion').setup(get_config())
      vim.notify('CodeCompanion is now using ' .. current_provider, vim.log.levels.INFO)
    end

    -- Toggle function to switch between providers
    local function toggle_llm_provider()
      current_provider = current_provider == 'anthropic' and 'ollama' or 'anthropic'
      update_provider_config()
    end

    -- Register command to toggle provider
    vim.api.nvim_create_user_command('CodeCompanionToggleProvider', toggle_llm_provider, {})

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
    -- Add keybinding for toggling provider
    vim.keymap.set('n', '<leader>ct', '<cmd>CodeCompanionToggleProvider<cr>', { noremap = true, silent = true, desc = 'Toggle LLM provider' })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
