" Verify if already loaded
if exists("loaded_DoxygenToolkit")
	"echo 'DoxygenToolkit Already Loaded.'
	finish
endif
let loaded_DoxygenToolkit = 1
"echo 'Loading DoxygenToolkit...'
let s:licenseTag = "Copyright (C) \<enter>"
let s:licenseTag = s:licenseTag . "This program is free software; you can redistribute it and/or\<enter>"
let s:licenseTag = s:licenseTag . "modify it under the terms of the GNU General Public License\<enter>"
let s:licenseTag = s:licenseTag . "as published by the Free Software Foundation; either version 2\<enter>"
let s:licenseTag = s:licenseTag . "of the License, or (at your option) any later version.\<enter>\<enter>"
let s:licenseTag = s:licenseTag . "This program is distributed in the hope that it will be useful,\<enter>"
let s:licenseTag = s:licenseTag . "but WITHOUT ANY WARRANTY; without even the implied warranty of\<enter>"
let s:licenseTag = s:licenseTag . "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\<enter>"
let s:licenseTag = s:licenseTag . "GNU General Public License for more details.\<enter>\<enter>"
let s:licenseTag = s:licenseTag . "You should have received a copy of the GNU General Public License\<enter>"
let s:licenseTag = s:licenseTag . "along with this program; if not, write to the Free Software\<enter>"
let s:licenseTag = s:licenseTag . "Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.\<enter>"

" Common standard constants
if !exists("g:DoxygenToolkit_briefTag_pre")
	let g:DoxygenToolkit_briefTag_pre = "\\brief "
endif
if !exists("g:DoxygenToolkit_briefTag_post")
	let g:DoxygenToolkit_briefTag_post = ""
endif
if !exists("g:DoxygenToolkit_internalTag")
	let g:DoxygenToolkit_internalTag = "\\internal "
endif
if !exists("g:DoxygenToolkit_paramTag_pre")
	let g:DoxygenToolkit_paramTag_pre = "\\param "
endif
if !exists("g:DoxygenToolkit_paramTag_post")
	let g:DoxygenToolkit_paramTag_post = "     : "
endif
if !exists("g:DoxygenToolkit_returnTag")
	let g:DoxygenToolkit_returnTag = "\\return : "
endif
if !exists("g:DoxygenToolkit_retvalTag")
	let g:DoxygenToolkit_retvalTag = "\\retval XX : "
endif
if !exists("g:DoxygenToolkit_licenseTag")
	let g:DoxygenToolkit_licenseTag = s:licenseTag
endif
if !exists("g:DoxygenToolkit_fileTag")
	let g:DoxygenToolkit_fileTag = "\\file "
endif
if !exists("g:DoxygenToolkit_RevisionTag")
	let g:DoxygenToolkit_RevisionTag = "\$Revision: \$ "
endif
if !exists("g:DoxygenToolkit_authorTag")
	let g:DoxygenToolkit_authorTag = "\$Author: \$ "
endif
if !exists("g:DoxygenToolkit_dateTag")
	let g:DoxygenToolkit_dateTag = "\$Date: \$ "
endif
if !exists("g:DoxygenToolkit_undocTag")
	let g:DoxygenToolkit_undocTag = "DOX_SKIP_BLOCK"
endif
if !exists("g:DoxygenToolkit_classTag")
	let g:DoxygenToolkit_classTag = "\\class "
endif
if !exists("g:DoxygenToolkit_versionTag")
	let g:DoxygenToolkit_versionTag = "\\version "
endif
if !exists("g:DoxygenToolkit_ingroupTag")
	let g:DoxygenToolkit_ingroupTag = "\\ingroup "
endif

if !exists("g:DoxygenToolkit_cinoptions")
    let g:DoxygenToolkit_cinoptions = "c1C1"
endif
if !exists("g:DoxygenToolkit_shortCommentTag ")
	let g:DoxygenToolkit_shortCommentTag = "//!"
endif
if !exists("g:DoxygenToolkit_startCommentTag ")
	let g:DoxygenToolkit_startCommentTag = "/*!"
endif
if !exists("g:DoxygenToolkit_interCommentTag ")
	let g:DoxygenToolkit_interCommentTag = " *  "
endif
if !exists("g:DoxygenToolkit_endCommentTag ")
	let g:DoxygenToolkit_endCommentTag = " */"
	let g:DoxygenToolkit_endCommentBlock = " */"
endif

if !exists("g:DoxygenToolkit_ignoreForReturn")
	let g:DoxygenToolkit_ignoreForReturn = "inline static virtual void"
