desc()
{
F6: make
F7:TlistToggle
F8:SrcExplToggle
F9:NERDTreeToggle

shell终端输入
vim --version
出现关于vim的相关信息,以下即是vimrc的位置

system vimrc file: "$VIM/vimrc"
user vimrc file: "$HOME/.vimrc"
2nd user vimrc file: "~/.vim/vimrc"
user exrc file: "$HOME/.exrc"
fall-back for $VIM: "/usr/share/vim"

}

main()
{
encode(设置编码)
set bg=dark                   "显示不同的底色色调
set hlsearch                  "高亮度反白
set ruler                      "可显示最后一行的状态
set showmode                 "左下角那一行的状态

" 字符间插入的像素行数目 
set linespace=0 

" 增强模式中的命令行自动完成操作 
set wildmenu 

" 在状态行上显示光标所在位置的行号和列号 "
set ruler 
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%) 

serach(搜索和匹配)
{
" 高亮显示匹配的括号 
set showmatch 

" 匹配括号高亮的时间（单位是十分之一秒） 
set matchtime=5 

" 在搜索的时候忽略大小写 
set ignorecase 

" 不要高亮被搜索的句子（phrases） 
set nohlsearch 

" 在搜索时，输入的词句的逐字符高亮（类似firefox的搜索） 
set incsearch 

" 输入:set list命令是应该显示些啥？ 
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ 

" 光标移动到buffer的顶部和底部时保持3行距离 
set scrolloff=3 

" 不要闪烁 
set novisualbell 

" 我的状态行显示的内容（包括文件类型和解码） 
set statusline=%F%m%r%h%w\[POS=%l,%v][%p%%]\%{strftime(\"%d/%m/%y\ -\ %H:%M\")} 

" 总是显示状态行 
set laststatus=2
}

{
"设置编码
set encoding=utf-8                                          "设置内部编码为utf8
set fileencoding=utf8                                       "当前编辑的文件编码
set fileencodings=utf-8,ucs-bom,chinese                     "当前编辑的文件编码

" 设定默认解码
set fenc=utf-8 
set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936 

}

language(语言设置) 
{
"语言设置
set langmenu=zh_CN.UTF-8
}

 syntax(设置语法高亮)
 {
 "设置语法高亮
syntax enable
syntax on
 }

 colorscheme(设置配色方案)
 {
 "设置配色方案
 colorscheme torte
 }

 mouse(鼠标)
 {
 "可以在buffer的任何地方使用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key
 }

 showmatch(高亮显示匹配的括号)
 {
 "高亮显示匹配的括号
set showmatch
 }

 
"去掉vi一致性
set nocompatible
 
 stop(设置缩进)
 {
 "设置缩进
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent
set expandtab                  "将tab替换为相应数量空格
set smartindent

" 在行和段开始处使用制表符 
set smarttab 

" 自动格式化 
set formatoptions=tcrqn 

if &term=="xterm"
    set t_Co=8
    set t_Sb=^[[4%dm
    set t_Sf=^[[3%dm
endif
 }

 "打开文件类型自动检测功能
filetype on
filetype plugin indent on   "打开文件类型检测
"为特定文件类型载入相关缩进文件 
filetype indent on 
}

taglist()
{
"设置taglist
let Tlist_Show_One_File=0   "显示多个文件的tags
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "在taglist是最后一个窗口时退出vim
let Tlist_Use_SingleClick=1 "单击时跳转
let Tlist_GainFocus_On_ToggleOpen=1 "打开taglist时获得输入焦点
let Tlist_Process_File_Always=1 "不管taglist窗口是否打开，始终解析文件中的tag
}
 

WinManager()
 {
 "设置WinManager插件
let g:winManagerWindowLayout='FileExplorer|TagList'
nmap wm :WMToggle<cr>
nmap <silent> <F10> :WMToggle<cr> "将F9绑定至WinManager,即打开WimManager
 }

 CSCOPE()
 {
 "设置CSCOPE
set cscopequickfix=s-,c-,d-,i-,t-,e- "设定是否使用quickfix窗口显示cscope结果
 }

"设置Grep插件
nnoremap <silent> <F3> :Grep<CR>
 
"设置一键编译
"map <F6> :make<CR>
 
"设置自动补全
set completeopt=longest,menu "关掉智能补全时的预览窗口
 
"启动vim时如果存在tags则自动加载
if exists("tags")
    set tags=./tags
endif

:nnoremap <f5> :!ctags -R<CR>
:autocmd BufWritePost * call system("ctags -R")


cs()
{
"设置按F12就更新tags的方法
map <F12> :call Do_CsTag()<CR>
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
function Do_CsTag()
        let dir = getcwd()
        if filereadable("tags")
            if(g:iswindows==1)
                let tagsdeleted=delete(dir."\\"."tags")
            else
                let tagsdeleted=delete("./"."tags")
            endif
            if(tagsdeleted!=0)
                echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
                return
            endif
        endif
         
        if has("cscope")
            silent! execute "cs kill -1"
        endif
         
        if filereadable("cscope.files")
            if(g:iswindows==1)
                let csfilesdeleted=delete(dir."\\"."cscope.files")
            else
                let csfilesdeleted=delete("./"."cscope.files")
            endif
            if(csfilesdeleted!=0)
                echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
                return
            endif
        endif
                                             
        if filereadable("cscope.out")
            if(g:iswindows==1)
                let csoutdeleted=delete(dir."\\"."cscope.out")
            else
                let csoutdeleted=delete("./"."cscope.out")
            endif
            if(csoutdeleted!=0)
                echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
                return
            endif
        endif
                                             
        if(executable('ctags'))
            "silent! execute "!ctags -R --c-types=+p --fields=+S *"
            silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
        endif
             
        if(executable('cscope') && has("cscope") )
            if(g:iswindows!=1)
                silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
            else
                silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
            endif
            silent! execute "!cscope -b"
            execute "normal :"
                                                                     
            if filereadable("cscope.out")
                execute "cs add cscope.out"
            endif
        endif
endfunction
 }
 
"设置默认shell
set shell=bash
 
"设置VIM记录的历史数
set history=400
 
"设置当文件被外部改变的时侯自动读入文件
if exists("&autoread")
    set autoread
endif
 
"设置ambiwidth
set ambiwidth=double
 
"设置文件类型
set ffs=unix,dos,mac
 
"设置增量搜索模式
set incsearch
 
"设置静音模式
set noerrorbells
set novisualbell
set t_vb=
 
"不要备份文件
set nobackup
set nowb

set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb

set csverb

nmap <F7> :TlistToggle<CR>
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_Inc_Winwidth = 0
let Tlist_Exit_OnlyWindow = 0
let Tlist_Auto_Open = 0
let Tlist_Use_Right_Window = 1


nmap <F8> :SrcExplToggle<CR>
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

let g:SrcExpl_WinHeight = 8
let g:SrcExpl_refreshTime = 100
let g:SrcExpl_jumpKey = "<Enter>"
let g:SrcExpl_gobackKey = "<Enter>"
let g:SrcExpl_isUpdateTags = 0

let NERDTreeWinPos = "left"
nmap <F9> :NERDTreeToggle<CR>


