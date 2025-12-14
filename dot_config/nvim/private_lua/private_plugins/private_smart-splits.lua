return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = {
    -- Ghostty doesn't have native smart-splits support yet,
    -- so we'll use the default multiplexer detection
    -- or explicitly set it to false to only navigate within nvim
    at_edge = "stop", -- or "wrap" or "split"
  },
  keys = {
    -- Navigation
    {
      "<C-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      desc = "Move to left window",
    },
    {
      "<C-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      desc = "Move to below window",
    },
    {
      "<C-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      desc = "Move to above window",
    },
    {
      "<C-l>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      desc = "Move to right window",
    },
    -- Resizing (bonus - very useful)
    {
      "<A-h>",
      function()
        require("smart-splits").resize_left()
      end,
      desc = "Resize left",
    },
    {
      "<A-j>",
      function()
        require("smart-splits").resize_down()
      end,
      desc = "Resize down",
    },
    {
      "<A-k>",
      function()
        require("smart-splits").resize_up()
      end,
      desc = "Resize up",
    },
    {
      "<A-l>",
      function()
        require("smart-splits").resize_right()
      end,
      desc = "Resize right",
    },
    -- Swapping buffers (bonus)
    {
      "<leader>wh",
      function()
        require("smart-splits").swap_buf_left()
      end,
      desc = "Swap buffer left",
    },
    {
      "<leader>wj",
      function()
        require("smart-splits").swap_buf_down()
      end,
      desc = "Swap buffer down",
    },
    {
      "<leader>wk",
      function()
        require("smart-splits").swap_buf_up()
      end,
      desc = "Swap buffer up",
    },
    {
      "<leader>wl",
      function()
        require("smart-splits").swap_buf_right()
      end,
      desc = "Swap buffer right",
    },
  },
}
