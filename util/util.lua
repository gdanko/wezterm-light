local folderOfThisFile = (...):match("(.-)[^%.]+$")
local util = {}

function has_value(array, value)
    for _, element in ipairs(array) do
        if element == value then
            return true
        end
    end
    return false
end

util.has_value = has_valu

local filesystem = require(folderOfThisFile .. "filesystem")
util.basename = filesystem.basename
util.dirname = filesystem.dirname
util.path_join = filesystem.path_join
util.get_cwd = filesystem.get_cwd
util.file_exists = filesystem.file_exists
util.exists = filesystem.exists
util.is_dir = filesystem.is_dir

local json = require(folderOfThisFile .. "json")
util.json_parse_file = json.json_parse_file
util.json_parse_string = json.json_parse_string

local strings = require(folderOfThisFile .. "strings")
util.get_plural = strings.get_plural
util.pad_string = strings.pad_string
util.split_lines = strings.split_lines
util.split_words = strings.split_words
util.string_split = strings.string_split

local environment = require(folderOfThisFile .. "environment")
util.get_appearance = environment.get_appearance

return util
