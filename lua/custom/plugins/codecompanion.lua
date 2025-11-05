return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
    'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'codecompanion' },
      opts = {
        file_types = { 'markdown', 'codecompanion' },
        code = {
          enabled = true,
          sign = true,
          style = 'full',
          position = 'left',
          width = 'full',
        },
      },
    }, -- Optional: For prettier markdown rendering
    { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = function()
    -- Create a variable to track the current provider
    local current_provider = 'anthropic' -- Default provider

    local token_limit = 10000

    -- Function to get a complete config with the current provider
    local function get_config()
      return {
        prompt_library = {
          ['Programming'] = {
            strategy = 'chat',
            description = 'Programming and adjacent questions',
            opts = {
              index = 1,
              is_slash_cmd = true,
              auto_submit = false,
              short_name = 'programming',
            },
            prompts = {
              {
                role = 'system',
                content = [[You are a helpful coding assistant. Always format your code responses using markdown code blocks with explicit language identifiers, like ```python, ```javascript, ```csharp, etc. Be concise while still being thorough. Only give a maximum of three ways to solve a problem.]],
              },
            },
          },
          ['GeneralKnowledge'] = {
            strategy = 'chat',
            description = 'General, non-programming questions',
            opts = {
              index = 2,
              is_slash_cmd = true,
              auto_submit = false,
              short_name = 'gen_knowledge',
              ignore_system_prompt = true,
            },
            prompts = {
              {
                role = 'system',
                content = [[ You are a helpful assistant who answers generalized questions. If you are asked programming questions, or anything adjacent, tell the user to toggle the system prompt]],
              },
            },
          },
          ['Docusaurus'] = {
            strategy = 'chat',
            description = 'Write documentation for me',
            opts = {
              index = 3,
              is_slash_cmd = false,
              auto_submit = false,
              short_name = 'docs',
            },
            context = {
              {
                type = 'file',
                path = {
                  'doc/.vitepress/config.mjs',
                  'lua/codecompanion/config.lua',
                  'README.md',
                },
              },
            },
            prompts = {
              {
                role = 'user',
                content = [[I'm rewriting the documentation for my plugin CodeCompanion.nvim, as I'm moving to a vitepress website. Can you help me rewrite it?

I'm sharing my vitepress config file so you have the context of how the documentation website is structured in the `sidebar` section of that file.

I'm also sharing my `config.lua` file which I'm mapping to the `configuration` section of the sidebar.
]],
              },
            },
          },
        },
        language_servers = {
          roslyn = true,
          gopls = true,
        },
        filetypes = {
          'cs',
          'csharp',
          'go',
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
          ['```go'] = 'go',
          ['```golang'] = 'go',
        },
        markdown = {
          code_block_format = {
            c_sharp = '```csharp\n%s\n```',
            go = '```go\n%s\n```',
            golang = '```go\n%s\n```',
          },
        },
        strategies = {
          chat = {
            adapter = current_provider,
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
          chat = {
            window = {
              layout = 'vertical',
              border = 'single',
              height = 0.8,
              width = 0.45,
            },
            -- Ensure syntax highlighting is enabled
            render_headers = true,
          },
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
                text = '▌',
                reject = '✗',
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
                    default = 'claude-sonnet-4-5',
                  },
                  max_completion_tokens = {
                    default = token_limit,
                  },
                },
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
              })
            end,
          },
        },
      }
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'codecompanion',
      callback = function(args)
        local buf = args.buf

        -- Start markdown treesitter
        vim.treesitter.start(buf, 'markdown')

        -- Refresh highlighting after a short delay
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_call(buf, function()
              -- Force treesitter to re-parse with injections
              vim.treesitter.stop(buf)
              vim.treesitter.start(buf, 'markdown')
            end)
          end
        end, 100)
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

    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]
  end,
}
