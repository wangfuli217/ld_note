"=============================================================================
" General settings
"=============================================================================

set nocp

" Tab related
set ts=4
set sw=4
set smarttab
set et
set ambiwidth=double

" Format related
set tw=80
set lbr
set nojs
set fo+=mB

" Indent related
set cin
set ai
set cino=:0g0t0(susj1

" Editing related
set backspace=indent,eol,start
set whichwrap=b,s,<,>,[,]
set mouse=a
set selectmode=
set mousemodel=popup
set keymodel=
set selection=inclusive

" Misc
set wildmenu

" Encoding related
set encoding=utf-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

set list
set listchars=tab:»\ ,trail:\ ,extends:»,precedes:«
highlight SpecialKey ctermbg=Red guibg=Red

" File type related
filetype plugin indent on

" Set cache directory
if (has("win32"))
    let &dir=expand("~/vimcache")."//,".&dir
else
    let &dir=expand("~/.cache/vim")."//,".&dir
endif
let &backupdir=&dir

if v:version >= 703
    " Persistent undo
    set undofile
    let &undodir=&dir
    " Highlight the right edge
    set colorcolumn=+1
endif

" Display related
set ru
set sm
set hls
if has("gui_running")
    set guioptions-=m
    set guioptions-=T
    set guioptions+=b
    set nowrap
else
    set wrap
endif
syntax on
if has("gui_running") || &t_Co == 256
    if $USER == "root"
        colo peachpuff
    else
        colo torte
    endif
    set spell
else
    if $USER == "root"
        colo shine
    else
        colo ron
    endif
    set nospell
endif
if !has("gui_running") && &t_Co == 256
    highlight SpellBad ctermbg=52
    highlight SpellCap ctermbg=17
    highlight SpellLocal ctermbg=23
    highlight SpellRare ctermbg=53
endif

" ============================================================================
" Shortcuts
" ============================================================================

" Move lines
nmap <C-Down> :<C-u>move .+1<CR>
nmap <C-Up> :<C-u>move .-2<CR>

imap <C-Down> <C-o>:<C-u>move .+1<CR>
imap <C-Up> <C-o>:<C-u>move .-2<CR>

vmap <C-Down> :move '>+1<CR>gv
vmap <C-Up> :move '<-2<CR>gv

"=============================================================================
" Modes
"=============================================================================

function EnglishMode()
    setlocal spell
    setlocal formatexpr=
endfunction
command EnglishMode call EnglishMode()

function ChineseMode()
    setlocal nospell
    setlocal formatexpr=autofmt#japanese#formatexpr()
endfunction
command ChineseMode call ChineseMode()

function TextMode()
    setlocal nocin
    setlocal nosi
    setlocal noai
    setlocal tw=80
endfunction
command TextMode call TextMode()

function CodeMode()
    setlocal cin
    setlocal si
    setlocal ai
    setlocal tw=80
endfunction
command CodeMode call CodeMode()

function MailMode()
    call TextMode()
    setlocal tw=70
endfunction
command MailMode setlocal ft=mail

function BBSMode()
    call MailMode()
    call ChineseMode()
    setlocal tw=76
endfunction
command BBSMode setlocal ft=bbs

function VikiMode()
    call ChineseMode()
    setlocal ft=viki
endfunction
command VikiMode call VikiMode()

function ConqueTermMode()
    setlocal tw=0
    setlocal nolist
    setlocal nospell
    " Work-around the bug with Tlist
    inoremap <buffer> <c-w>h <esc><c-w>h
    inoremap <buffer> <c-w>j <esc><c-w>j
    inoremap <buffer> <c-w>k <esc><c-w>k
    inoremap <buffer> <c-w>l <esc><c-w>l
    inoremap <buffer> <esc><c-w>h <esc><c-w>h
    inoremap <buffer> <esc><c-w>j <esc><c-w>j
    inoremap <buffer> <esc><c-w>k <esc><c-w>k
    inoremap <buffer> <esc><c-w>l <esc><c-w>l
endfunction
command ConqueTermMode call ConqueTermMode()

"=============================================================================
" Functions
"=============================================================================

function QuoteFix()
    %s/^\(> \?\)*>/\=substitute(submatch(0), " ", "", "g")/ge
    g/^\(> \?\)\+\s*$/d
endfunction
command QuoteFix call QuoteFix()

function TimeStamp()
    let curposn= SaveWinPosn()
    %s/\$Date: .*\$/\=strftime("$Date: %Y-%m-%d %H:%M:%S$")/ge
    %s/Last Change: .*$/\=strftime("Last Change: %Y-%m-%d %H:%M:%S")/ge
    %s/Last Modified: .*$/\=strftime("Last Modified: %Y-%m-%d %H:%M:%S")/ge
    " Replace once and never update.
    %s/Created: *$/\=strftime("Created: %Y-%m-%d %H:%M:%S")/ge
    call RestoreWinPosn(curposn)
endfunction
command TimeStamp call TimeStamp()

function AutoTimeStamp()
    augr tagdate
    au!
    au BufWritePre,FileWritePre * call TimeStamp()
    augr END
endfunction
command AutoTimeStamp call AutoTimeStamp()

function NoAutoTimeStamp()
    augr tagdate
    au!
    augr END
endfunction
command NoAutoTimeStamp call NoAutoTimeStamp()

function CodeLayout()
    call CodeMode()
    WManager
    Tlist
endfunction
command CodeLayout call CodeLayout()

function CodeLayoutSmall(c)
    call CodeLayout()
    let &columns=a:c
    exec "norm \<c-w>t"
    set winfixwidth
    exec "norm \<c-w>j"
    set winfixwidth
    set winfixheight
    exec "norm \<c-w>l"
    set nu
    set lines=56
    exec "norm \<c-w>b"
    set winfixwidth
    exec "norm \<c-w>t"
    exec "norm \<c-w>l"
    Term
endfunction
command CodeLayoutSmall call CodeLayoutSmall(141)

function CodeLayoutLarge(c)
    call CodeLayout()
    let &columns=a:c
    exec "norm \<c-w>t"
    set winfixwidth
    exec "norm \<c-w>j"
    set winfixwidth
    set winfixheight
    exec "norm \<c-w>l"
    set nu
    vsplit
    set lines=76
    exec "norm \<c-w>b"
    set winfixwidth
    exec "norm \<c-w>t"
    exec "norm \<c-w>l"
    exec "norm \<c-w>l"
    Term
endfunction
command CodeLayoutLarge call CodeLayoutLarge(226)

function TtySize()
    set columns=80
    set lines=24
endfunction
command TtySize call TtySize()

function GetWindowFilenames()
    let filenames = []
    let curwin = winnr()
    windo call add(filenames, expand("%:p"))
    exec "norm " . curwin . "\<c-w>\<c-w>"
    return filenames
endfunction

" ============================================================================
" Plugins settings
" ============================================================================

" Sketch
command ToggleSketch call ToggleSketch()

" Tlist
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close=1

" A
let g:alternateNoDefaultAlternate=1
let g:alternateRelativeFiles=1

" Viki
let g:vikiNameSuffix=".viki"

" FencView
let g:fencview_autodetect=0

" showmarks
let g:showmarks_enable=0
let g:showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let g:showmarks_hlline_lower=1
let g:showmarks_hlline_upper=1

" autofmt
let s:unicode = unicode#import()
let s:orig_prop_line_break = s:unicode.prop_line_break
function! s:unicode.prop_line_break(char)
    if a:char == "\u201c" || a:char == "\u2018"
        return "OP"   " Open Punctuation
    elseif a:char == "\u201d" || a:char == "\u2019"
        return "CL"   " Close Punctuation
    endif
    return call(s:orig_prop_line_break, [a:char], self)
endfunction

" clang_complete
set completeopt=menu,longest
let g:clang_complete_auto=0
command ClangUpdateQuickFix call g:ClangUpdateQuickFix()

" conque_term
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_ReadUnfocused = 1

"=============================================================================
" File types
"=============================================================================

augr filetype
    " BBS
    au! BufRead,BufNewFile *.bbs BBSMode
    " Mail
    au! FileType mail call MailMode()
    " Viki
    au! BufRead,BufNewFile *.viki VikiMode
    " conque_term
    au! FileType conque_term ConqueTermMode
augr end

"=============================================================================
" Platform dependent settings
"=============================================================================

if (has("win32"))

    "-------------------------------------------------------------------------
    " Win32
    "-------------------------------------------------------------------------

    if (has("gui_running"))
        set guifont=DejaVu_Sans_Mono:h9:cANSI
        set guifontwide=NSimSun:h9:cGB2312
    endif

    " For Viki
    let g:netrw_browsex_viewer="start"

    " For tee
    set shellpipe=2>&1\|\ tee

    " VimTweak
    if (has("gui_running"))
        command -nargs=1 SetAlpha call libcallnr("vimtweak.dll",
            \"SetAlpha", <args>)
        command TopMost call libcallnr("vimtweak.dll","EnableTopMost", 1)
        command NoTopMost call libcallnr("vimtweak.dll","EnableTopMost", 0)
    endif

else

    "-------------------------------------------------------------------------
    " Linux
    "-------------------------------------------------------------------------

    if (has("gui_running"))
        set guifont=DejaVu\ Sans\ Mono\ 9
    endif

    " For Viki
    let g:vikiHomePage="~/Documents/Viki/index.viki"
    let g:netrw_browsex_viewer="xdg-open"

    set makeprg=build

    function Term()
        ConqueTermSplit bash
    endfunction
    command Term call Term()

endif

if filereadable(expand("~/.vimrc_extra"))
    so ~/.vimrc_extra
endif