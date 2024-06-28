fen.hidden_files = false
fen.show_help_text = false
fen.sort_by = "modified"

local function concat(a, b)
	for _, v in ipairs(b) do
		table.insert(a, v)
	end
	return a
end

local c = fen.config_path

local secret = {"*.key", "*.rk", "sitemanager.xml"}
local video = {"*.mp4", "*.webm", "*.mkv", "*.mov", "*.avi", "*.flv"}
local audio = {"*.wav", "*.flac", "*.mp3", "*.ogg", "*.m4a"}
local image = {"*.png", "*.jpg", "*.jpeg", "*.jfif", "*.flif", "*.tiff", "*.gif", "*.webp", "*.bmp"}
local archive = {"*.zip","*.jar","*.kra","*.tar.bz2","*.tb2","*.tbz","*.tbz2","*.tz2","*.tar.gz","*.taz","*.tgz","*.tar.lz","*.tar.lzma","*.tlz","*.tar.lzo","*.tar.xz","*.tZ","*.taZ","*.tar.zst","*.tzst"}
local document = {"*.pdf","*.epub","*.docx","*.doc","*.odg","*.fodg","*.otg"}

fen.open = {
	{program = {"mpv", "vlc"}, match = concat(video, audio)},
	{program = {"xviewer", "xdg-open", "feh"}, match = image},
	{program = {"nvim -p", "vim -p", "vi -p"}, match = {"*"}}
}

local everythingToPreviewWithFile = {"*.*~", "*.otg", "*.o", "*.otf", "*.ttf", "*.appimage", "*.vhd", "*.deb", "*.iso", "*.out", "*.exe", "*.class", "*.sqlite*", "fen"}
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, video)
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, audio)
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, image)
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, archive)
everythingToPreviewWithFile = concat(everythingToPreviewWithFile, document)

fen.preview = {
	{script  = c.."show-nothing.lua",         match = secret},
	{script  = c.."markdown.lua",             match = "*.md"},
	{script  = c.."toml.lua",                 match = {"*.toml", "*.lock"}},
	{script  = c.."desktop.lua",              match = "*.desktop"},
	{program =    "bash "..c.."video.bash",   match = video},
	{program =    "file -b",                  match = everythingToPreviewWithFile},
	{script  = c.."comments-and-strings.lua", match = "*"}
}
