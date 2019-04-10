local M = {
	tree = {}
}

local utf8 = require "wordsword.utf8"

local function recalculate_freq_table(self)
	self.freq_table = {}
	local sum = 0
	local el
	for k, v in pairs(self.abc_stat) do
		sum = sum + v
		el = {l = k, sum = sum}
		self.freq_table[#self.freq_table + 1] = el
	end
	self.freq_sum = sum
end

function M.split_word_hash(word)
	local letters = {}
	for letter in utf8.gmatch(word, ".") do
		letters[#letters + 1] = hash(letter)
	end
	return letters
end

function M.new()
	local instance = setmetatable({}, {__index = M.tree})
	instance:reset()
	return instance
end

function M.tree.is_word(self, word)
	local letters = M.split_word_hash(word)
	local letter
	local prev_node = self.tree
	for i = 1, #letters do
		letter = letters[i]
		prev_node = prev_node[letter]
		if not prev_node then
			return false
		end
	end
	if prev_node.end_word then
		return true
	else
		return false
	end
end

function M.tree.add_word(self, word)
	local h_letter
	self.words_count = self.words_count + 1
	local prev_node = self.tree
	for letter in utf8.gmatch(word, ".") do
		h_letter = hash(letter)
		if self.abc_stat[h_letter] then
			self.abc_stat[h_letter] = self.abc_stat[h_letter] + 1
		else
			self.abc_stat[h_letter] = 1
			self.adc_size = self.adc_size + 1
		end
		self.abc[h_letter] = letter
		if not prev_node[h_letter] then
			prev_node[h_letter] = {}
		end
		prev_node = prev_node[h_letter]
	end
	prev_node.end_word = true
	self.freq_table = nil
end

function M.tree.reset(self)
	self.tree = {}
	self.abc = {}
	self.abc_stat = {}
	self.adc_size = 0
	self.words_count = 0
	self.freq_table = nil
	self.freq_sum = 0
end

function M.tree.get_letter(self)
	if not self.freq_table then
		recalculate_freq_table(self)
	end
	local num = math.random(1, self.freq_sum)
	local el
	for i = 1, self.adc_size do
		el = self.freq_table[i]
		if num <= el.sum then
			return self.abc[el.l], el.l
		end
	end
end

function M.tree.load_dictionary_non_blocking(self, dict, separator, callback)
	local co
	co = coroutine.create(function()
		local frame_time = socket.gettime()
		for word in string.gmatch(dict, "(.-)"..separator.."") do
			word = string.gsub(word, "^%s*(.-)%s*$", "%1")
			self:add_word(word)
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
			timer.delay(0, false, function() 
				callback(self) 
			end)
		end
	end)
	coroutine.resume(co)
end

function M.tree.load_dictionary(self, dict, separator)
	local string = string
	for word in string.gmatch(dict, "(.-)"..separator.."") do
		word = string.gsub(word, "^%s*(.-)%s*$", "%1")
		self:add_word(word)
	end
end

function M.tree.print_info(self)
	print("abc:")
	pprint(self.abc)
	print("abc_stat:")
	pprint(self.abc_stat)
	print("adc_size", self.adc_size)
	print("words_count", self.words_count)
end

return M