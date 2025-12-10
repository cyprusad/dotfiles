return {
  "milanglacier/minuet-ai.nvim",
  event = { "InsertEnter", "VeryLazy" }, -- Load on insert for completions
  lazy = false, -- Eager for responsiveness:
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required (already in LazyVim)
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

    -- Auto-trigger on code filetypes
    auto_trigger_ft = {
      "python",
      "lua",
      "javascript",
      "rust",
      "ruby",
      "cpp",
      "typescript",
      "typescriptreact",
      "javascriptreact",
      "go",
      "c",
    }, -- Customize
    -- Context: Balance speed/quality
    context_window = 4000, -- ~1k tokens; smaller = faster cloud calls
    -- Completions: Single suggestion (Copilot-style)
    n_completions = 1,
    -- LSP integration for context (symbols/diagnostics)
    lsp = {
      enabled = true,
      enabled_auto_trigger_ft = { "python", "lua", "javascript", "rust", "cpp" },
    },
    -- Keymaps: Minimal; rely on blink's Tab for accept
    -- TODO: I don't think these do anything right now, fix these or remove them
    keymap = {
      toggle = "<leader>mt", -- :MinuetToggle
      change_preset = "<leader>mp", -- e.g., <leader>mp claude_fallback
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
