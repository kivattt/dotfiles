syntax case match

" Generic log stuff
syntax keyword LevelWARNING [WARNING]
syntax region String start=/\v"/ skip=/\v\\./ end=/\v"/
syntax match Date /\v\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/

" Minecraft/ReIndev specific
syntax region StartingServer start=/\vStarting Minecraft server version:/ end=/$/ oneline
syntax region StartingServer start=/\vServer started in/ end=/$/ oneline
syntax region StoppingServer start=/\vStopping server/ end=/$/ oneline
syntax region PlayerJoin start=/\vlogged in with entity id/ end=/\v at / oneline
syntax region PlayerDisconnect start=/\vlost connection: / end=/$/ oneline
syntax region PlayerDisconnect start=/\Disconnecting / end=/$/ oneline
syntax match IPAddress /\v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/
syntax match MoreThanSign "> "
"syntax region ChatMessage start="> " end=/$/ oneline
syntax region KSUChatMessage start="r> " end=/$/ oneline
syntax match Coordinate /\vx:[-]?[0-9]+, y:[-]?[0-9]+, z:[-]?[0-9]+/
syntax match Coordinate /\v[-]?[0-9]+\.[0-9]+, [-]?[0-9]+\.[0-9]+, [-]?[0-9]+\.[0-9]+/
syntax keyword GriefingIndicators FLINT_AND_STEEL TNT DYNAMITE GOLDEN_LAVA_BUCKET LAVA_BUCKET
syntax match ValuableItems /\vdiamond/
syntax match ValuableItems /\vgold/
syntax match ValuableItems /\vobsidian_/
syntax match KSUContainerInteraction /\v in Double chest, item /
syntax match KSUContainerInteraction /\v in Crate, item /
syntax match KSUContainerInteraction /\v in Chest, item /
syntax match KSUContainerInteraction /\v in Unknown, item /
syntax match KSUContainerInteraction /\v replaced with /

" Colors
hi LevelWARNING ctermfg=DarkYellow guifg=DarkYellow
hi String ctermfg=DarkYellow guifg=DarkYellow
hi Date ctermfg=Gray guifg=Gray

hi StartingServer ctermfg=LightGreen cterm=bold guifg=LightGreen gui=bold
hi StoppingServer ctermfg=Red cterm=bold guifg=Red gui=bold
hi PlayerJoin ctermfg=Green guifg=Green
hi PlayerDisconnect ctermfg=DarkRed guifg=DarkRed
hi IPAddress ctermfg=Cyan guifg=Cyan
hi MoreThanSign ctermfg=DarkYellow guifg=DarkYellow
"hi ChatMessage cterm=standout gui=standout
hi KSUChatMessage cterm=standout gui=standout
hi Coordinate ctermfg=DarkYellow guifg=DarkYellow
hi GriefingIndicators ctermfg=Red guifg=Red
hi ValuableItems ctermfg=Red guifg=Red
hi KSUContainerInteraction ctermfg=Gray guifg=Gray
