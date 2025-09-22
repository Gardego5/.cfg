-- local prompts = {
--     -- Code related prompts
--     Explain = "Please explain how the following code works.",
--     Review = "Please review the following code and provide suggestions for improvement.",
--     Tests = "Please explain how the selected code works, then generate unit tests for it.",
--     Refactor = "Please refactor the following code to improve its clarity and readability.",
--     FixCode = "Please fix the following code to make it work as intended.",
--     FixError = "Please explain the error in the following text and provide a solution.",
--     BetterNamings = "Please provide better names for the following variables and functions.",
--     Documentation = "Please provide documentation for the following code.",
--     SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
--     SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
--
--     -- Text related prompts
--     Summarize = "Please summarize the following text.",
--     Spelling = "Please correct any grammar and spelling errors in the following text.",
--     Wording = "Please improve the grammar and wording of the following text.",
--     Concise = "Please rewrite the following text to make it more concise.",
-- }

return {
    -- {
    --     "CopilotC-Nvim/CopilotChat.nvim",
    --     dependencies = {
    --         { "zbirenbaum/copilot.lua" },
    --         { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
    --         { "nvim-lua/plenary.nvim" },
    --     },
    --     build = "make tiktoken", -- Only on MacOS or Linux
    --     event = "VeryLazy",
    --     config = function(_, opts)
    --         local chat = require("CopilotChat")
    --         chat.setup(opts)
    --
    --         local select = require("CopilotChat.select")
    --         vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
    --             chat.ask(args.args, { selection = select.visual })
    --         end, { nargs = "*", range = true })
    --
    --         -- Inline chat with Copilot
    --         vim.api.nvim_create_user_command("CopilotChatInline", function(args)
    --             chat.ask(args.args, {
    --                 selection = select.visual,
    --                 window = {
    --                     layout = "float",
    --                     relative = "cursor",
    --                     width = 1,
    --                     height = 0.4,
    --                     row = 1,
    --                 },
    --             })
    --         end, { nargs = "*", range = true })
    --
    --         -- Restore CopilotChatBuffer
    --         vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
    --             chat.ask(args.args, { selection = select.buffer })
    --         end, { nargs = "*", range = true })
    --
    --         -- Custom buffer for CopilotChat
    --         vim.api.nvim_create_autocmd("BufEnter", {
    --             pattern = "copilot-*",
    --             callback = function()
    --                 vim.opt_local.relativenumber = true
    --                 vim.opt_local.number = true
    --
    --                 -- Get current filetype and set it to markdown if the current filetype is copilot-chat
    --                 local ft = vim.bo.filetype
    --                 if ft == "copilot-chat" then
    --                     vim.bo.filetype = "markdown"
    --                 end
    --             end,
    --         })
    --     end,
    --     opts = {
    --         question_header = "## User ",
    --         answer_header = "## Copilot ",
    --         error_header = "## Error ",
    --         prompts = prompts,
    --         mappings = {
    --             -- Use tab for completion
    --             complete = {
    --                 detail = "Use @<Tab> or /<Tab> for options.",
    --                 insert = "<Tab>",
    --             },
    --             -- Close the chat
    --             close = {
    --                 normal = "q",
    --                 insert = "<C-c>",
    --             },
    --             -- Reset the chat buffer
    --             reset = {
    --                 normal = "<C-x>",
    --                 insert = "<C-x>",
    --             },
    --             -- Submit the prompt to Copilot
    --             submit_prompt = {
    --                 normal = "<CR>",
    --                 insert = "<C-CR>",
    --             },
    --             -- Accept the diff
    --             accept_diff = {
    --                 normal = "<C-y>",
    --                 insert = "<C-y>",
    --             },
    --             -- Show help
    --             show_help = {
    --                 normal = "g?",
    --             },
    --         },
    --     },
    --     keys = {
    --         -- See Commands section for default commands if you want to lazy load on them
    --         { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
    --     },
    -- },

    -- {
    --     "yetone/avante.nvim",
    --     build = vim.fn.has("win32") ~= 0
    --             and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    --         or "make",
    --     event = "VeryLazy",
    --     version = false, -- Never set this to "*"
    --     opts = {
    --         provider = "copilot",
    --         windows = {
    --             position = "right",
    --         },
    --         rag_service = {
    --             enabled = true,
    --             runner = "nix",
    --             llm = {
    --                 provider = "copilot",
    --                 api_key = "",
    --                 model = "gemini-2.0-flash-001",
    --                 extra = {},
    --             },
    --             embed = {
    --                 provider = "ollama",
    --                 api_key = "",
    --                 model = "nomic-text-embed",
    --                 extra = {
    --                     embed_batch_size = 16,
    --                 },
    --             },
    --         },
    --         web_search_engine = {
    --             provider = "searxng",
    --             proxy = nil,
    --             providers = {
    --                 searxng = {
    --                     api_url_name = "SEARXNG_API_URL",
    --                     extra_request_body = {
    --                         format = "json",
    --                     },
    --
    --                     ---@type WebSearchEngineProviderResponseBodyFormatter
    --                     format_response_body = function(body)
    --                         if body.results == nil then
    --                             return "", nil
    --                         end
    --
    --                         local jsn = vim.iter(body.results):map(function(result)
    --                             return {
    --                                 title = result.title,
    --                                 url = result.url,
    --                                 snippet = result.content,
    --                             }
    --                         end)
    --
    --                         return vim.json.encode(jsn), nil
    --                     end,
    --                 },
    --             },
    --         },
    --     },
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "MunifTanjim/nui.nvim",
    --         -- "MeanderingProgrammer/render-markdown.nvim",
    --         -- Optional dependencies
    --         "hrsh7th/nvim-cmp",
    --         "nvim-telescope/telescope.nvim",
    --         "nvim-tree/nvim-web-devicons",
    --     },
    -- },

    -- {
    --     "nomnivore/ollama.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --     },
    --     cmd = {
    --         "Ollama",
    --         "OllamaModel",
    --         "OllamaServe",
    --         "OllamaServeStop",
    --     },
    --
    --     keys = {
    --         -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
    --         {
    --             "<leader>oo",
    --             ":<c-u>lua require('ollama').prompt()<cr>",
    --             desc = "ollama prompt",
    --             mode = { "n", "v" },
    --         },
    --
    --         -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
    --         {
    --             "<leader>oG",
    --             ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
    --             desc = "ollama Generate Code",
    --             mode = { "n", "v" },
    --         },
    --     },
    --
    --     ---@type Ollama.Config
    --     opts = {
    --         -- your configuration overrides
    --     },
    -- },

    {
        "olimorris/codecompanion.nvim",
        opts = {
            strategies = {
                inline = {
                    adapter = { name = "copilot", model = "gpt-4.1" },
                },
                cmd = {
                    adapter = { name = "copilot", model = "gpt-4.1" },
                },
                chat = {
                    adapter = { name = "copilot", model = "gpt-4.1" },
                    tools = {
                        groups = {
                            ["github_pr_workflow"] = {
                                description = "GitHub operations from issue to PR",
                                tools = {
                                    -- File operations
                                    "neovim__read_multiple_files",
                                    "neovim__write_file",
                                    "neovim__edit_file",
                                    -- GitHub operations
                                    "github__list_issues",
                                    "github__get_issue",
                                    "github__get_issue_comments",
                                    "github__create_issue",
                                    "github__create_pull_request",
                                    "github__get_file_contents",
                                    "github__create_or_update_file",
                                    "github__search_code",
                                },
                            },
                        },
                    },
                },
            },
            prompts = {
                conventional_commit = {
                    name = "Conventional Commit from staged changes",
                    description = "Review staged changes and craft a Conventional Commits message",
                    strategy = "chat",
                    messages = {
                        {
                            role = "system",
                            content = [[
You are a meticulous senior developer. You will:
1) Review the provided *staged* diff.
2) Infer intent and scope from the changes.
3) Produce a Conventional Commits message.


Rules:
- Use the format: type[!][(scope)]: subject
- Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- Subject: ≤ 72 chars, imperative mood, no trailing period
- If breaking change: add '!' after type or include a 'BREAKING CHANGE:' footer
- Optionally add a body with bullet points
- Optionally add footers such as 'Closes #123', 'Co-authored-by:', etc.


Output:
- Output ONLY the final commit message. No prefaces, no commentary, no code fences.
]],
                        },
                        {
                            role = "user",
                            content = [[
Repository: #{repo_name}
Branch: #{git_branch}


Staged diff:
```
#{git_diff_staged}
```


Construct the best possible Conventional Commits message for this diff. If changes are mixed, choose the primary type and mention others in the body. If no staged changes are detected, say: "No staged changes." (and nothing else).
]],
                        },
                    },
                    slash_cmd = "/commit",
                    vars = { "repo_name", "git_branch", "git_diff_staged" },
                },
            },

            variables = {
                repo_name = {
                    callback = function()
                        local cwd = vim.loop.cwd() or ""
                        return vim.fn.fnamemodify(cwd, ":t")
                    end,
                },
                git_branch = {
                    callback = function()
                        local out = vim.fn.systemlist({ "git", "rev-parse", "--abbrev-ref", "HEAD" })
                        return table.concat(out or {}, "\n")
                    end,
                },
                git_diff_staged = {
                    callback = function()
                        local diff = vim.fn.systemlist({ "git", "diff", "--staged" })
                        local MAX_LINES = 1200
                        if #diff > MAX_LINES then
                            local head = table.concat(vim.list_slice(diff, 1, math.floor(MAX_LINES * 0.7)), "\n")
                            local tail =
                                table.concat(vim.list_slice(diff, #diff - math.floor(MAX_LINES * 0.3), #diff), "\n")
                            return head .. "\n...\n# [diff truncated]\n...\n" .. tail
                        end
                        return table.concat(diff or {}, "\n")
                    end,
                },
            },
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        -- MCP Tools
                        make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
                        show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
                        add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
                        show_result_in_chat = true, -- Show tool results directly in chat buffer
                        format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
                        -- MCP Resources
                        make_vars = true, -- Convert MCP resources to #variables for prompts
                        -- MCP Prompts
                        make_slash_commands = true, -- Add MCP prompts as /slash commands
                    },
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "ravitemer/mcphub.nvim",
            "j-hui/fidget.nvim",
        },
        config = function(_, opts)
            require("codecompanion").setup(opts)
        end,
        init = function()
            require("plugins.codecompanion.fidget-spinner").init()
        end,
    },

    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
        config = function()
            require("mcphub").setup({
                use_bundled_binary = true, -- Use local `mcp-hub` binary
            })
        end,
    },
}
