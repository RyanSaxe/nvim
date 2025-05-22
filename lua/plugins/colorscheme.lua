local Util = require("tokyonight.util")
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    on_colors = function(c)
      c.pink = "#FF00FF"
    end,
    on_highlights = function(hl, c)
      -- docstrings should be slightly different color than comments but still faded to the background
      hl["@string.documentation"] = { fg = Util.blend_bg(c.purple, 0.5) }
      -- Color shifts I prefer
      hl["@keyword.import"] = { fg = c.purple }
      hl["@type"] = { fg = c.cyan }
      -- I prefer when the literals are the same color
      hl["@number"] = "@string"
      hl["@number.float"] = "@string"
      hl["@boolean"] = "@string"
      -- builtins should match the normal color
      hl["@type.builtin"] = "@type"
      hl["@function.builtin"] = "@function"
      -- shifts to make certain things stand out more clearly
      hl["@punctuation.bracket"] = { fg = c.purple }
      hl["@keyword.conditional"] = { fg = c.orange }
      hl["@keyword.exception"] = { fg = c.orange }
      hl["@keyword"] = { fd = c.red }
      -- remove things where particular functions and definitions have slightly different coloring
      hl["@keyword.function"] = "@function"
      hl["@constructor"] = "@function"
    end,
  },
}
