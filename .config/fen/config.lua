fen.show_help_text = false
fen.show_hostname = false
fen.sort_by = "modified"
fen.always_show_info_numbers = true
fen.scroll_speed = 4
fen.split_home_end = true
fen.git_status = true

local video = {"*.mp4", "*.webm", "*.mkv", "*.mov", "*.avi", "*.flv"}
local audio = {"*.wav", "*.flac", "*.mp3", "*.ogg", "*.m4a"}
local image = {"*.png", "*.jpg", "*.jpeg", "*.jfif", "*.flif", "*.tiff", "*.gif", "*.webp", "*.bmp"}
local document = {"*.pdf", "*.epub", "*.docx", "*.doc", "*.odg", "*.fodg", "*.otg"}

fen.open = {
	{program = {"arw-preview2", "darktable"},  match = {"*.ARW", "*.arw", "*.CR3"}},
	{program = {"mpv"},                        match = video},
	{program = {"mpv --volume=80"},            match = audio},
	{program = {"xviewer", "xdg-open", "feh"}, match = image},
	{program = "xdg-open",                     match = document},
	{program = {"nvim -p", "vim -p", "vi"},    match = "*"}
}

local c = fen.config_path
fen.preview = {
	{script = c.."gitignore.lua",            match = ".gitignore"},
	{script = c.."go.mod.lua",               match = "go.mod"},
	{script = c.."markdown.lua",             match = "*.md"},
	{script = c.."toml.lua",                 match = {"*.toml", "*.lock"}},
	{script = c.."desktop.lua",              match = "*.desktop"},
	{script = c.."comments-and-strings.lua", match = {"LICENSE*", "COPYING*"}}
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
	-- TMNF downloaded maps
	[9] = fen.home_path .. ".steam/debian-installation/steamapps/compatdata/11020/pfx/drive_c/users/steamuser/Documents/TrackMania/Tracks/Challenges/Downloaded",
	[10] = fen.config_path .. "config.lua",
}
