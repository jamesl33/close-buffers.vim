" close-buffers.vim
" Commands to delete buffers
" Author:	Asheq Imran <https://github.com/Asheq>
" License:	Same license as Vim itself
" Version: 0.3

" TODO
" --------------------
" - Make work flawlessly with terminal buffers
" - Use moll/vim-bbye to allow closing buffers without messing up layout. Use a -preserve flag.
" - Use new command names. Bdelete, BdeleteMenu, BdeleteAll, etc. Show warning for old commands. Use new repo name?
" - Add 'set confirm' as recommended setting

" Setup
" --------------------
if exists("g:loaded_close_buffers")
  finish
endif
let g:loaded_close_buffers = 1

let s:save_cpo = &cpo
set cpo&vim

" Commands
" --------------------
if !exists(':CloseAllBuffers')
  command -nargs=1 -bang CloseAllBuffers call s:CloseAllBuffers(<f-args>, <bang>0)
endif

if !exists(':CloseHiddenBuffers')
  command -nargs=1 -bang CloseHiddenBuffers call s:CloseHiddenBuffers(<f-args>, <bang>0)
endif

if !exists(':CloseNamelessBuffers')
  command -nargs=1 -bang CloseNamelessBuffers call s:CloseNamelessBuffers(<f-args>, <bang>0)
endif

if !exists(':CloseOtherBuffers')
  command -nargs=1 -bang CloseOtherBuffers call s:CloseOtherBuffers(<f-args>, <bang>0)
endif

if !exists(':CloseSelectedBuffers')
  command -nargs=1 -bang CloseSelectedBuffers call s:CloseSelectedBuffers(<f-args>, <bang>0)
endif

if !exists(':CloseThisBuffer')
  command -nargs=1 -bang CloseThisBuffer call s:CloseThisBuffer(<f-args>, <bang>0)
endif

if !exists(':CloseBuffers')
  command -nargs=1 -bang CloseBuffers call s:CloseBuffersMenu(<f-args>, <bang>0)
endif

if !exists(':CloseBuffersMenu')
  command -nargs=1 -bang CloseBuffersMenu call s:CloseBuffersMenu(<f-args>, <bang>0)
endif

" Functions
" --------------------
function! s:CloseAllBuffers(delete, bang)
  let all_buffers = map(s:getListedOrLoadedBuffers(), 'v:val.bufnr')
  call s:DeleteBuffers(all_buffers, a:delete, a:bang)
endfunction

function! s:CloseHiddenBuffers(delete, bang)
  let hidden_buffers = map(filter(s:getListedOrLoadedBuffers(), 'empty(v:val.windows) && v:val.name !~ "NERD_tree" && v:val.name !~ "__Tagbar__"'), 'v:val.bufnr')
  call s:DeleteBuffers(hidden_buffers, a:delete, a:bang)
endfunction

function! s:CloseNamelessBuffers(delete, bang)
  let nameless_buffers = map(filter(s:getListedOrLoadedBuffers(), 'v:val.name == ""'), 'v:val.bufnr')
  call s:DeleteBuffers(nameless_buffers, a:delete, a:bang)
endfunction

function! s:CloseOtherBuffers(delete, bang)
  let current_buffer = bufnr('%')
  let other_buffers = map(filter(s:getListedOrLoadedBuffers(), 'v:val.bufnr != current_buffer && v:val.name !~ "NERD_tree" && v:val.name !~ "__Tagbar__"'), 'v:val.bufnr')
  call s:DeleteBuffers(other_buffers, a:delete, a:bang)
endfunction

function! s:CloseThisBuffer(delete, bang)
  execute s:GetBufferDeleteCommand(a:delete, a:bang)
endfunction

" Helper functions
" --------------------
function! s:DeleteBuffers(buffer_numbers, delete, bang)
  if !empty(a:buffer_numbers)
      if a:delete
        execute s:GetBufferDeleteCommand(a:delete, a:bang) . ' ' . join(a:buffer_numbers)
      else
        for n in a:buffer_numbers
            execute s:GetBufferDeleteCommand(a:delete, a:bang) . ' ' . n
        endfor
      endif
  endif
endfunction

function! s:GetBufferDeleteCommand(delete, bang)
  if a:delete
    return 'bdelete' . (a:bang ? '!' : '')
  else
    return 'BufClose' . (a:bang ? '!' : '')
  endif
endfunction

function s:getListedOrLoadedBuffers()
  return filter(getbufinfo(), 'v:val.listed || v:val.loaded')
endfunction

" Teardown
" --------------------
let &cpo = s:save_cpo
unlet s:save_cpo
