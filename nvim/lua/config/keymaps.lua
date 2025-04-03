-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


vim.keymap.set('n', '<leader>sf', function()require('fzf-lua').files()end, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>sf', '<cmd>FzfLua files <cr>', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', '<cmd>FzfLua helptags <cr>', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', '<cmd>FzfLua keymaps <cr>', { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sw', '<cmd>FzfLua grep_cword <cr>', { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', '<cmd>FzfLua live_grep <cr>', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', '<cmd>FzfLua diagnostics_document <cr>', { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', '<cmd>FzfLua files resume=true<cr>', { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', '<cmd>FzfLua oldfiles <cr>', { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>','<cmd>FzfLua buffers <cr>' , { desc = '[ ] Find existing buffers' })
