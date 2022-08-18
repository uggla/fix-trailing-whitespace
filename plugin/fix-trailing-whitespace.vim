let g:extra_whitespace_ignored_filetypes=['truc', 'bidule']
lua require('fix-trailing-whitespace').setup({backends = {'truc'}})
lua require('fix-trailing-whitespace')