else
	let g:DoxygenToolkit_ignoreForReturn = g:DoxygenToolkit_ignoreForReturn . " inline static virtual void"
endif

" Maximum number of lines to check for function parameters
if !exists("g:DoxygenToolkit_maxFunctionProtoLines")
	let g:DoxygenToolkit_maxFunctionProtoLines = 10
endif

" Add name of function after pre brief tag if you want
if !exists("g:DoxygenToolkit_briefTag_funcName")
	let g:DoxygenToolkit_briefTag_funcName = "no"
endif


""""""""""""""""""""""""""
" Doxygen comment function 
""""""""""""""""""""""""""
function! <SID>DoxygenCommentFunc()
	" Store indentation
	let l:oldcinoptions = &cinoptions
	" Set new indentation
	let &cinoptions=g:DoxygenToolkit_cinoptions
	
	let l:argBegin = "\("
	let l:argEnd = "\)"
	let l:argSep = ','
	let l:sep = "\ "
	let l:voidStr = "void"

	let l:classDef = 0

	" Save standard comment expension
	let l:oldComments = &comments
	let &comments = ""

	" Store function in a buffer
	let l:lineBuffer = getline(line("."))
	mark d
	let l:count=1
	" Return of function can be defined on other line than the one of the 
	" function.
	while ( l:lineBuffer !~ l:argBegin && l:count < 4 )
		" This is probbly a class (or something else definition)
		if ( l:lineBuffer =~ "{" || l:lineBuffer =~ ";" )
			let l:classDef = 1
			break
		endif
		exec "normal j"
		let l:line = getline(line("."))
		let l:lineBuffer = l:lineBuffer . ' ' . l:line
		let l:count = l:count + 1
	endwhile
	if ( l:classDef == 0 )
		if ( l:count == 4 )
			" Restore standard comment expension
			let &comments = l:oldComments 
			" Restore indentation
			let &cinoptions = l:oldcinoptions
			return
		endif
		" Get the entire function
		let l:count = 0
		while ( l:lineBuffer !~ l:argEnd && l:count < g:DoxygenToolkit_maxFunctionProtoLines )
			exec "normal j"
			let l:line = getline(line("."))
			let l:lineBuffer = l:lineBuffer . ' ' . l:line
			let l:count = l:count + 1
		endwhile
		" Function definition seem to be too long...
		if ( l:count == g:DoxygenToolkit_maxFunctionProtoLines )
			" Restore standard comment expension
			let &comments = l:oldComments 
			" Restore indentation
			let &cinoptions = l:oldcinoptions
			return
		endif
	endif

	" Start creating doxygen pattern
	exec "normal `d" 
	exec "normal O" . g:DoxygenToolkit_shortCommentTag
	exec "normal o" . g:DoxygenToolkit_startCommentTag
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_internalTag
	mark d
	if ( g:DoxygenToolkit_endCommentTag != "" )
		exec "normal o" . g:DoxygenToolkit_endCommentTag
	endif
	exec "normal `d"

	" Class definition, let's start with brief tag
	if ( l:classDef == 1 )
		" Restore standard comment expension
		let &comments = l:oldComments 
		" Restore indentation
		let &cinoptions = l:oldcinoptions

		startinsert!
		return
	endif

	" Replace tabs by space
	let l:lineBuffer = substitute(l:lineBuffer, "\t", "\ ", "g")

	" Delete recursively all double spaces
	while ( match(l:lineBuffer, "\ \ ") != -1 )
		let l:lineBuffer = substitute(l:lineBuffer, "\ \ ", "\ ", "g")
	endwhile

	" Delete space just after and just before parenthesis
	" Remove space between function name and opening paenthesis
	let l:lineBuffer = substitute(l:lineBuffer, "(\ ", "(", "")
	let l:lineBuffer = substitute(l:lineBuffer, "\ )", ")", "")
	let l:lineBuffer = substitute(l:lineBuffer, "\ (", "(", "")

	" Delete first space (if any)
	if ( match(l:lineBuffer, ' ') == 0 )
		let l:lineBuffer = strpart(l:lineBuffer, 1)
	endif

	" Add function name if requiered
	if ( g:DoxygenToolkit_briefTag_funcName =~ "yes" )
		let l:beginP = 0
		let l:currentP = -1
		let l:endP = match( l:lineBuffer, l:argBegin )
		while ( l:currentP < l:endP )
			let l:beginP = l:currentP + 1
			let l:currentP = match( l:lineBuffer, '[&*[:space:]]', l:beginP )
			if ( l:currentP == -1 )
				let l:currentP = l:endP
			endif
		endwhile
		let l:name = strpart( l:lineBuffer, l:beginP, l:endP - l:beginP )
		exec "normal A" . l:name
	endif

	" Now can add brief post tag
	exec "normal A" . g:DoxygenToolkit_briefTag_post

	" Add return tag if function do not return void
	let l:beginArgPos = match(l:lineBuffer, l:argBegin)
	let l:beginP = 0	" Name can start at the beginning of l:lineBuffer, it is usually between whitespaces or space and parenthesis
	let l:endP = 0
	let l:returnFlag = -1	" At least one name (function name) do not correspond to the list of ignored values.
	while ( l:endP != l:beginArgPos )
		" look for  * or & (pointer or reference)
		let l:endP = match(l:lineBuffer, '[&*]', l:beginP )
		if ( l:endP > l:beginArgPos || l:endP == -1 )
			" not found --> look for whitespace
			let l:endP = match(l:lineBuffer, '\s', l:beginP )
			if ( l:endP > l:beginArgPos || l:endP == -1 )
				let l:endP = l:beginArgPos
			endif
		else
			" found * or & -- so we have a return value
			let l:returnFlag = l:returnFlag + 1
		endif
		let l:name = strpart(l:lineBuffer, l:beginP, l:endP - l:beginP)
		let l:beginP = l:endP + 1
		" Hack, because of '~' is not correctly interprated by match... if you
		" have a solution, send me it !
		if ( l:name[0] != '~' && matchstr(g:DoxygenToolkit_ignoreForReturn, "\\<" . l:name . "\\>") != l:name )
			let l:returnFlag = l:returnFlag + 1
		endif
	endwhile
	exec "normal o" . g:DoxygenToolkit_interCommentTag
	if ( l:returnFlag >= 1 )	
		exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_returnTag
		exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_retvalTag
	else
		exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_returnTag . "なし"
	endif

	" Looking for argument name in line buffer
	exec "normal `d"
	let l:argList = 0    " ==0 -> no argument, !=0 -> at least one arg

	let l:beginP = 0
	let l:endP = 0
	let l:prevBeginP = 0

	" Arguments start after opening parenthesis
	let l:beginP = match(l:lineBuffer, l:argBegin, l:beginP) + 1
	let l:prevBeginP = l:beginP
	let l:endP = l:beginP

	" Test if there is something into parenthesis
	let l:beginP = l:beginP
	if ( l:beginP == match(l:lineBuffer, l:argEnd, l:beginP) )
		" Restore standard comment expension
		let &comments = l:oldComments 
		" Restore indentation
		let &cinoptions = l:oldcinoptions

		exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_paramTag_pre . g:DoxygenToolkit_paramTag_post . "なし"
		startinsert!
		return
	endif

	" Enter into main loop
	while ( l:beginP > 0 && l:endP > 0 )

		" Looking for arg separator
		let l:endP1 = match(l:lineBuffer, l:argSep, l:beginP)
		let l:endP = match(l:lineBuffer, l:argEnd, l:beginP)
		if ( l:endP1 != -1 && l:endP1 < l:endP )
			let l:endP = l:endP1
		endif
		let l:endP = l:endP - 1

		if ( l:endP > 0 )
			let l:strBuf = ReturnArgName(l:lineBuffer, l:beginP, l:endP)
			" void parameter
			if ( l:strBuf == l:voidStr )
				" Restore standard comment expension
				let &comments = l:oldComments 
				" Restore indentation
				let &cinoptions = l:oldcinoptions
				
				exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_paramTag_pre . g:DoxygenToolkit_paramTag_post . "なし"
				startinsert!
				break
			endif
			let l:argType = ReturnArgType(l:lineBuffer, l:beginP, l:endP)
			if 1 == l:argType
				exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_paramTag_pre . "[in,out] " . l:strBuf . g:DoxygenToolkit_paramTag_post
			elseif 2 == l:argType
				exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_paramTag_pre . "[in]     " . l:strBuf . g:DoxygenToolkit_paramTag_post . "未使用"
			elseif 3 == l:argType
				exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_paramTag_pre . "[in,out] " . l:strBuf . g:DoxygenToolkit_paramTag_post . "未使用"
			else
				exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_paramTag_pre . "[in]     " . l:strBuf . g:DoxygenToolkit_paramTag_post
			endif
			let l:beginP = l:endP + 2
			let l:argList = 1
		endif
	endwhile

	" Add blank line if necessary
	if ( l:argList != 0 )
		exec "normal `do" . g:DoxygenToolkit_interCommentTag
	endif

	" move the cursor to the correct position (after brief tag)
	exec "normal `d"
	 
	" Restore standard comment expension
	let &comments = l:oldComments 
	" Restore indentation
	let &cinoptions = l:oldcinoptions

	startinsert!
