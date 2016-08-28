source $VIMRUNTIME/syntax/c.vim

" matches All upper+number words as macro
syn match cMacro '\<\%(__\)\?\u\+\%(_\?\%(\u\|\d\)\+\)*\>' display

" Highlight Function names
syn match    cCustomFunc     "\<\w\+\s*("me=e-1 

" c function declare, matches "returnType name(param)"
syn match    cMethod "\v^\s*\zs%(\w+ )*\w+\s*\**\s*<\w+\s*\([^)]*\)\_s*[;{]"me=e-1 transparent contains=cMethodReturnPart,cMethodParam,cMethodName
syn match cMethodParam "\v%(%(__)?\w+ )*\w+\s*\**\ze\s*<\w+\_s*[,)]"he=e-1 contained nextgroup=cMethodParamName skipwhite display contains=cStorageClass,cType
syn match cMethodParamName "\<\w\+" contained display
syn match cMethodReturnPart "\v%(\w+ )*\w+\ze\s*\**\s*<\w+\s*\(" contained display contains=cStorageClass,cType
syn match cMethodName "\<\w\+\s*("me=e-1 contained display

" prevent include by ALL
"syn cluster cIncludeOnlyGroup contains=cMethodParam,cMethodParamName,cMethodReturnPart,cMethodName
"syn cluster cMultiGroup add=@cIncludeOnlyGroup
"syn cluster cPreProcGroup add=@cIncludeOnlyGroup
"syn cluster cParenGroup add=@cIncludeOnlyGroup

" highlight
hi def link cMacro cConstant
hi def link cMethodName  Function
hi def link cMethodReturnPart StorageClass
hi def link cMethodParam StorageClass
hi def link cCustomFunc  Function
