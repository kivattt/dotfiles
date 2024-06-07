syntax case match

syntax keyword Keywords use if else match mut pub for next break test yield return is and or defer
syntax keyword Datatypes u8 u16 u32 u64 i8 i16 i32 i64 rat fn rec uni enum str raw unit

syntax match BuiltinFuncs /\vfmt::[^(]*/
syntax match BuiltinFuncs /\vMEM::[^(]*/

syntax region Comment start=/\v\/\// end="$" keepend oneline
syntax region Char start=/\v'/ skip=/\v\\./ end=/\v'/
syntax region String start=/\v"/ skip=/\v\\./ end=/\v"/

hi Keywords ctermfg=Cyan guifg=Cyan
hi Literals ctermfg=Red guifg=Red
hi Datatypes ctermfg=LightGreen guifg=LightGreen
hi BuiltinFuncs ctermfg=LightRed guifg=LightRed

hi Char ctermfg=Yellow guifg=Yellow
hi String ctermfg=Yellow guifg=Yellow
