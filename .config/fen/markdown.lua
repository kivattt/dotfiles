--[[
-- Works for fen v1.1.3 or above
-- File preview script for *.md files
--]]

local function trimLeftSpaces(s)
	return s:match'^%s*(.*)'
end

local function trimLeftHashes(s)
	return s:match'^#*(.*)'
end

local function isEmphasis(char)
	return char == '*' or char == '_'
end

local function isList(char)
	return char == '-' or char == '*'
end

local function isThematicBreak(char)
	return char == '-' or char == '_' or char == '*'
end

-- https://spec.commonmark.org/0.31.2/#thematic-breaks
local function lineIsThematicBreak(line)
	local lookingForPrefixSpaces = true

	local prefixSpaceCount = 0
	local thematicBreakCharCount = 0
	for i = 1, #line do
		local c = line:sub(i,i)

		if lookingForPrefixSpaces then
			if c == ' ' then
				prefixSpaceCount = prefixSpaceCount + 1
				-- Four spaces of indentation is too many
				if prefixSpaceCount > 3 then
					return false
				end
			else
				lookingForPrefixSpaces = false
			end

			goto continue
		end

		-- Spaces and tabs are allowed between the characters
		if c == ' ' or c == '\t' then
			goto continue
		end

		if isThematicBreak(line:sub(i,i)) then
			thematicBreakCharCount = thematicBreakCharCount + 1
			-- A sequence of three or more matching -, _, or * characters forms a thematic break.
			if thematicBreakCharCount >= 3 then
				-- Spaces and tabs are allowed at the end
				-- However, no other characters may occur in the line
				for j = i, #line do
					local c2 = line:sub(j,j)
					if not (isThematicBreak(c2) or c2 == ' ' or c2 == '\t') then
						return false
					end
				end
				return true
			end
		else
			return false
		end

	    ::continue::
	end

	return false
end

local punctuation = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
local punctuationTable = {}
for i = 1, #punctuation do
	punctuationTable[punctuation:sub(i,i)] = true
end

-- https://spec.commonmark.org/0.31.2/#backslash-escapes
local function isPunctuation(char)
	return punctuationTable[char] ~= nil
end

-- https://spec.commonmark.org/0.31.2/#code-fence
local function isCodeFence(char)
	return char == '`' or char == '~'
end

local function printThematicBreak(yPosition)
	local lineChar = "━"
	if fen:RuntimeOS() == "freebsd" then
		lineChar = "-"
	end
	for i = 0, fen.Width do
		fen:PrintSimple("[gray]"..lineChar, i, yPosition)
	end
end

local italic, bold, codeblock, backtickString = false, false, false, false
local char, lastChar = '', ''
local style = ""

local y = 0
for line in io.lines(fen.SelectedFile) do
	local lineTrimLeftSpaces = trimLeftSpaces(line)
	local xOffset = 0

	local codeFenceChars = 0
	for j = 1, #lineTrimLeftSpaces do
		local c = lineTrimLeftSpaces:sub(j,j)
		if not isCodeFence(c) then
			break
		end
		codeFenceChars = codeFenceChars + 1
	end
	if codeFenceChars == 3 then
		codeblock = not codeblock
		goto continueLine
	end

	local headingDepth = 0
	if not codeblock then
		for j = 1, #lineTrimLeftSpaces do
			local c = lineTrimLeftSpaces:sub(j,j)
			if c ~= '#' then
				if c ~= ' ' then
					headingDepth = 0
				end
				break
			end
			headingDepth = headingDepth + 1
			if headingDepth > 6 then
				headingDepth = 0
				break
			end
		end

		if headingDepth > 0 then
			-- :skull:
			line = trimLeftSpaces(trimLeftHashes(trimLeftSpaces(line)))
		end
	end

	local lineLength = 0
	for i = 1, #line do
		char = line:sub(i,i)

		-- Remove single trailing backslash if present
		if i == #line then
			if char == '\\' then
				lastChar = char
				goto continue
			end
		end

		local peekChar = line:sub(i+1,i+1)
		if i == #line - 1 then
			peekChar = ""
		end

		if not codeblock then
			if isPunctuation(peekChar) and char == '\\' then
				xOffset = xOffset - 1
				lastChar = char
				goto continue
			end

			if char == '`' and lastChar ~= '`' then
				backtickString = not backtickString
				-- It messes up table alignment if we skip over the backticks, so we just replace them with blank space instead
				fen:PrintSimple("[:black] ", i+xOffset-1, y)
				lastChar = char
				goto continue
			end

			if not backtickString and lastChar ~= '\\' and not isList(lineTrimLeftSpaces:sub(1,1)) then
				if isEmphasis(lastChar) and isEmphasis(char) then
					bold = not bold
					italic = false
					xOffset = xOffset - 1
					lastChar = char
					goto continue
				elseif isEmphasis(char) then
					italic = not italic
					xOffset = xOffset - 1
					lastChar = char
					goto continue
				end
			end
		end

		local styleForeground, styleBackground, styleAttributes = "", "", ""
		if bold then
			styleAttributes = styleAttributes.."b" -- bold
		end
		if italic then
			styleAttributes = styleAttributes.."i" -- italic
		end
		if headingDepth > 0 then
			styleAttributes = styleAttributes.."b" -- bold
			styleForeground = "white"
		end
		if codeblock then
			styleForeground = fen:ColorToString(fen:NewRGBColor(0, 255, 0))
			styleBackground = "black"
		end
		if backtickString then
			styleAttributes = styleAttributes.."d" -- dim
			styleBackground = "black"
		end

		if not (styleForeground == "" and styleAttributes == "" and styleBackground == "") then
			style = "["..styleForeground..":"..styleBackground..":"..styleAttributes.."]"
		else
			style = ""
		end

		if char == '\t' then
			fen:PrintSimple(style.."    ", i+xOffset-1, y)
			xOffset = xOffset + 3
		else
			fen:PrintSimple(style..char, i+xOffset-1, y)
		end

		lineLength = i
		lastChar = char
	    ::continue::
	end

	if codeblock then
		for i = 0, fen.Width - lineLength - xOffset do
			fen:PrintSimple("[:black] ", lineLength+i+xOffset, y)
		end
	end

	if lineIsThematicBreak(line) then
		printThematicBreak(y)
	elseif isList(lineTrimLeftSpaces:sub(1,1)) then
		local listXPos = 0
		for i = 1, #line do
			local c = line:sub(i,i)
			if c == ' ' then
				listXPos = listXPos + 1
			elseif c == '\t' then
				listXPos = listXPos + 4
			end
			if c ~= ' ' and c ~= '\t' then
				break
			end
		end

		-- The non-graphical FreeBSD console would print a '?' instead of the fancy character, so fallback to an asterix
		if fen:RuntimeOS() == "freebsd" then
			fen:PrintSimple("[::d]*", listXPos, y)
		else
			fen:PrintSimple("[::d]●", listXPos, y)
		end
	end

	y = y + 1
	if y >= fen.Height then
		break
	end
	::continueLine::
end
