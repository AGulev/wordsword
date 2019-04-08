local M = {}

local utf8 = require "wordsword.utf8"
local wordsword = require "wordsword.wordsword"

function M.load_dictionary(dict, separator)
	local string = string
	for word in string.gmatch(dict, "(.-)"..separator.."") do
		word = string.gsub(word, "^%s*(.-)%s*$", "%1")
		wordsword.add_word(word)
	end
end



function M.load_dictionary_async(dict, separator, callback)
	local co
	co = coroutine.create(function()
		local frame_time = socket.gettime()
		for word in string.gmatch(dict, "(.-)"..separator.."") do
			word = string.gsub(word, "^%s*(.-)%s*$", "%1")
			wordsword.add_word(word)
			if socket.gettime() - frame_time > 0.015 then
				timer.delay(0, false, function() 
					frame_time = socket.gettime()
					coroutine.resume(co) 
				end)
				coroutine.yield()
			end
		end
		collectgarbage()
		timer.delay(0, false, function() coroutine.resume(co) end)
		coroutine.yield()
		if callback then
			callback()
		end
	end)
	coroutine.resume(co)
end

return M