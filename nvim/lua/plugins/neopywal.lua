return {
  "RedsXDD/neopywal.nvim",
  name = "neopywal",
  lazy = false,
  priority = 1000,
  --   config = function()
  --     require("neopywal").setup({
  --       use_wallust = false,
  --       -- colorscheme_file = os.getenv("HOME") .. "/.cache/wal/colors-wal.vim",
  --       colorscheme_file = vim.fn.expand("~/.cache/wal/colors-wal.vim"),
  --       use_palette = "",
  --       transparent_background = true,
  --       custom_colors = {},
  --       custom_highlights = {},
  --       dim_inactive = true,
  --       terminal_colors = true,
  --       show_end_of_buffer = false,
  --       show_split_lines = true,
  --       no_italic = false,
  --       no_bold = false,
  --       no_underline = false,
  --       no_undercurl = false,
  --       no_strikethrough = false,
  --       styles = {
  --         comments = { "italic" },
  --         conditionals = { "italic" },
  --         loops = {},
  --         functions = {},
  --         keywords = {},
  --         includes = { "italic" },
  --         strings = {},
  --         variables = { "italic" },
  --         numbers = {},
  --         booleans = {},
  --         types = { "italic" },
  --         operators = {},
  --       },
  --       default_fileformats = true,
  --       default_plugins = true,
  --     })
  --     -- vim.cmd.colorscheme("neopywal")
  --     --
  --
  --     vim.schedule(function()
  --       vim.cmd.colorscheme("neopywal")
  --     end)
  --   end,
  -- }
  --
  --
  --
  config = function()
    local orig_notify = vim.notify
    vim.notify = function(msg, ...)
      if msg and msg:find("Colorscheme file") then
        return
      end
      orig_notify(msg, ...)
    end
    require("neopywal").setup({
      use_wallust = false,
      -- colorscheme_file = vim.fn.expand("~/.cache/wal/colors-wal.vim"),
      use_palette = "pywal",
      transparent_background = true,
      custom_colors = {},
      custom_highlights = {},
      dim_inactive = true,
      terminal_colors = true,
      show_end_of_buffer = false,
      show_split_lines = true,
      no_italic = false,
      no_bold = false,
      no_underline = false,
      no_undercurl = false,
      no_strikethrough = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        includes = { "italic" },
        strings = {},
        variables = { "italic" },
        numbers = {},
        booleans = {},
        types = { "italic" },
        operators = {},
      },
      default_fileformats = true,
      default_plugins = true,
    })
    vim.notify = orig_notify
    vim.schedule(function()
      vim.cmd.colorscheme("neopywal")
    end)
  end,
}
