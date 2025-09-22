return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end,
        opts = {
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true,
            term_colors = true,
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = { "italic" },
                functions = { "italic" },
                keywords = { "italic" },
                strings = { "NONE" },
                variables = { "NONE" },
                numbers = { "NONE" },
                booleans = { "NONE" },
                properties = { "NONE" },
                types = { "NONE" },
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                treesitter = true,
                mini = true,
            },
        },
    },
}