endfunction


""""""""""""""""""""""""""
" Doxygen license comment
""""""""""""""""""""""""""
function! <SID>DoxygenLicenseFunc()
	" Store indentation
	let l:oldcinoptions = &cinoptions
	" Set new indentation
	let &cinoptions=g:DoxygenToolkit_cinoptions

	" Test authorName variable
	if !exists("g:DoxygenToolkit_authorName")
		let g:DoxygenToolkit_authorName = input("Enter name of the author (generally yours...) : ")
	endif
	mark d
	let l:date = strftime("%Y")
	exec "normal O/*\<Enter>" . g:DoxygenToolkit_licenseTag
	exec "normal ^c$*/"
	if ( g:DoxygenToolkit_licenseTag == s:licenseTag )
		exec "normal %jA" . l:date . " - " . g:DoxygenToolkit_authorName
	endif
	exec "normal `d"

	" Restore indentation
	let &cinoptions = l:oldcinoptions
endfunction


""""""""""""""""""""""""""
" Doxygen author comment
""""""""""""""""""""""""""
function! <SID>DoxygenAuthorFunc()
	" Save standard comment expension
	let l:oldComments = &comments
	let &comments = ""
	" Store indentation
	let l:oldcinoptions = &cinoptions
	" Set new indentation
	let &cinoptions=g:DoxygenToolkit_cinoptions

	" Get file name
	let l:fileName = expand('%:t')

	" Begin to write skeleton
	exec "normal O" . g:DoxygenToolkit_startCommentTag
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_fileTag . l:fileName
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_briefTag_pre
	mark d
	exec "normal o" . g:DoxygenToolkit_interCommentTag
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_dateTag
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_authorTag
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_RevisionTag
	exec "normal o" . g:DoxygenToolkit_interCommentTag
	let l:date = strftime("%Y")
	exec "normal o" . g:DoxygenToolkit_interCommentTag . "Copyright (c) " . l:date . " Tokyo Electron Limited."
	exec "normal o" . g:DoxygenToolkit_interCommentTag . "All rights reserved."
	if ( g:DoxygenToolkit_endCommentTag == "" )
		exec "normal o" . g:DoxygenToolkit_interCommentTag
	else
		exec "normal o" . g:DoxygenToolkit_endCommentTag
	endif

	" Replace the cursor to the rigth position
	exec "normal `d"

	" Restore standard comment expension
	let &comments = l:oldComments
	" Restore indentation
	let &cinoptions = l:oldcinoptions
	startinsert!
