return {
  "milanglacier/minuet-ai.nvim",
  event = { "InsertEnter", "VeryLazy" }, -- Load on insert for completions
  lazy = false, -- Eager for responsiveness:
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required (already in LazyVim)
  },
  keys = {
    {
      "<leader>mt",
      function()
        -- Check current status first
        local initial_status = require("minuet").config.blink.enable_auto_complete
        vim.cmd("Minuet blink toggle")

        -- Use a delay and verify the toggle worked
        vim.defer_fn(function()
          local new_status = require("minuet").config.blink.enable_auto_complete

          if new_status == initial_status then
            vim.notify("Toggle failed - status unchanged: " .. tostring(new_status), vim.log.levels.WARN)
          else
            local state = new_status and "enabled" or "disabled"
            vim.notify("Minuet autocompletion: " .. state, vim.log.levels.INFO)
          end
        end, 50)
      end,
      desc = "Toggle Minuet autocompletion",
    },
    {
      "<leader>mm",
      function()
        -- Opens interactive model selection menu
        vim.cmd("Minuet change_model")
      end,
      desc = "Minuet: select model",
    },
    {
      "<leader>md",
      function()
        vim.cmd("Minuet change_model openai_compatible:moonshotai/kimi-k2")
        vim.notify("Minuet: OpenRouter kimi-k2", vim.log.levels.INFO)
      end,
      desc = "Minuet: default (kimi-k2)",
    },
    {
      "<leader>mf",
      function()
        vim.cmd("Minuet change_model claude:claude-3-haiku-20240307")
        vim.notify("Minuet: Claude Haiku fallback", vim.log.levels.INFO)
      end,
      desc = "Minuet: Claude fallback",
    },
  },
  opts = {
    -- Default provider: OpenRouter (primary)
    provider = "openai_compatible",
    provider_options = {
      openai_compatible = {
        api_key = "OPENROUTER_API_KEY", -- Pulls from env
        end_point = "https://openrouter.ai/api/v1/chat/completions",
        model = "moonshotai/kimi-k2", -- swap as needed
        name = "OpenRouter",
        optional = {
          max_tokens = 128, -- Short for quick code blocks
          top_p = 0.9,
          temperature = 0.2, -- Precise for code
          provider = { sort = "throughput" }, -- OpenRouter opt for fastest models
        },
      },
    },
    -- Presets for fallback (Claude Haiku)
    presets = {
      claude_fallback = {
        provider = "claude",
        provider_options = {
          claude = {
            model = "claude-3-haiku-20240307", -- Haiku model ID
            api_key = "ANTHROPIC_API_KEY", -- Pulls from env
            end_point = "https://api.anthropic.com/v1/messages",
            stream = true,
            optional = {
              max_tokens = 128,
              temperature = 0.2,
              top_p = 0.9,
            },
          },
        },
      },
    },
    -- Frontend: Use blink.cmp (no virtual text needed)
    frontend = "blink",

    -- Context: Balance speed/quality
    context_window = 4000, -- ~1k tokens; smaller = faster cloud calls
    -- Completions: Single suggestion (Copilot-style)
    n_completions = 1,
    -- LSP integration for context (symbols/diagnostics)
    lsp = {
      disabled_ft = { "*" },
      -- enabled_auto_trigger_ft = { "python", "lua", "javascript", "rust", "cpp", "typescript" },
    },

    -- System prompt for code focus
    system_prompt = "You are an expert code completion assistant. Generate concise, syntactically correct code snippets that fit seamlessly into the existing context. Do not explain or add comments unless requested.",
  },
  config = function(_, opts)
    require("minuet").setup(opts)
    -- Register LSP for extra context
    require("minuet.lsp").setup()
  end,
}
