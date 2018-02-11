" Vimball Archiver by Charles E. Campbell
UseVimball
finish
autoload/DeleteTrailingWhitespace.vim	[[[1
165
" DeleteTrailingWhitespace.vim: Delete unwanted whitespace at the end of lines.
"
" DEPENDENCIES:
"   - ShowTrailingWhitespace.vim autoload script (optional)
"
" Copyright: (C) 2012-2015 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.06.007	23-Feb-2015	FIX: Warning for nomodifiable buffer does not
"				consider buffer-local
"				b:DeleteTrailingWhitespace_Action.
"   1.05.006	13-Nov-2014	Corner case: Avoid "E21: Cannot make changes,
"				'modifiable' is off" on a nomodifiable buffer
"				when g:DeleteTrailingWhitespace_Action =
"				'delete', and instead just show a warning.
"   1.04.005	03-Dec-2013	Handle local exception regular expressions that
"				contain a "/" character. This must be escaped
"				for the :substitute/ command.
"   1.04.004	07-Aug-2013	Minor: Change error message wording slightly to
"				be more consistent with Vim's original.
"   1.02.003	14-Apr-2012	FIX: Avoid polluting search history.
"   1.00.002	14-Mar-2012	Support turning off highlighting of trailing
"				whitespace when the user answers the query with
"				"Never" or "Nowhere".
"	001	05-Mar-2012	file creation
let s:save_cpo = &cpo
set cpo&vim

function! DeleteTrailingWhitespace#Pattern()
    let l:pattern = '\s\+$'

    " The ShowTrailingWhitespace plugin can define exceptions where whitespace
    " should be kept; use that knowledge if it is available.
    silent! let l:pattern = ShowTrailingWhitespace#Pattern(0)

    return l:pattern
endfunction

function! DeleteTrailingWhitespace#Delete( startLnum, endLnum )
    let l:save_cursor = getpos('.')
    execute  a:startLnum . ',' . a:endLnum . 'substitute/' . escape(DeleteTrailingWhitespace#Pattern(), '/') . '//e'
    call histdel('search', -1) " @/ isn't changed by a function, cp. |function-search-undo|
    call setpos('.', l:save_cursor)
endfunction

function! DeleteTrailingWhitespace#HasTrailingWhitespace()
    " Note: In contrast to matchadd(), search() does consider the 'magic',
    " 'ignorecase' and 'smartcase' settings. However, I don't think this is
    " relevant for the whitespace pattern, and local exception regular
    " expressions can / should force this via \c / \C.
    return search(DeleteTrailingWhitespace#Pattern(), 'cnw')
endfunction

function! DeleteTrailingWhitespace#Get()
    return (exists('b:DeleteTrailingWhitespace') ? b:DeleteTrailingWhitespace : g:DeleteTrailingWhitespace)
endfunction
function! DeleteTrailingWhitespace#IsSet()
    let l:isSet = 0
    let l:value = DeleteTrailingWhitespace#Get()

    if empty(l:value) || l:value ==# '0'
	" Nothing to do.
    elseif l:value ==# 'highlighted'
	" Ask the ShowTrailingWhitespace plugin whether trailing whitespace is
	" highlighted here.
	silent! let l:isSet = ShowTrailingWhitespace#IsSet()
    elseif l:value ==# 'always' || l:value ==# '1'
	let l:isSet = 1
    else
	throw 'ASSERT: Invalid value for ShowTrailingWhitespace: ' . string(l:value)
    endif

    return l:isSet
endfunction

" Note: Could use ingo#plugin#setting#GetBufferLocal(), but avoid dependency to
" ingo-library for now.
function! DeleteTrailingWhitespace#GetAction()
    return (exists('b:DeleteTrailingWhitespace_Action') ?
    \	b:DeleteTrailingWhitespace_Action : g:DeleteTrailingWhitespace_Action)
endfunction
function! s:RecallResponse()
    " For the response, the global settings takes precedence over the local one.
    if exists('g:DeleteTrailingWhitespace_Response')
	return g:DeleteTrailingWhitespace_Response + 5
    elseif exists('b:DeleteTrailingWhitespace_Response')
	return b:DeleteTrailingWhitespace_Response + 3
    else
	return -1
    endif
endfunction
function! DeleteTrailingWhitespace#IsAction()
    let l:action = DeleteTrailingWhitespace#GetAction()
    if l:action ==# 'delete'
	return 1
    elseif l:action ==# 'abort'
	if ! v:cmdbang && DeleteTrailingWhitespace#HasTrailingWhitespace()
	    " Note: Defining a no-op BufWriteCmd only comes into effect on the
	    " next write, but does not affect the current one. Since we don't
	    " want to install such an autocmd across the board, the best we can
	    " do is throwing an exception to abort the write.
	    throw 'DeleteTrailingWhitespace: Trailing whitespace found, aborting write (add ! to override, or :DeleteTrailingWhitespace to eradicate)'
	endif
    elseif l:action ==# 'ask'
	if v:cmdbang || ! DeleteTrailingWhitespace#HasTrailingWhitespace()
	    return 0
	endif

	let l:recalledResponse = s:RecallResponse()
	let l:response = (l:recalledResponse == -1 ?
	\   confirm('Trailing whitespace found, delete it?', "&No\n&Yes\nNe&ver\n&Always\nNowhere\nAnywhere\n&Cancel write", 1, 'Question') :
	\   l:recalledResponse
	\)
	if     l:response == 1
	    return 0
	elseif l:response == 2
	    return 1
	elseif l:response == 3
	    let b:DeleteTrailingWhitespace_Response = 0

	    if g:DeleteTrailingWhitespace_ChoiceAffectsHighlighting
		silent! call ShowTrailingWhitespace#Set(0, 0)
	    endif

	    return 0
	elseif l:response == 4
	    let b:DeleteTrailingWhitespace_Response = 1
	    return 1
	elseif l:response == 5
	    let g:DeleteTrailingWhitespace_Response = 0

	    if g:DeleteTrailingWhitespace_ChoiceAffectsHighlighting
		silent! call ShowTrailingWhitespace#Set(0, 1)
	    endif

	    return 0
	elseif l:response == 6
	    let g:DeleteTrailingWhitespace_Response = 1
	    return 1
	else
	    throw 'DeleteTrailingWhitespace: Trailing whitespace found, aborting write (use ! to override, or :DeleteTrailingWhitespace to eradicate)'
	endif
    else
	throw 'ASSERT: Invalid value for DeleteTrailingWhitespace_Action: ' . string(l:action)
    endif
endfunction

function! DeleteTrailingWhitespace#InterceptWrite()
    if DeleteTrailingWhitespace#IsSet() && DeleteTrailingWhitespace#IsAction()
	if ! &l:modifiable && DeleteTrailingWhitespace#GetAction() ==# 'delete'
	    call ingo#msg#WarningMsg('Cannot automatically delete trailing whitespace, buffer is not modifiable')
	    sleep 1 " Need a delay as the message is overwritten by :write.
	    return
	endif

	call DeleteTrailingWhitespace#Delete(1, line('$'))
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
plugin/DeleteTrailingWhitespace.vim	[[[1
67
" DeleteTrailingWhitespace.vim: Delete unwanted whitespace at the end of lines.
"
" DEPENDENCIES:
"   - DeleteTrailingWhitespace.vim autoload script.
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.04.006	14-Jun-2013	Minor: Make substitute() robust against
"				'ignorecase'.
"   1.04.005	28-Dec-2012	Minor: Correct lnum for no-modifiable buffer
"				check.
"   1.03.004	19-Apr-2012	Handle readonly and nomodifiable buffers by
"				printing just the warning / error, without
"				the multi-line function error.
"   1.01.003	04-Apr-2012	Define command with -bar so that it can be
"				chained.
"   1.00.002	14-Mar-2012	Support turning off highlighting of trailing
"				whitespace when the user answers the query with
"				"Never" or "Nowhere".
"	001	05-Mar-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_DeleteTrailingWhitespace') || (v:version < 700)
    finish
endif
let g:loaded_DeleteTrailingWhitespace = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:DeleteTrailingWhitespace')
    let g:DeleteTrailingWhitespace = 'highlighted'
endif
if ! exists('g:DeleteTrailingWhitespace_Action')
    let g:DeleteTrailingWhitespace_Action = 'abort'
endif
if ! exists('g:DeleteTrailingWhitespace_ChoiceAffectsHighlighting')
    let g:DeleteTrailingWhitespace_ChoiceAffectsHighlighting = 1
endif



"- autocmds --------------------------------------------------------------------

augroup DeleteTrailingWhitespace
    autocmd!
    autocmd BufWritePre * try | call DeleteTrailingWhitespace#InterceptWrite() | catch /^DeleteTrailingWhitespace:/ | echoerr substitute(v:exception, '^\CDeleteTrailingWhitespace:\s*', '', '') | endtry
augroup END


"- commands --------------------------------------------------------------------

function! s:Before()
    let s:isModified = &l:modified
endfunction
    function! s:After()
	if ! s:isModified
	    setlocal nomodified
	endif
	unlet s:isModified
    endfunction
command! -bar -range=% DeleteTrailingWhitespace call <SID>Before()<Bar>call setline(<line1>, getline(<line1>))<Bar>call <SID>After()<Bar>call DeleteTrailingWhitespace#Delete(<line1>, <line2>)

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
doc/DeleteTrailingWhitespace.txt	[[[1
162
*DeleteTrailingWhitespace.txt*	Delete unwanted whitespace at the end of lines.

		 DELETE TRAILING WHITESPACE    by Ingo Karkat
						*DeleteTrailingWhitespace.vim*
description			|DeleteTrailingWhitespace-description|
usage				|DeleteTrailingWhitespace-usage|
installation			|DeleteTrailingWhitespace-installation|
configuration			|DeleteTrailingWhitespace-configuration|
limitations			|DeleteTrailingWhitespace-limitations|
known problems			|DeleteTrailingWhitespace-known-problems|
todo				|DeleteTrailingWhitespace-todo|
history				|DeleteTrailingWhitespace-history|

==============================================================================
DESCRIPTION				*DeleteTrailingWhitespace-description*

This plugin deletes whitespace at the end of each line, on demand via the
:DeleteTrailingWhitespace command, or automatically when the buffer is
written.

SEE ALSO								     *

This plugin leverages the superior detection and customization facilities of
the companion |ShowTrailingWhitespace.vim| plugin (vimscript #3966), though it
can also be used without it if you're not interested in highlighting and
customizing.

To quickly locate the occurrences of trailing whitespace, you can use the
companion |JumpToTrailingWhitespace.vim| plugin (vimscript #3968).

RELATED WORKS								     *

The basic substitution commands as well as more elaborate scriptlets, as the
idea of automating this can be found in this VimTip:
    http://vim.wikia.com/wiki/Remove_unwanted_spaces
There are already a number of plugins that define such a command; most bundle
this functionality together with the highlighting of trailing whitespace.
However, most of them cannot consider whitespace exceptions and are not as
flexible.
- trailing-whitespace (vimscript #3201) defines :FixWhitespace.
- bad-whitespace (vimscript #3735) defines :EraseBadWhitespace.
- Trailer Trash (vimscript #3938) defines :Trim.
- StripWhiteSpaces (vimscript #4016) defines :StripWhiteSpaces and strips
  automatically, too, but is way more simple than this plugin.
- WhiteWash (vimscript #3920) provides functions that also can strip visible
  ^M and sequential whitespacw between words.

==============================================================================
USAGE					      *DeleteTrailingWhitespace-usage*
						   *:DeleteTrailingWhitespace*
:[range]DeleteTrailingWhitespace
			Delete all trailing whitespace in the current buffer
			or [range].

==============================================================================
INSTALLATION			       *DeleteTrailingWhitespace-installation*

This script is packaged as a |vimball|. If you have the "gunzip" decompressor
in your PATH, simply edit the *.vmb.gz package in Vim; otherwise, decompress
the archive first, e.g. using WinZip. Inside Vim, install by sourcing the
vimball or via the |:UseVimball| command. >
    vim DeleteTrailingWhitespace*.vmb.gz
    :so %
To uninstall, use the |:RmVimball| command.

DEPENDENCIES			       *DeleteTrailingWhitespace-dependencies*

- Requires Vim 7.0 or higher.
- The |ShowTrailingWhitespace.vim| plugin (vimscript #3966) complements this
  script, but is not required. With it, this plugin considers the whitespace
  exceptions for certain filetypes.

==============================================================================
CONFIGURATION			      *DeleteTrailingWhitespace-configuration*

For a permanent configuration, put the following commands into your |vimrc|:

					   *DeleteTrailingWhitespace-mappings*
This plugin doesn't come with predefined mappings, but if you want some, you
can trivially define them yourself: >
    nnoremap <Leader>d$ :<C-u>%DeleteTrailingWhitespace<CR>
    vnoremap <Leader>d$ :DeleteTrailingWhitespace<CR>
<
						  *g:DeleteTrailingWhitespace*
By default, trailing whitespace is processed before writing the buffer when it
has been detected and is currently being highlighted by the
|ShowTrailingWhitespace.vim| plugin.
To turn off the automatic deletion of trailing whitespace, use: >
    let g:DeleteTrailingWhitespace = 0
If you want to eradicate all trailing whitespace all the time, use: >
    let g:DeleteTrailingWhitespace = 1
<
					   *g:DeleteTrailingWhitespace_Action*
For processing, the default action is aborting the write, unless ! is given.
To automatically eradicate the trailing whitespace, use: >
    let g:DeleteTrailingWhitespace_Action = 'delete'
To ask whether to remove or keep the whitespace (either for the current
buffer, or all buffers in the entire Vim session), use: >
    let g:DeleteTrailingWhitespace_Action = 'ask'
<
			*g:DeleteTrailingWhitespace_ChoiceAffectsHighlighting*
When the plugin is configured to ask the user, and she answers the query with
"Never" or "Nowhere", the |ShowTrailingWhitespace.vim| highlighting is turned
off automatically; when you ignore it, there's typically no sense in still
highlighting it. If you don't want that, turn it off via: >
    let g:DeleteTrailingWhitespace_ChoiceAffectsHighlighting = 0
<

	      *b:DeleteTrailingWhitespace* *b:DeleteTrailingWhitespace_Action*
The global detection and processing behavior can be changed for individual
buffers by setting the corresponding buffer-local variables.

==============================================================================
LIMITATIONS				*DeleteTrailingWhitespace-limitations*

KNOWN PROBLEMS			     *DeleteTrailingWhitespace-known-problems*

TODO					       *DeleteTrailingWhitespace-todo*

IDEAS					      *DeleteTrailingWhitespace-ideas*

==============================================================================
HISTORY					    *DeleteTrailingWhitespace-history*

1.06	24-Feb-2015
- FIX: Warning for nomodifiable buffer does not consider buffer-local
  b:DeleteTrailingWhitespace_Action (after version 1.05).

1.05	12-Dec-2014
- Corner case: Avoid "E21: Cannot make changes, 'modifiable' is off" on a
  nomodifiable buffer when g:DeleteTrailingWhitespace_Action = 'delete', and
  instead just show a warning. Thanks to Enno Nagel for raising this issue.

1.04	14-Dec-2013
- Minor: Make substitute() robust against 'ignorecase'.
- Minor: Correct lnum for no-modifiable buffer check.
- Handle local exception regular expressions that contain a "/" character.
  This must be escaped for the :substitute/ command.

1.03	19-Apr-2012
Handle readonly and nomodifiable buffers by printing just the warning / error,
without the multi-line function error.

1.02	14-Apr-2012
FIX: Avoid polluting search history.

1.01	04-Apr-2012
Define command with -bar so that it can be chained.

1.00	16-Mar-2012
First published version.

0.01	05-Mar-2012
Started development.

==============================================================================
Copyright: (C) 2012-2015 Ingo Karkat
The VIM LICENSE applies to this plugin; see |copyright|.

Maintainer:	Ingo Karkat <ingo@karkat.de>
==============================================================================
 vim:tw=78:ts=8:ft=help:norl:
