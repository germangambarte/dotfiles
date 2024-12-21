local set = vim.keymap.set

-- swap selected lines
set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Swap whit line below' })
set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Swap whit line above' })

set('n', 'j', [[v:count?'j':'gj']], { noremap = true, expr = true })
set('n', 'k', [[v:count?'k':'gk']], { noremap = true, expr = true })

-- keymap('n', '<leader>a', 'ggVG', { desc = 'Select all' })
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')
set('n', 'n', 'nzzzv')
set('n', 'N', 'Nzzzv')

-- buffers
set('n', '<S-h>', '<cmd>bprevious<CR>')
set('n', '<S-l>', '<cmd>bnext<CR>')
set('n', '<leader>bd', '<cmd>:bdelete<CR>')

-- tabs
set('n', '<left>', 'gT')
set('n', '<right>', 'gt')

-- greatest remap ever
set('n', '<leader>p', [["+]])

-- keep things highlighted after moving with < and >
set('v', '<', '<gv')
set('v', '>', '>gv')

-- next greatest remap ever : asbjornHaland
set({ 'n', 'v' }, '<leader>y', [["+y]])
set({ 'n', 'v' }, '<leader>p', [["+p]])
set({ 'n', 'v' }, '<leader>d', [["+d]])

set('n', 'Q', '<nop>')
set('n', '<C-s>', '<cmd>w<CR>')
set('n', '<C-S>', '<cmd>wa<CR>')

-- These mappings control the size of splits (height/width)
set('n', '<M-h>', '<c-w>5<')
set('n', '<M-l>', '<c-w>5>')
set('n', '<M-k>', '<C-W>+')
set('n', '<M-j>', '<C-W>-')

set('n', '<leader>ch', function()
  vim.lsp.inlay_hint(0, nil)
end, { desc = 'Toggle Inlay Hints' })

function CompileAndRun()
  vim.cmd('w')
  vim.cmd('!g++ % -o %<')
  if vim.v.shell_error == 0 then
    vim.cmd('! %<')
  end
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>cr',
  ':lua CompileAndRun()<CR>',
  { noremap = true, silent = true }
)
