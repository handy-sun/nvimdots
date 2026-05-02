local options = {
	cindent = true,
	wrap = true,
	showbreak = '⣿',
	showcmd = true,
	gdefault = true,
	clipboard = '',
	cursorcolumn = false,
	timeoutlen = 700,
	ttimeoutlen = 10,
	cmdwinheight = 7,
	showtabline = 1,
	foldmethod = 'manual',
	wildignore = '.git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**,*build*',
}

if vim.fn.executable('rg') == 1 then
	options['grepprg'] = 'rg --hidden --vimgrep --smart-case $*'
else
	options['grepprg'] = 'grep --binary-files=without-match -irn $*'
	options['grepformat'] = '%f:%l:%m,%f:%l%m,%f  %l%m'
end

vim.opt.suffixes:append('.a,.1,.class')

vim.cmd([[
function! s:CpGrep(pattern, ...) abort
    let l:cmd = 'silent grep!'
    for l:pat in split(&wildignore, ',')
        let l:cmd .= ' --glob ' . shellescape('!' . l:pat)
    endfor
    let l:cmd .= ' -- ' . shellescape(a:pattern)
    if a:0 > 0
        let l:cmd .= ' ' . a:1
    endif
    execute l:cmd
    copen 9
    redraw!
endfunction
command! -nargs=+ -complete=file CpGrep call s:CpGrep(<f-args>)
]])

vim.cmd([[
function! GetAbsFileDir()
    return expand('%:p:h') . '/'
endfunction
]])

return options
