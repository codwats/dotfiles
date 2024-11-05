return {
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual", -- Use virtual text for color swatch
        virtual_symbol = "■", -- Square symbol for color swatch
        virtual_symbol_prefix = "", -- No prefix before the color swatch
        virtual_symbol_suffix = " ", -- Space after the color swatch
        virtual_symbol_position = "eow", -- Display the color inline with text
      })
    end,
  },
}
