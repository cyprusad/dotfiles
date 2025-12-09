return {
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      -- minuet is only needed as a runtime dependency for the blink source
      "milanglacier/minuet-ai.nvim",
    },
    opts = {
      sources = {
        -- Put minuet first → it will win most of the time (exactly what you want for AI completions)
        default = { "minuet", "lsp", "snippets", "path", "dictionary", "buffer" },

        providers = {
          minuet = {
            name = "AI", -- shows up as “AI” in the menu
            module = "minuet.blink", -- official module name (2025)
            async = true, -- required for streaming cloud responses
            score_offset = 100, -- big boost so it beats LSP/snippets
            opts = {
              timeout_ms = 4000, -- generous for cloud latency
            },
          },

          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            min_keyword_length = 3,
            opts = {
              dictionary_files = {
                "/usr/share/dict/words",
                "/usr/share/dict/connectives",
                "/usr/share/dict/propernames",
              },
            },
          },
          buffer = {
            min_keyword_length = 3,
            max_items = 5,
            score_offset = -100,
          },
        },
      },

      completion = {
        ghost_text = { enabled = false }, -- you already disabled it → keep it
      },
      documentation = { auto_show = true },
    },
  },
}