endfunction


""""""""""""""""""""""""""
" Doxygen class comment
""""""""""""""""""""""""""
function! <SID>DoxygenClassFunc()
	" Save standard comment expension
	let l:oldComments = &comments
	let &comments = ""
	" Store indentation
	let l:oldcinoptions = &cinoptions
	" Set new indentation
	let &cinoptions=g:DoxygenToolkit_cinoptions

	" Get file name
	let l:fileName = expand('%:t:r')

	" Begin to write skeleton
	exec "normal O" . g:DoxygenToolkit_startCommentTag
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_classTag . l:fileName . " [" . l:fileName . ".h]"
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_briefTag_pre
	mark d
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_versionTag . "0.1"
	exec "normal o" . g:DoxygenToolkit_interCommentTag . g:DoxygenToolkit_ingroupTag
	exec "normal o" . g:DoxygenToolkit_interCommentTag
	exec "normal o" . g:DoxygenToolkit_interCommentTag
	if ( g:DoxygenToolkit_endCommentTag == "" )
		exec "normal o" . g:DoxygenToolkit_interCommentTag
	else
		exec "normal o" . g:DoxygenToolkit_endCommentTag
	endif

	" Replace the cursor to the rigth position
	exec "normal `d"

	" Restore standard comment expension
	let &comments = l:oldComments
	" Restore indentation
	let &cinoptions = l:oldcinoptions
	startinsert!
endfunction



