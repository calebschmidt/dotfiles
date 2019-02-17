set encoding=utf-8
set showcmd
set number
set relativenumber
set cursorline
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch
set splitbelow
set splitright

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" Make splitting the screen more natural
set splitbelow
set splitright

" Remap pane navigation to use Ctrl + h, j, k, l
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Auto complete braces, brackets, and quotes
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap { {}<Left>
inoremap ( ()<Left>
inoremap [ []<Left>

syntax on
colorscheme monokai 

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set fileformat=unix

" The below is taken from http://vim.wikia.com/wiki/C/C%2B%2B_function_abbreviations
" Help delete character if it is 'empty space'
" stolen from Vim manual
function! Eatchar()
  let c = nr2char(getchar())
  return (c =~ '\s') ? '' : c
endfunction

" Replace abbreviation if we're not in comment or other unwanted places
" stolen from Luc Hermitte's excellent http://hermitte.free.fr/vim/
function! MapNoContext(key, seq)
  let syn = synIDattr(synID(line('.'),col('.')-1,1),'name')
  if syn =~? 'comment\|string\|character\|doxygen'
    return a:key
  else
    exe 'return "' .
    \ substitute( a:seq, '\\<\(.\{-}\)\\>', '"."\\<\1>"."', 'g' ) . '"'
  endif
endfunction

" Create abbreviation suitable for MapNoContext
function! Iab (ab, full)
  exe "iab <silent> <buffer> ".a:ab." <C-R>=MapNoContext('".
    \ a:ab."', '".escape (a:full.'<C-R>=Eatchar()<CR>', '<>\"').
    \"')<CR>"
endfunction

" Preprocessor shortcuts
call Iab('#d', '#define ')
call Iab('#i', '#include <><Left>')
call Iab('#g', '#ifndef x<CR>#define x<CR><CR><CR><CR>'.
\ '#endif<Up><Up>')
call Iab('#I', '#include ""<Left>')

" Conditional shortcuts
call Iab('ifl', 'if () {<CR>}<Left><C-O>?)<CR>')
call Iab('forl', 'for (;;) {<CR>}<C-O>?;;<CR>')
call Iab('whilel', 'while () {<CR>}<C-O>?)<CR>')
call Iab('elsel', 'else {<CR>x;<CR>}<C-O>?x;<CR><Del><Del>')
call Iab('elif', 'else if () {<CR>}<C-O>?)<CR>')
call Iab('ifelsel', 'if () {<CR>}<CR>else {<CR>}<C-O>?)<CR>')
call Iab('swi', 'switch () {<CR>}<C-O>?)<CR>')
call Iab('case', 'case x:<CR><Tab>break;<C-O>?x<CR><Del>')

" Main shortcuts
call Iab('intmaincl', 'int main (int argc, char **argv) '.
 \ '{<CR>x;<CR>return 0;<CR>}<CR><C-O>?x;<CR><Del><Del>')
call Iab('intmain', 'int main() '.
 \ '{<CR>x;<CR>return 0;<CR>}<CR><C-O>?x;<CR><Del><Del>')

" I/O shortcuts
call Iab('usestdio', 'using std::cin;<CR>using std::cout;<CR>using std::endl;<CR>')
call Iab('sto', 'std::cout')
call Iab('sti', 'std::cin')
call Iab('lno', 'cout << x << endl;<C-O>?x<CR><Del>')
call Iab('lni', 'cin >> ;<Left>')
call Iab('getln', 'getline(cin, );<C-O>?)<CR>')

" Class shortcuts
call Iab('cls', 'class x {<CR>public:<CR><CR>private:<CR><CR>};<C-O>?x<CR><Del>')
call Iab('icls', 'class x : public PARENT {<CR>public:<CR><CR>private:<CR><CR>};<C-O>?x<CR><Del>')

" Comment shortcuts
call Iab('bcmt', '/*  */<Left><Left><Left>')
call Iab('fcmt', '<CR><CR><CR>'.
\ ' *********************************************************************/<Up>'.
\ ' ** Description:<Up>'.
\ '/*********************************************************************<Down><Space>')

" Autopopulate .cpp and .h files with header comment for class
au BufNewFile *.cpp 0r ~/.vim/cpp.skel
au BufNewFile *.h,*.hpp 0r ~/.vim/h.skel
