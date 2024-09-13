local M = {}

M._jsFiletypes = {
    "+page.svelte",
    "+page.js",
    "+page.server.js",
    "+server.js",
    "+layout.svelte",
    "+layout.js",
    "+layout.server.js",
    "+error.svelte",
}

M._tsFiletypes = {
    "+page.svelte",
    "+page.ts",
    "+page.server.ts",
    "+server.ts",
    "+layout.svelte",
    "+layout.ts",
    "+layout.server.ts",
    "+error.svelte",
}

M._default_config = {
    svelte_route_dirname = "/src/routes",
    is_TS_project = false,
}

Utils = require("nvimkit.utils")

M._detectTS = function()
    local cwd = vim.fn.getcwd();
    local tsconfig = cwd .. "/tsconfig.json";
    return Utils.file_exists(tsconfig);
end

M.get_options = function()
end

M.get_template_path = function()
end

M.setup = function(opts)
    if opts == nil then
        opts = M._default_config
    end
    print("Setting up svelte")
end

return M
