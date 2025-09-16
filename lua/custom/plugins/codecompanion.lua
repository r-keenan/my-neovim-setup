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

    -- Define multiple system prompts
    local system_prompts = {
      programming = [[You are a helpful coding assistant. Always format your code responses using markdown code blocks with explicit language identifiers, like ```python, ```javascript, ```csharp, etc. Be concise while still being thorough. Only give a maximum of three ways to solve a problem.]],
      generic_knowledge = [[ You are a helpful assistant who answers generalized questions. If you are asked programming questions, or anything adjacent, tell the user to toggle the system prompt]],
    }

    -- Track current system prompt
    local current_system_prompt = 'programming'

    local token_limit = 10000

    -- Function to get current system prompt
    local function get_current_system_prompt()
      return system_prompts[current_system_prompt]
    end

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
            system_prompt = get_current_system_prompt(),
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
        display = {
          diff = {
            enabled = true,
            provider = mini_diff,
            close_chat_at = 240,

            -- Options for the split diff provider
            layout = 'vertical',
            opts = {
              'internal',
              'filler',
              'closeoff',
              'algorithm:histogram', -- https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/
              'indent-heuristic', -- https://blog.k-nut.eu/better-git-diffs
              'followwrap',
              'linematch:120',
            },

            diff_signs = {
              signs = {
                text = '▌', -- Sign text for normal changes
                reject = '✗', -- Sign text for rejected changes in super_diff
                highlight_groups = {
                  addition = 'DiagnosticOk',
                  deletion = 'DiagnosticError',
                  modification = 'DiagnosticWarn',
                },
              },
              -- Super Diff options
              icons = {
                accepted = ' ',
                rejected = ' ',
              },
              colors = {
                accepted = 'DiagnosticOk',
                rejected = 'DiagnosticError',
              },
            },
          },
        },
        adapters = {
          http = {
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
                system_prompt = get_current_system_prompt(),
              })
            end,
            openai = function()
              return require('codecompanion.adapters').extend('openai', {
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
                system_prompt = get_current_system_prompt(),
              })
            end,
            xai = function()
              return require('codecompanion.adapters').extend('xai', {
                env = {
                  api_key = 'cmd:op read op://personal/Grok-API-Key/credential --no-newline',
                },
                schema = {
                  model = {
                    default = 'grok-4-0709',
                  },
                  max_completion_tokens = {
                    default = token_limit,
                  },
                },
                system_prompt = get_current_system_prompt(),
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
                system_prompt = get_current_system_prompt(),
              })
            end,
          },
        },
      }
    end

    -- Function to switch system prompt
    local function switch_system_prompt(prompt_name)
      if system_prompts[prompt_name] then
        current_system_prompt = prompt_name
        -- Reconfigure CodeCompanion with new prompt
        require('codecompanion').setup(get_config())
        print('CodeCompanion: Switched to "' .. prompt_name .. '" system prompt')
      else
        print('CodeCompanion: Unknown system prompt "' .. prompt_name .. '"')
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'codecompanion',
      callback = function()
        vim.treesitter.start(0, 'markdown')
      end,
    })

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

    -- Keybindings for switching system prompts
    vim.keymap.set('n', '<leader>cp1', function()
      switch_system_prompt 'programming'
    end, { noremap = true, silent = true, desc = 'CodeCompanion: Programming prompt' })

    vim.keymap.set('n', '<leader>cp2', function()
      switch_system_prompt 'generic_knowledge'
    end, { noremap = true, silent = true, desc = 'CodeCompanion: Generic knowleged prompt' })

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
