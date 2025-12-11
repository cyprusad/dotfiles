return {
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      "milanglacier/minuet-ai.nvim",
    },
    opts = {
      sources = {
        default = function(ctx)
          if vim.bo.filetype == "markdown" then
            return { "lsp", "snippets", "path", "dictionary", "buffer" }
          else
            return { "minuet", "lsp", "snippets", "path", "dictionary", "buffer" }
          end
        end,

        providers = {
          minuet = {
            name = "minuet", -- Changed to "minuet" so source_icon lookup works
            module = "minuet.blink",
            async = true,
            score_offset = 100,
            timeout_ms = 4000,
          },
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            min_keyword_length = 3,
            opts = {
              dictionary_files = {
                vim.fn.expand("~/.config/nvim/dict/common-words.txt"),
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

        -- Add this filetype-specific configuration
        filetype = {
          markdown = { "lsp", "snippets", "path", "dictionary", "buffer" }, -- Same as default but without minuet
        },
      },

      -- Appearance settings for kind icons (the icon showing WHAT type of completion)
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
        -- These show the LLM provider (Claude, OpenAI, etc.)
        kind_icons = {
          claude = "󰋦",
          openai = "󱢆",
          codestral = "󱎥",
          gemini = "",
          Groq = "",
          Openrouter = "󱂇",
          Ollama = "󰳆",
          ["Llama.cpp"] = "󰳆",
          Deepseek = "",
        },
      },

      completion = {
        ghost_text = { enabled = false },
        trigger = {
          prefetch_on_insert = false,
        },
        -- Menu draw settings for source icons (the icon showing WHERE completion came from)
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" }, -- Shows provider icon + name (e.g., 󱂇 Openrouter)
              { "source_icon" }, -- Shows source icon (e.g., 󱗻 for minuet)
            },
            components = {
              source_icon = {
                ellipsis = false,
                text = function(ctx)
                  -- Map source names to icons
                  local source_icons = {
                    minuet = "󱗻", -- AI source
                    lsp = "", -- Language server
                    snippets = "", -- Snippets
                    path = "", -- File paths
                    Dict = "󰘝", -- Dictionary (matches blink-cmp-dictionary)
                    buffer = "", -- Buffer words
                    -- Fallback for unknown sources
                    -- fallback = "󰜚",
                  }
                  -- Lowercase the source name for consistent matching
                  return source_icons[ctx.source_name:lower()] or source_icons.fallback
                end,
                highlight = "BlinkCmpSource",
              },
            },
          },
        },
      },
    },
  },
}
