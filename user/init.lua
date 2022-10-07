--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local config = {
  -- updater = {
  --   channel = "nightly",
  --   branch = "fix-filetype-detection",
  --   remote = "benvds",
  --   remotes = {
  --     ["benvds"] = "benvds/AstroNvim",
  --   },
  -- },

  --  -- set vim options here (vim.<first_key>.<second_key> =  value)
  --  options = {
  --    opt = {
  --      relativenumber = true, -- sets vim.opt.relativenumber
  --    },
  --    g = {
  --      mapleader = " ", -- sets vim.g.mapleader
  --    },
  --  },



  -- -- Mapping data with "desc" stored directly by vim.keymap.set().
  -- --
  -- -- Please use this mappings table to set keyboard mapping since this is the
  -- -- lower level configuration and more robust one. (which-key will
  -- -- automatically pick-up stored data by this setting.)
  mappings = {
    -- first key is the mode
    n = {
  --     -- second key is the lefthand side of the map
  --     -- mappings seen under group name "Buffer"
  --     ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
  --     ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
  --     ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
  --     ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
  --     -- quick save
  --     -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
  --   },
  --   t = {
  --     -- setting a mapping to false will disable it
  --     -- ["<esc>"] = false,
      ["<leader>bp"] = { "<cmd>DapToggleBreakpoint<cr>", desc = "ToggleBreakpoint" },
      -- multi-cursor
      ["<A-K>"] = { "<cmd>call vm#commands#add_cursor_up(0, v:count1)<cr>" },
      ["<A-J>"] = { "<cmd>call vm#commands#add_cursor_down(0, v:count1)<cr>" },
    },
    v = {
      -- relpace
      ["/r"] = { "y:%s/<C-r>=escape(@+, '\\/.*$^~[]')<Cr>//gc<Left><Left><Left>", desc = "Replace selected range" },
    }
  },

  -- Configure plugins
  plugins = {
    init = {
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },

      -- You can also add new plugins here as well:
      -- Add plugins, the packer syntax without the "use"
      -- { "andweeb/presence.nvim" },
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },

      -- We also support a key value style plugin definition similar to NvChad:
      -- ["ray-x/lsp_signature.nvim"] = {
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },
      { "othree/eregex.vim" },
      { "tpope/vim-surround" },
      { "easymotion/vim-easymotion" },
      { "mg979/vim-visual-multi" },
      -- Debugging
      { "theHamsta/nvim-dap-virtual-text" },
      { "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap",
          -- 'nvim-lua/plenary.nvim',
          -- "simrat39/rust-tools.nvim",
          "nvim-treesitter/nvim-treesitter",
        },
        config = function()
          vim.fn.sign_define("DapBreakpoint", { text = '⛔', texthl = '', linehl = '', numhl = '' })
          vim.fn.sign_define("DapStopped", { text = '👉', texthl = '', linehl = '', numhl = '' })
          local dap, dapui = require("dap"), require("dapui")
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
          require("dapui").setup()
          require('dap.ext.vscode').load_launchjs()
        end
      },
      { "simrat39/rust-tools.nvim",
        requires = {
          "mfussenegger/nvim-dap",
          'nvim-lua/plenary.nvim'
        },
        config = function()
          local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.7.4/'
          local codelldb_path = extension_path .. 'adapter/codelldb'
          local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
          local opts = {
            hover_actions = { 
              -- whether the hover action window gets automatically focused
              auto_focus = true 
            },
            dap = {
              adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            },
            server = {
              on_attach = function(_, bufnr)
                -- Hover actions
                vim.keymap.set("n", "<C-space>", require("rust-tools").hover_actions.hover_actions,
                  { buffer = bufnr })
                -- Code action groups
                vim.keymap.set("n", "<Leader>a", require("rust-tools").code_action_group.code_action_group,
                  { buffer = bufnr })
              end
            }
          }
          require("rust-tools").setup(opts)
        end
      },
    },
  }
}

return config