""""""""""""""""""""""""""
" Extract the name of argument
""""""""""""""""""""""""""
function ReturnArgName(argBuf, beginP, endP)

	" Name of argument is at the end of argBuf if no default (id arg = 0)
	let l:equalP = match(a:argBuf, "=", a:beginP)
	if ( l:equalP == -1 || l:equalP > a:endP )
		" Look for arg name begining
		let l:beginP = a:beginP 
		let l:prevBeginP = l:beginP
		while ( l:beginP < a:endP && l:beginP != -1 )
			let l:prevBeginP = l:beginP
			let l:beginP = match(a:argBuf, " ", l:beginP + 1)
		endwhile
		let l:beginP = l:prevBeginP
		let l:endP = a:endP
	else
		" Look for arg name begining
		let l:addPos = 0
		let l:beginP = a:beginP
		let l:prevBeginP = l:beginP
		let l:doublePrevBeginP = l:prevBeginP
		while ( l:beginP < l:equalP && l:beginP != -1 )
			let l:doublePrevBeginP = l:prevBeginP
			let l:prevBeginP = l:beginP + l:addPos
			let l:beginP = match(a:argBuf, " ", l:beginP + 1)
			let l:addPos = 1
		endwhile

		" Space just before equal
		if ( l:prevBeginP == l:equalP )
			let l:beginP = l:doublePrevBeginP
			let l:endP = l:prevBeginP - 2
		else
			" No space just before so...
			let l:beginP = l:prevBeginP
			let l:endP = l:equalP - 1
		endif
	endif

	" We have the begining position and the ending position...
	let l:newBuf = strpart(a:argBuf, l:beginP, l:endP - l:beginP + 1)

	" Delete leading '*' or '&'
	if ( match( l:newBuf, "\*") > 0 )
		let l:newBuf = substitute( l:newBuf, "\*", "", "" )
	elseif ( match( l:newBuf, "\&") > 0 )
		let l:newBuf = substitute( l:newBuf, "\&", "", "" )
	endif

	" Delete tab definition ([])
	let l:delTab = match(newBuf, "[") 
	if ( l:delTab != -1 )
		let l:newBuf = strpart(l:newBuf, 0, l:delTab)
	endif

	" Eventually clean argument name...
	let l:newBuf = substitute(l:newBuf, " ", "", "g")
	return l:newBuf

endfunction



""""""""""""""""""""""""""
" Extract argument type
""""""""""""""""""""""""""
function ReturnArgType(argBuf, beginP, endP)

	let l:argStrCount = 0
	let l:referanceFlag = 0

	" Name of argument is at the end of argBuf if no default (id arg = 0)
	let l:equalP = match(a:argBuf, "=", a:beginP)
	if ( l:equalP == -1 || l:equalP > a:endP )
		" Look for arg name begining
		let l:beginP = a:beginP 
		let l:prevBeginP = l:beginP
		while ( l:beginP < a:endP && l:beginP != -1 )
			let l:argStrCount = l:argStrCount + 1
			let l:prevBeginP = l:beginP
			let l:beginP = match(a:argBuf, " ", l:beginP + 1)
		endwhile
		let l:beginP = l:prevBeginP
		let l:endP = a:endP
	else
		" Look for arg name begining
		let l:addPos = 0
		let l:beginP = a:beginP
		let l:prevBeginP = l:beginP
		let l:doublePrevBeginP = l:prevBeginP
		while ( l:beginP < l:equalP && l:beginP != -1 )
			let l:doublePrevBeginP = l:prevBeginP
			let l:prevBeginP = l:beginP + l:addPos
			let l:beginP = match(a:argBuf, " ", l:beginP + 1)
			let l:addPos = 1
		endwhile

		" Space just before equal
		if ( l:prevBeginP == l:equalP )
			let l:beginP = l:doublePrevBeginP
			let l:endP = l:prevBeginP - 2
		else
			" No space just before so...
			let l:beginP = l:prevBeginP
			let l:endP = l:equalP - 1
		endif
	endif

	" We have the begining position and the ending position...
	let l:newBuf = strpart(a:argBuf, a:beginP, l:endP - a:beginP + 1)

	" Delete leading '*' or '&'
	if ( match(l:newBuf, "\*") > 0 || match(l:newBuf, "\&") > 0 )
		if 1 != l:argStrCount
			if 2 < l:argStrCount && match(l:newBuf, "const") > 0
				return 0 " [in] 出力
			elseif match(l:newBuf, "const") < 0
				return 1 " [in,out] 出力
			endif
		endif
		let l:referanceFlag = 1
	endif

	if 1 == l:argStrCount || (2 == l:argStrCount && match(l:newBuf, "const") > 0)
		return 2 + l:referanceFlag " 未使用 出力
	endif

	return 0 " [in] 出力

endfunction



""""""""""""""""""""""""""
" Shortcuts...
""""""""""""""""""""""""""
command! -nargs=0 Dox :call <SID>DoxygenCommentFunc()
command! -nargs=0 DoxAuthor :call <SID>DoxygenAuthorFunc()
command! -nargs=0 DoxClass :call <SID>DoxygenClassFunc()
