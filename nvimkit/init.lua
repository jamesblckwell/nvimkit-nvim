local M = {}


M._default_config = {
    svelte_route_dirname = "/src/routes",
    open_file_split_direction = "right",
    open_file_after_creation = true,
    is_TS_project = true,
}

M._config = {}

-- checks if the setup function has been called, by seeing if the
-- _config variable is set
local check_setup = function()
    return M._config ~= nil
end

-- Generate route options for the user to select from
local generate_route_options = function()
    local options = { "Select the desired filetype: (or 0 to just create the route directory)" }
    for i, v in ipairs(M._config["route_filetypes"]) do
        table.insert(options, i .. ". " .. v)
    end
    return options
end


local create_file = function(path, route_file)
    if Utils.check_dir_exists(path) == false then
        vim.fn.mkdir(path, "p")
    end

    local route_filepath = path .. "/" .. route_file

    if Utils.file_exists(route_filepath) == true then
        print("\nError: File already exists: ", route_filepath)
        return
    end

    local template_set = nil
    if M._config["is_TS_project"] == true then
        template_set = M._templates["ts"]
    else
        template_set = M._templates["js"]
    end
    local template = template_set[route_file]
    if template == nil then
        template = ""
    end

    local file = assert(
        io.open(route_filepath, "w"),
        "Error: Could not open file for writing: " .. route_filepath
    )
    file:write(template)
    file:close()

    if M._config["open_file_after_creation"] == true then
        -- Create buffer
        local buffer = vim.api.nvim_create_buf(true, false);
        -- Set buffer name to the route filepath
        vim.api.nvim_buf_set_name(buffer, route_filepath)
        -- Load the file into the buffer
        vim.api.nvim_buf_call(buffer, function()
            vim.cmd.edit(route_filepath)
        end)
        -- Open the buffer in a split window
        vim.api.nvim_open_win(buffer, true, {
            split = M._config["open_file_split_direction"],
            win = 0,
        })
    end
end

M.create_route = function(filename, route)
    local options = generate_route_options()

    if check_setup() == false then
        error("Error: Setup not called", 0)
        return
    end

    local cwd = vim.fn.getcwd()
    local svelte_root = cwd .. M._config["svelte_route_dirname"]

    if Utils.check_dir_exists(svelte_root) == false then
        error("Error: Svelte root directory not found: " .. svelte_root, 0)
        return
    end

    local filename_index = 0

    if filename == nil then
        filename_index = vim.fn.inputlist(options)
        filename = M._config["route_filetypes"][filename_index]
    end

    -- exit gracefully when a user doesn't select a filetype
    if filename == nil then
        return
    end

    if route == nil then
        route = vim.fn.input("Enter the route (empty for routes root, or q to cancel): ", "", "file")
        if route == "q" then
            return
        end
    end

    create_file(svelte_root .. "/" .. route, filename)
end

M.setup = function(opts)
    if opts == nil then
        opts = M._default_config
    end

    M.load_extension("extensions.svelte")

    M._templates = require("nvimkit.templates")
    M._utils = require("nvimkit.utils")

    -- M._default_config["is_TS_project"] = M._detectTS();

    -- M._config = Utils.merge_tables(M._default_config, opts)
    --
    -- if M._config["is_TS_project"] == true then
    --     M._config["route_filetypes"] = M._tsFiletypes
    -- else
    --     M._config["route_filetypes"] = M._jsFiletypes
    -- end
    --
    -- vim.api.nvim_create_user_command(
    --     "NvimkitCreateRoute",
    --     function(args)
    --         M.create_route(args["fargs"][1], args["fargs"][2])
    --     end,
    --     {
    --         nargs = "*",
    --         complete = function(ArgLead, CmdLine, CursorPos)
    --             -- only complete for the first argument
    --             if CursorPos == 19 then
    --                 return M._config["route_filetypes"]
    --             end
    --         end,
    --         desc = "NvimkitCreateRoute <filetype> <route> - Create a new route file in the svelte routes directory"
    --     }
    -- )
end

M.load_extension = function(extension)
    local ext = require("nvimkit." .. extension)
    ext.setup()
end

M.setup()
-- M.create_route("+page.svelte", "route")

return M
