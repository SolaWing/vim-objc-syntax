" Vim syntax file
" Language:     Objective-C
" Maintainer:   SolaWing <github.com/SolaWing>

" NOTE:    This next file (cocoa_keywords.vim) is rather large and may slow
"          things down. if it is slow for you, just comment out the next line.
ru after/syntax/cocoa_keywords.vim

" this syntax cost some time and rarely match, so clear it
syn clear objcRemoteMessagingQualifier
" don't need match for specific type since we match as pattern
syn clear objcClass
" redefine ObjC Blocks, so can contain cBlock in region but not start
syn clear objcBlocks
syn match objcBlocks '\^\%(\s*([^)]\+)\)\?\_s*{'me=e-1 display contains=cMethodParam nextgroup=objcBlocksRegion
syn region objcBlocksRegion matchgroup=objcBlocksRegion start='{' end='}' contained contains=TOP fold
" recognizd void(^)() declare block, but void is keyword, this may not work
"syn match objcBlockTypeDeclare '\v%(\w+ )*\w+\s*\**\s*\(\s*[^*]\s*\w*\s*\)\s*\([^)]*\)' transparent contains=objcBlockDeclareReturnType,cMethodParam,objcBlockDeclareName
"syn match objcBlockDeclareReturnType "\v%(\w+ )*\w+\ze\s*\**\s*\(" contained display contains=cStorageClass,cType,objcObjectLifetimeQualifier
" IBOutlet keywords
"syn match objcBlockDeclareName "(\s*[^*]\s*\zs\w*\ze\s*)" contained display
syn keyword IBOutlet IBOutlet nextgroup=objcPropertyType skipwhite
syn keyword IBOutlet IBOutletCollection skipwhite nextgroup=IBCollectionType
syn match IBCollectionType '(\s*\w\+\s*)'hs=s+1,he=e-1 display contained nextgroup=objcPropertyType skipwhite

" interface declare
syn match objcInterfaceDeclare display '\%(@interface\|@protocol\)\s\+\w\+'hs=s+11 contains=objcObjDef,objcProtocol nextgroup=objcSuperView,objcCategory,impProtocol skipwhite
syn match objcSuperView display ':\s*\w\+'hs=s+1 contained skipwhite nextgroup=impProtocol
syn match objcCategory display '(\s*\w*\s*)'hs=s+1,he=e-1 contained skipwhite nextgroup=impProtocol
syn match impProtocol display transparent '<\_[^>]\+>' contains=impProtocolName contained
syn match impProtocolName display '\<\w\+' contained

" for in declare
syn keyword cRepeat for nextgroup=forinDeclareType skipwhite
syn match forinStatement '\v\(\s*\u\w+\s*\*\s*\w+\s+in\s+.+\)' transparent display contained contains=objcMethodCall,@objcObjCEntities,@objcCEntities
syn match forinType '\u\w\+\s*\*'he=e-1 contained containedin=forinStatement


" Matches "_instanceProperty" 
syn match instanceProperty '\<_\l\w*' display
" Matches "xx.Property"
syn match dotProperty '\%([a-zA-Z0-9_\]]\.\)\@2<=\l\w*' display


" Matches "- (void) foo: (int) bar and: (float) foobar"
syn match objcMethod '^\s*[-+]\s*\_.\{-}[\{;]'me=e-1 display transparent contains=cParen,objcInstanceMethod,objcClassMethod
" Matches "void" & "int" & "float" in above. contained in parens
syn match objcMethodType '([^*)]\+\ze\**\s*)'hs=s+1 display contained containedin=objcMethod contains=cStorageClass,cType,objcObjectLifetimeQualifier,impProtocol,objcBlockTypeDeclare
" Matches "bar & foobar" in above
syn match objcMethodArg ')\@1<=\s*\zs\w\+' display contained containedin=objcMethod
" Matches "foo:" & "and:" in above
syn match objcMethodReturnPart '^\s*[-+]\s*(\_[^)]*)' display transparent contained containedin=objcMethod nextgroup=objcMethodName,objcMethodColon contains=objcInstanceMethod,objcClassMethod,objcMethodType skipwhite
syn match objcMethodName '\w\+' display contained 
syn match objcMethodColon '\<\w\+:' display contained containedin=objcMethod

" Matches Property Type
syn region objcDeclProp display transparent keepend start=/@property\s*(/ end=/)/ contains=objcProperty,objcDeclPropAccessorName,objcDeclPropAccessorType,objcDeclPropAssignSemantics,objcDeclPropAtomicity,objcDeclPropARC nextgroup=IBOutlet,objcPropertyType skipwhite
syn match objcPropertyType '\<\u\w*' display contained


" Declared var "__block UIView* __weak view;" or "UIView* view ="
syn match objcDeclareStatement '\v^\s*%(%(__)?\w+\s+)*\h\w*\s*\*?\s*%(__\w+\s+)*<\w+\_s*[=;]\=@!'me=e-1 display transparent containedin=objcBlocks contains=objcDeclareType,objcObjectLifetimeQualifier,objcBlocksQualifier,@objcObjCEntities,@objcCEntities
" Matches Type in the above Declared
syn match objcDeclareType '\<\u\w*' display contained 

" Matches Class sender in Message call
syn match objcMessageClassSender '\[\@1<=\s*\u\w*' display contained containedin=objcMethodCall
" Matches "bar" in "[NSObject bar]" or "bar" in "[[NSObject foo: baz] bar]",
" but NOT "bar" in "[NSObject foo: bar]". but match foo
"syn match objcMessageName '\%(\[\s*\w\+\s\+\|\]\s*\)\@<=\w\+\s*\]'me=e-1 display contained containedin=objcMethodCall 
syn match objcMessageName '[a-zA-Z0-9_\]]\@1<=\s*\zs\<\w\+\s*\]'me=e-1 display contained containedin=objcMethodCall
" Matches "foo:" in "[NSObject foo: bar]" or "[[NSObject new] foo: bar]"
syn match objcMessageColon '\<\w\+:'he=e-1 display contained containedin=objcMethodCall
syn clear objcColon " conflict with objcColon

" Distinguish index and method call
syn region cIndex matchgroup=cIndex start='[a-zA-Z0-9_\]]\@1<=\s*\zs\[' end='\]' display contains=@objcObjCEntities,@objcCEntities,objcMethodCall
" fix return can follow objcMethodCall, not cIndex
syn keyword cStatement return nextgroup=objcMethodCall skipwhite

" treat keyword begin with k And follow is Upper char word as Constant
syn match ConventionConst '\<k\u\w*' display 
" Notification key, begin with Upper and end with Notification
syn match ConventionConst '\<\u\w\+Notification\>' display
" fix conflict with NotificationKey
syn keyword objcClass NSNotification 
" key constant,such as NSKeyValueChangeNewKey
syn match ConventionConst '\<\u\w*Key\>' display


syn cluster objcObjCEntities add=NotificationKey,instanceProperty,cMacro,ConstantError
syn cluster objcCEntities add=cIndex,dotProperty,ConventionConst,cCustomFunc
" this group element will prevent contained in all matchs
syn cluster includeOnlyGroup contains=objcMessageColon,objcMessageName,objcMethodReturnPart,objcMethodName,objcMethodArg,objcMethodColon,objcMethodType,objcDeclareType,objcPropertyType,IBCollectionType,forinType,objcBlocksRegion,objcSuperView,objcCategory,impProtocol,impProtocolName,objcBlockDeclareName,objcBlockDeclareReturnType
" Don't match these in this strange group for edge cases...
syn cluster cMultiGroup add=@includeOnlyGroup
" Don't match in predefine macro
syn cluster cPreProcGroup add=@includeOnlyGroup,ConventionConst
" Don't match these groups in cParen "(...)"
syn cluster cParenGroup add=@includeOnlyGroup
" This fixes a bug with completion inside parens (e.g. if ([NSString ]))
syn cluster cParenGroup remove=objcMethodCall
" This fixes a bug Preprocessor contains method call
syn cluster cPreProcGroup remove=objcMethodCall

" You may want to customize this one. I couldn't find a default group to suit
" it, but you can modify your colorscheme to make this a different color.
hi def link objcSuperView objcType
hi def link objcCategory objcSpecial
hi def link impProtocolName Identifier

hi def link objcMethodType cType
hi def link objcMethodName Special
hi def link objcMethodColon objcMethodName

hi instanceProperty gui=italic guifg=cyan term=italic
hi dotProperty gui=none guifg=cyan term=italic

hi def link objcPropertyType cType
hi def link objcDeclareType cType
hi def link objcMessageClassSender cType
hi def link IBCollectionType objcType
hi def link forinType cType

hi def link objcMessageName Function
hi def link objcMessageColon objcMessageName
hi def link ConventionConst cConstant

hi def link IBOutlet cConstant
" cStorageClass default highlight is classType, set Special to distinguish with class
hi link cStorageClass Special

