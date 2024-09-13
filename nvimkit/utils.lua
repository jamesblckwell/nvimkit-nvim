local Utils = {}

-- checks if a directory exists
Utils.check_dir_exists = function(path)
    return vim.fn.isdirectory(path) ~= 0
end

-- checks if a file exists
Utils.file_exists = function(path)
    return vim.fn.filereadable(path) ~= 0
end

-- merges two tables together, see: https://stackoverflow.com/a/1283399
Utils.merge_tables = function(t1, t2)
    for k, v in pairs(t2) do t1[k] = v end
    return t1
end

-- reads the contents of a file
Utils.get_file_contents = function(path)
    local file = assert(io.open(path, "r"), "Error: Could not open file for reading: " .. path)
    local contents = file:read("*a")
    file:close()
    return contents
end

return Utils
