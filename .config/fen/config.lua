fen.show_help_text = false
fen.show_hostname = false
fen.sort_by = "modified"
fen.always_show_info_numbers = true
fen.scroll_speed = 3
fen.split_home_end = true

local function concat(a, b)
	for _, v in ipairs(b) do
		table.insert(a, v)
	end
	return a
end

local secret = {"*.key", "*.rk", "sitemanager.xml"}
local video = {"*.mp4", "*.webm", "*.mkv", "*.mov", "*.avi", "*.flv"}
local audio = {"*.wav", "*.flac", "*.mp3", "*.ogg", "*.m4a"}
local image = {"*.png", "*.jpg", "*.jpeg", "*.jfif", "*.flif", "*.tiff", "*.gif", "*.webp", "*.bmp"}
local archive = {"*.zip","*.jar","*.kra","*.tar.bz2","*.tb2","*.tbz","*.tbz2","*.tz2","*.tar.gz","*.taz","*.tgz","*.tar.lz","*.tar.lzma","*.tlz","*.tar.lzo","*.tar.xz","*.tZ","*.taZ","*.tar.zst","*.tzst","*.rar"}
local document = {"*.pdf","*.epub","*.docx","*.doc","*.odg","*.fodg","*.otg"}

local c = fen.config_path

fen.open = {
	{program = {"mpv --volume=80", "vlc"}, match = concat(video, audio)},
	{program = {"xviewer", "xdg-open", "feh"}, match = image},
--	{program = {"feh", "xviewer", "xdg-open"}, match = image},
	{program = "xdg-open", match = document},
	{program = {"nvim -p", "vim -p", "vi"}, match = {"*"}}
}

local everythingToPreviewWithFile = {"*.*~", "*.otg", "*.o", "*.otf", "*.ttf", "*.appimage", "*.vhd", "*.deb", "*.iso", "*.out", "*.exe", "*.class", "*.sqlite*", "fen"}
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, video)
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, audio)
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, image)
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, archive)
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, document)

--[[fen.preview = {
	{script  = c.."show-nothing.lua",         match = secret},
	{script  = c.."show-nothing.lua",         match = "pagemap"},
	{script  = c.."markdown.lua",             match = "*.md"},
	{script  = c.."toml.lua",                 match = {"*.toml", "*.lock"}},
	{script  = c.."desktop.lua",              match = "*.desktop"},
	{program =    "bash "..c.."video.bash",   match = video},
	{program =    "cat",                  match = everythingToPreviewWithFile},
--	{program =    "file -b",                  match = everythingToPreviewWithFile},
	{script  = c.."comments-and-strings.lua", match = "*"}
}
--]]

fen.preview = {
	{script  = c.."markdown.lua", match = "*.md"},
	{script  = c.."toml.lua",                 match = {"*.toml", "*.lock"}},
	{script  = c.."desktop.lua",              match = "*.desktop"},
	{script  = c.."comments-and-strings.lua", match = "LICENSE"}
}

local pathSep = "/"
if fen.runtime_os == "windows" then
	pathSep = "\\"
end
fen.bookmarks = {
	[1] = fen.home_path .. "Downloads",
	[2] = fen.home_path .. "Downloads" .. pathSep .. "samples" .. pathSep .. "best_everything",
	[3] = fen.home_path .. "Documents" .. pathSep .. "REAPER Media",
	[4] = fen.home_path .. ".steam/debian-installation/steamapps/common/Team Fortress 2/tf/cfg",
	[10] = fen.config_path .. "config.lua",
}
