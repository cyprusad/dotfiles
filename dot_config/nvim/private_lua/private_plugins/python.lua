return {

  -----------------------------------------------------------------------------
  -- 1. MASON: Manages external tools (LSPs, linters, formatters, debuggers)
  --    LazyVim already includes Mason, we're just extending its config
  -----------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- opts is the existing config from LazyVim
      -- We're adding to the ensure_installed list
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright", -- Python LSP (type checking, go-to-def, etc.)
        "ruff", -- Fast linter + formatter
        "debugpy", -- Python debugger
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
    branch = "regexp", -- Use the newer regexp branch
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
          -- Wait for mason-registry to be ready
          local mason_registry = require("mason-registry")
          -- Helper function to setup debugpy
          local function setup_debugpy()
            if not mason_registry.is_installed("debugpy") then
              vim.notify("debugpy not installed. Run :MasonInstall debugpy", vim.log.levels.WARN)
              return
            end
            local debugpy_package = mason_registry.get_package("debugpy")
            -- Method exists but mason.nvim lacks type annotations
            ---@diagnostic disable-next-line: undefined-field
            local debugpy_path = debugpy_package:get_install_path()
            local python_path = debugpy_path .. "/venv/bin/python"
            require("dap-python").setup(python_path)
          end
          -- mason-registry might not be ready immediately
          if mason_registry.refresh then
            mason_registry.refresh(setup_debugpy)
          else
            setup_debugpy()
          end
        end,
      },
    },
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
