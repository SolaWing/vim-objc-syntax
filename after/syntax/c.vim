"if exists("b:current_syntax")
"  finish
"endif

" redefine cStorageClass, so some keyword has lower priority and cMethod can be
" recognizd
syn clear cStorageClass
syn keyword	cStorageClass	register auto volatile extern 
syn match cStorageClass "static\|const\|inline"
if exists("c_gnu")
  syn keyword	cStorageClass	__attribute__
endif
if !exists("c_no_c99")
  syn keyword	cStorageClass	restrict
endif
if !exists("c_no_c11")
  syn keyword	cStorageClass	_Alignas alignas
  syn keyword	cStorageClass	_Atomic
  syn keyword	cStorageClass	_Noreturn noreturn
  syn keyword	cStorageClass	_Thread_local thread_local
endif

" matches All upper words as macro
syn match cMacro '\<\%(__\)\?\u\+\%(_\?\u\+\)*\>' display

" Highlight Function names
syn match    cCustomFunc     "\<\w\+\s*("me=e-1 

" c function declare, matches "returnType name(param)"
syn match    cMethod "\v^\s*\zs%(\w+ )*\w+\s*\**\s*<\w+\s*\([^)]*\)\_s*[;{]"me=e-1 transparent contains=cMethodReturnPart,cMethodParam,cMethodName
syn match cMethodParam "\v%(%(__)?\w+ )*\w+\s*\**\ze\s*<\w+\_s*[,)]"he=e-1 contained nextgroup=cMethodParamName skipwhite display contains=cStorageClass,cType
syn match cMethodParamName "\<\w\+" contained display
syn match cMethodReturnPart "\v%(\w+ )*\w+\ze\s*\**\s*<\w+\s*\(" contained display contains=cStorageClass,cType
syn match cMethodName "\<\w\+\s*("me=e-1 contained display

" prevent include by ALL
syn cluster cIncludeOnlyGroup contains=cMethodParam,cMethodParamName,cMethodReturnPart,cMethodName
syn cluster cMultiGroup add=@cIncludeOnlyGroup
syn cluster cPreProcGroup add=@cIncludeOnlyGroup
syn cluster cParenGroup add=@cIncludeOnlyGroup

" highlight
hi def link cMacro cConstant
hi def link cMethodName  Special
hi def link cMethodReturnPart StorageClass
hi def link cMethodParam StorageClass
hi def link cCustomFunc  Function
