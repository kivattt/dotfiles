syntax case match

syntax keyword Keywords fn returns return return_err defer if else elif for while continue break
syntax keyword Literals true false
syntax keyword Datatypes i32 i64 u32 u64 byte double string bool mut struct list
syntax keyword BuiltinFuncs print println

syntax region Comment start=/\v\/\// end="$" keepend oneline
syntax region Char start=/\v'/ skip=/\v\\./ end=/\v'/
syntax region String start=/\v"/ skip=/\v\\./ end=/\v"/

hi Keywords ctermfg=Cyan guifg=Cyan
hi Literals ctermfg=Red guifg=Red
hi Datatypes ctermfg=LightGreen guifg=LightGreen
hi BuiltinFuncs ctermfg=Green guifg=Green

hi Char ctermfg=Yellow guifg=Yellow
hi String ctermfg=Yellow guifg=Yellow
