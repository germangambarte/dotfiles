vim.cmd.packadd("cfilter")
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

vim.cmd.colorscheme("catppuccin")

-- disable mouse popup yet keep mouse enabled
vim.cmd([[
  aunmenu PopUp
  autocmd! nvim.popupmenu
]])

-- Only highlight with treesitter
vim.cmd("syntax off")
