return {
  {
    "kevalin/mermaid.nvim",
    ft = { "mermaid" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      lint = {
        enabled = vim.fn.executable("mmdc") == 1,
      },
    },
    config = function(_, opts)
      require("mermaid").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mermaid",
        callback = function(args)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end

          map("<leader>Mp", "<cmd>MermaidPreview<cr>", "Mermaid Preview")
          map("<leader>Mf", "<cmd>MermaidFormat<cr>", "Mermaid Format")
          map("<leader>Mr", "<cmd>MermaidRender<cr>", "Mermaid Render")
          map("<leader>Mc", "<cmd>MermaidCopyURL<cr>", "Mermaid Copy URL")
          map("<leader>Mx", "<cmd>MermaidPreviewStop<cr>", "Mermaid Stop Preview")
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "mermaid" })
    end,
  },
}
