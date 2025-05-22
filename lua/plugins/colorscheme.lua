local Util = require("tokyonight.util")
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "moon",
    on_colors = function(c)
      c.pink = "#FF00FF"
    end,
    on_highlights = function(hl, c)
      -- docstrings should be slightly different color than comments but still faded to the background
      hl["@string.documentation"] = { fg = Util.blend_bg(c.purple, 0.5) }
      -- Color shifts I prefer
      hl["@keyword.import"] = { fg = c.magenta }
      hl["@type"] = { fg = c.yellow }
      -- I prefer when the literals are the same color and dont pop out at me
      local muted_literal = { fg = Util.blend_bg(c.blue6, 0.8) }
      hl["@string"] = muted_literal
      hl["@number"] = muted_literal
      hl["@number.float"] = muted_literal
      hl["@boolean"] = muted_literal
      -- builtins should match the normal color
      hl["@function"] = { fg = c.green1 }
      hl["@type.builtin"] = "@type"
      hl["@function.builtin"] = "@function"
      hl["@constant.builtin"] = "@type"
      -- g = c.purple }
      hl["@keyword.conditional"] = { fg = c.purple }
      hl["@keyword.repeat"] = { fg = c.purple }
      -- make exception red and force assert in python to be red by overriding keyword and specifying
      -- non-red for other keyword groups
      hl["@keyword.exception"] = { fg = c.purple }
      -- hl["@keyword"] = { fg = c.magenta2 }
      hl["@keyword.risky"] = { fg = c.magenta2 }
      hl["@keyword.error"] = { fg = c.red }
      -- remove things where particular functions and definitions have slightly different coloring
      hl["@keyword.function"] = { fg = c.purple }
      hl["@keyword.return"] = { fg = c.purple }
      hl["@keyword.type"] = { fg = c.purple }
      hl["@constructor"] = "@function"
      hl["@function.method"] = "@function"
      hl["@module"] = { fg = c.cyan }
      -- make self the same color as arguments ... I dont like it to jump out separately like that
      hl["@variable.builtin"] = { fg = c.magenta }
      hl["@variable"] = { fg = c.blue }
      hl["@variable.member"] = { fg = c.cyan }
      hl["@variable.parameter"] = { fg = c.cyan }
      hl["@operator"] = { fg = c.magenta }
      hl["@punctuation.delimiter"] = { fg = "#FFFFFF" }
      hl["@punctuation.brackets"] = { fg = c.purple }
    end,
  },
}
