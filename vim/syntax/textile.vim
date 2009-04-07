" Vim syntax file
" Language:         Textile
" Maintainer:       Dominic Mitchell <dom@happygiraffe.net>
" URL:              http://happygiraffe.net/blog/archives/2006/01/25/vim-syntax-for-textile
" Latest Revision:  2006-01-25
" Installation:
"   To automatically load this file when a .txt file is opened, add
"   the following lines to ~/.vim/filetype.vim:
"
"     augroup filetypedetect
"       au! BufRead,BufNewFile *.txt setfiletype textile
"     augroup END
"
"   You will have to restart vim for this to take effect.  In any case
"   it is a good idea to read ":he new-filetype" so that you know what
"   is going on, and why the above lines work.
"
" @(#) $Id$

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Textile commands like "h1" are case sensitive, AFAIK.
syn case match

" Textile syntax: <http://textism.com/tools/textile/>

" Block elements.
syn match txtHeader      /^h[1-6]\./
syn match txtBlockquote  /^bq\./
syn match txtFootnoteDef /^fn[0-9]\+\./
syn match txtListBullet  /^\*\+/
syn match txtListNumber  /^#\+/

syn cluster txtBlockElement contains=txtHeader,txtBlockElement,txtFootnoteDef,txtListBullet,txtListNumber

" Inline elements.
syn match txtEmphasis    /_[^_]\+_/
syn match txtBold        /\*[^*]\+\*/
syn match txtCite        /??.\+??/
syn match txtDeleted     /-[^-]\+-/
syn match txtInserted    /+[^+]\++/
syn match txtSuper       /\^[^^]\+\^/
syn match txtSub         /\~[^~]\+\~/
syn match txtSpan        /%[^%]\+%/
syn match txtFootnoteRef /\[[0-9]\+]/
syn match txtCode        /@[^@]\+@/

" Everything after the first colon is from RFC 2396, with extra
" backslashes to keep vim happy...  Original:
" ^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
syn match txtLink /"[^"]\+":\(\([^:\/?#]\+\):\)\?\(\/\/\([^\/?#]*\)\)\?\([^?#]*\)\(?\([^#]*\)\)\?\(#\(.*\)\)\?/

syn cluster txtInlineElement contains=txtEmphasis,txtBold,txtCite,txtDeleted,txtInserted,txtSuper,txtSub,txtSpan

if version >= 508 || !exists("did_txt_syn_inits")
    if version < 508
        let did_txt_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink txtHeader Title
    HiLink txtBlockquote Comment
    HiLink txtListBullet PreProc
    HiLink txtListNumber PreProc
    HiLink txtLink String
    HiLink txtCode Identifier
    hi def txtEmphasis term=underline cterm=underline gui=italic
    hi def txtBold term=bold cterm=bold gui=bold

    delcommand HiLink
endif

" vim: set ai et sw=4 :
