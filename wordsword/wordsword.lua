local M = {}

local utf8 = require "wordsword.utf8"

local tree
local abc
local abc_stat
local adc_size

local function split_word_hash(word)
	local letters = {}
	for letter in utf8.gmatch(word, ".") do
		letters[#letters + 1] = hash(letter)
	end
	return letters
end

function M.is_word(word)
	local letters = split_word_hash(word)
	local letter
	local prev_node = tree
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

function M.add_word(word)
	local h_letter
	local prev_node = tree
	for letter in utf8.gmatch(word, ".") do
		h_letter = hash(letter)
		if abc_stat[h_letter] then
			abc_stat[h_letter] = abc_stat[h_letter] + 1
		else
			abc_stat[h_letter] = 1
			adc_size = adc_size + 1
		end
		abc[h_letter] = letter
		if not prev_node[h_letter] then
			prev_node[h_letter] = {}
		end
		prev_node = prev_node[h_letter]
	end
	prev_node.end_word = true
end

function M.reset()
	tree = {}
	abc = {}
	abc_stat = {}
	adc_size = 0
end

function M.print()
	print("abc")
	pprint(abc)
	print("abc_stat")
	pprint(abc_stat)
	print("adc_size", adc_size)
end

M.reset()
return M