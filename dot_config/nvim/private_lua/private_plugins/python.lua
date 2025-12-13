return {

  -----------------------------------------------------------------------------
  -- 1. MASON: Manages external tools (LSPs, linters, formatters, debuggers)
  --    LazyVim already includes Mason, we're just extending its config
  -----------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- opts is the existing config from LazyVim
      -- We're adding to the ensure_installed list
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright", -- Python LSP (type checking, go-to-def, etc.)
        "ruff", -- Fast linter + formatter
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- 2. LSP CONFIGURATION: How Neovim talks to language servers
  --    The LSP provides: autocomplete, go-to-definition, hover docs, etc.
  -----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              lineLength = 88,
              fixAll = true,
              organizeImports = true,
            },
          },
        },
      },
    },
    init = function()
      -- Disable Ruff hover in favor of Pyright
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- 3. FORMATTING: Ensure files are formatted on save
  --    LazyVim uses conform.nvim for formatting
  -----------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" }, -- Use Ruff for formatting
      },
    },
  },

  -----------------------------------------------------------------------------
  -- 4. LINTING: Additional linting beyond LSP diagnostics
  --    LazyVim uses nvim-lint for extra linters
  -----------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" }, -- Ruff for linting too
      },
    },
  },

  -----------------------------------------------------------------------------
  -- 5. TREESITTER: Syntax highlighting and code understanding
  --    Makes sure Python parser is installed
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "python",
        "toml", -- For pyproject.toml
        "rst", -- For docstrings
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- 6. VIRTUAL ENVIRONMENT SELECTOR: Switch between venvs easily
  --    Critical for Python development!
  -----------------------------------------------------------------------------
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python", -- Optional: for debugging
    },
    cmd = "VenvSelect", -- Lazy load until command is used
    ft = "python", -- Or when opening Python files
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
    },
    opts = {
      dap_enabled = true,
      settings = {
        search = {
          -- Where to look for venvs
          my_venvs = {
            command = "fd 'python$' ~/.venv --full-path --color never",
          },
          -- Look for .venv in project directories
          project_venvs = {
            command = "fd 'python$' . --full-path --color never -d 3",
          },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- 7. DEBUGGING (Optional but powerful)
  --    Press <leader>d to access debug commands in LazyVim
  -----------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        keys = {
          {
            "<leader>dPt",
            function()
              require("dap-python").test_method()
            end,
            desc = "Debug Method",
          },
          {
            "<leader>dPc",
            function()
              require("dap-python").test_class()
            end,
            desc = "Debug Class",
          },
        },
        config = function()
          -- Use the venv's debugpy if available, otherwise fall back to a working python
          -- venv-selector will override this automatically when dap_enabled = true
          local path = vim.fn.stdpath("data") .. "/venv-selector-debugpy-fallback/bin/python"
            or vim.fn.exepath("python3")
            or vim.fn.exepath("python")

          require("dap-python").setup(path)

          -- Optional: nicer test runner settings
          require("dap-python").test_runner = "pytest"
        end,
      },
    },
    config = function() end, -- dap itself needs no config in LazyVim
  },

  -----------------------------------------------------------------------------
  -- 8. TESTING (Optional)
  --    Neotest provides a nice UI for running tests
  -----------------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = function()
            -- Use the venv's Python
            return vim.fn.getcwd() .. "/.venv/bin/python"
          end,
        },
      },
    },
  },
}
