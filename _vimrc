source $VIMRUNTIME/vimrc_example.vim		" vimrc의 예시 설정이 들어가 있다.

au GUIEnter * simalt ~x				" 시작시 전체화면
set hls						" 검색어 강조(hlsearch)
set is						" 한글자 입력할때마다 매치 표시
set cb=unnamed					" 클립보드를 unnamed 레지스터로 매핑
set gfn=Fixedsys:h10				" 폰트설정
set ts=4					" Tab 4칸 들여쓰기(tabstop)
set sw=4					" 자동 들여쓰기할 때 4칸 들여쓰기(shiftwidth)
set si						" 똑똑한 들여쓰기(smartindent)
cd F:\06.codes				" HOME directory

" {시 자동 괄호}
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}

autocmd filetype python nnoremap <F9> :!python %<CR>
autocmd filetype java nnoremap <F5> :w <bar> !javac %<CR>
autocmd filetype java nnoremap <F6> :!java %:r<CR>
autocmd filetype java nnoremap <C-C> :s/^\(\s*\)/\1\/\/<CR> :s/^\(\s*\)\/\/\/\//\1<CR> $

autocmd filetype cpp nnoremap <F8> :w <bar> !gcc % -o %:r -Wl,--stack,268435456<CR>
autocmd filetype cpp nnoremap <F9> :w <bar> !g++ -std=c++14 % -o %:r -Wl,--stack,268435456<CR>
autocmd filetype cpp nnoremap <F10> :!%:r<CR>
autocmd filetype cpp nnoremap <C-C> :s/^\(\s*\)/\1\/\/<CR> :s/^\(\s*\)\/\/\/\//\1<CR> $

set nu						" 줄번호 표시(number)
" 줄번호 포커스인거 표시 및 현재위치 위로- 아래로+
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END

if &diffopt !~# 'internal'
  set diffexpr=MyDiff()				" vim을 vi처럼 행동하게 한다.
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

