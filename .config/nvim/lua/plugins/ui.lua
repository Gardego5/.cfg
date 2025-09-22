return {
    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {},
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = false, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            -- {
            --     "rcarriga/nvim-notify",
            --     opts = {
            --         render = "compact",
            --         top_down = false,
            --     },
            -- },
        },
    },
    { -- colorize text like "#445577" in css and stuff
        "norcalli/nvim-colorizer.lua",
    },
    -- {
    --     "3rd/diagram.nvim",
    --     dependencies = {
    --         "3rd/image.nvim",
    --         config = function()
    --             require("image").setup({
    --                 backend = "kitty",
    --                 processor = "magick_cli",
    --             })
    --         end,
    --     },
    -- },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },

    -- {
    --     "isakbm/gitgraph.nvim",
    --     opts = {
    --         symbols = {
    --             merge_commit = "M",
    --             commit = "*",
    --         },
    --         format = {
    --             timestamp = "%H:%M:%S %d-%m-%Y",
    --             fields = { "hash", "timestamp", "author", "branch_name", "tag" },
    --         },
    --         hooks = {
    --             on_select_commit = function(commit)
    --                 print("selected commit:", commit.hash)
    --             end,
    --             on_select_range_commit = function(from, to)
    --                 print("selected range:", from.hash, to.hash)
    --             end,
    --         },
    --     },
    --     keys = {
    --         {
    --             "<leader>gl",
    --             function()
    --                 require("gitgraph").draw({}, { all = true, max_count = 5000 })
    --             end,
    --             desc = "GitGraph - Draw",
    --         },
    --     },
    -- },
}
