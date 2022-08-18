-- By convention, nvim Lua plugins include a setup function that takes a table
-- so that users of the plugin can configure it using this pattern:
--
-- require'myluamodule'.setup({p1 = "value1"})
-- local function setup(config)
-- end
local M = {}
local command = 'match ExtraWhitespace /\\'..[[\\@<![\u3000[:space:]]..']]'..[[\+$/]]
local command_insert_mode = 'match ExtraWhitespace /\\'..[[\\@<![\u3000[:space:]]..']]'..[[\+\%#\@<!$/]]
local remove_white_space_regexp = 's/\\' .. [[\\@<!\s\+$//]]
-- print(command)
-- print(command_insert_mode)
-- print(remove_white_space_regexp)

-- So far this function is a placceholder and not used.
function M.setup(config)
    if config then
        M['setup'] = 'done'
    end

end

local function check_ignored_filetype()
    if vim.g['extra_whitespace_ignored_filetypes']
        then
            -- print(vim.inspect(vim.g['extra_whitespace_ignored_filetypes']))
            for _,ft in pairs(vim.g['extra_whitespace_ignored_filetypes'])
            do
                if ft == vim.bo.filetype then
                    print('here')
                    return(true)
                end
            end
    end
    return(false)
end

-- Define hightlight for trailing whitespace.
local function set_hl()
    vim.api.nvim_set_hl(0, 'ExtraWhitespace', {bg = 'darkred'})
end

set_hl()

-- Define a group for fix trailing whiespace autocmds.
local augroup = vim.api.nvim_create_augroup('fix_trailing_whitespace', {clear = true})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  group = augroup,
  -- There can be a 'command', or a 'callback'. A 'callback' will be a reference to a Lua function.
  -- command = 'highlight default ExtraWhitespace ctermbg=darkred guibg=darkred',
  callback = set_hl
  --  vim.api.nvim_set_hl(0, 'String', {fg = '#FFEB95'})
  --end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNew' }, {
  pattern = '*',
  group = augroup,
  command = command,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNew' }, {
  pattern = '*',
  group = augroup,
  callback = function()
      print('before here')
      check_ignored_filetype()
  end
})

vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  pattern = '*',
  group = augroup,
  command = command,
})

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = '*',
  group = augroup,
  command = command_insert_mode,
})

vim.api.nvim_create_user_command(
    'FixWhitespace',
    function(input)
        vim.cmd(input.line1 .. ',' .. input.line2 .. remove_white_space_regexp)
    end,
    {bang = true, range = '%', desc = 'Command to remove trailing whitespaces'}
)

return M
