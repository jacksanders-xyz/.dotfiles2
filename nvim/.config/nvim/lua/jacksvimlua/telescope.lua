local actions = require("telescope.actions")
local IPA = require("jacksvimlua.ImagePathAutomator")

require("telescope").setup({
    defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        prompt_prefix = " > ",
        color_devicons = true,

        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

        mappings = {
            i = {
                -- ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        },
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    },
})

require("telescope").load_extension("fzy_native")
require("telescope").load_extension("git_worktree")

local M = {}
M.search_dotfiles = function()
    require("telescope.builtin").find_files({
        prompt_title = "< .dotfiles >",
        file_ignore_patterns = {
            "%.git",
            "%.DS_Store",
        },
        hidden = true,
        cwd = '~/.dotfiles',
    })
end

M.grep_dotfiles = function()
    require("telescope.builtin").live_grep({
        prompt_title = "< Grep .dotfiles >",
        file_ignore_patterns = {
            "%.git",
            "%.DS_Store",
        },
        cwd = '~/.config/nvim',
        hidden = true,
    })
end

M.search_notes = function()
    require("telescope.builtin").find_files({
        prompt_title = "< Jack's Brain >",
        file_ignore_patterns = {
            "^IMAGE_POOL/",
            "%.git",
            "%.DS_Store",
        },
        cwd = '~/VimWiki/',
        hidden = true,
    })
end

M.grep_notes = function()
    require("telescope.builtin").live_grep({
        prompt_title = "< Grep Jack's Brain >",
        file_ignore_patterns = {
            "^IMAGE_POOL/",
            "%.git",
            "%.DS_Store",
        },
        cwd = '~/VimWiki/',
        hidden = true,
    })
end

local function GrabImagePath(prompt_bufnr, map)
   	local function set_the_image_path(close, DESTINATION)
		local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)[1]
        vim.g.telec = content
        -- local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
		-- set_background(content.cwd .. "/" .. content.value)
		if close then
			require("telescope.actions").close(prompt_bufnr)
            IPA.Telescope_Path_Constructor(content, DESTINATION)
		end
	end

	map("i", "<CR>", function()
		set_the_image_path(true, 'LOCAL')
	end)

    map("i", "<c-j>", function()
		set_the_image_path(true, 'JACKS_BRAIN')
	end)

    map("i", "<c-w>", function()
		set_the_image_path(true, 'WORK')
	end)
end

M.ImagePathFinder = function()
    require("telescope.builtin").find_files({
        layout_strategy = "vertical",
        prompt_title = "< Image Finder >",
        file_ignore_patterns = {
            "%.git",
            "%.DS_Store",
        },
        cwd = '~/VimWiki/IMAGE_POOL/',
        hidden = true,
        attach_mappings = function(prompt_bufnr, map)
                GrabImagePath(prompt_bufnr, map)
                return true
        end,
    })
end

-- local function set_background(content)
--     vim.fn.system(
--         "dconf write /org/mate/desktop/background/picture-filename \"'"
--             .. content
--             .. "'\""
--     )
-- end

-- local function select_background(prompt_bufnr, map)
--     local function set_the_background(close)
--         local content = require("telescope.actions.state").get_selected_entry(
--             prompt_bufnr
--         )
--         set_background(content.cwd .. "/" .. content.value)
--         if close then
--             require("telescope.actions").close(prompt_bufnr)
--         end
--     end

--     map("i", "<C-p>", function()
--         set_the_background()
--     end)

--     map("i", "<CR>", function()
--         set_the_background(true)
--     end)

-- end
-- local function image_selector(prompt, cwd)
--     return function()
--         require("telescope.builtin").find_files({
--             prompt_title = prompt,
--             cwd = cwd,

--             attach_mappings = function(prompt_bufnr, map)
--                 select_background(prompt_bufnr, map)
--                 -- Please continue mapping (attaching additional key maps):
--                 -- Ctrl+n/p to move up and down the list.
--                 return true
--             end,
--         })
--     end
-- end

-- M.anime_selector = image_selector("< Anime Bobs > ", "~/dotfiles/backgrounds")
-- M.chat_selector = image_selector("< Chat Sucks > ", "~/dotfiles/chat")

-- local function refactor(prompt_bufnr)
--     local content = require("telescope.actions.state").get_selected_entry(
--         prompt_bufnr
--     )
--     require("telescope.actions").close(prompt_bufnr)
--     require("refactoring").refactor(content.value)
-- end

-- M.refactors = function()
--     require("telescope.pickers").new({}, {
--         prompt_title = "refactors",
--         finder = require("telescope.finders").new_table({
--             results = require("refactoring").get_refactors(),
--         }),
--         sorter = require("telescope.config").values.generic_sorter({}),
--         attach_mappings = function(_, map)
--             map("i", "<CR>", refactor)
--             map("n", "<CR>", refactor)
--             return true
--         end
--     }):find()
-- end
M.git_branches = function()
    require("telescope.builtin").git_branches({
        attach_mappings = function(_, map)
            map("i", "<c-d>", actions.git_delete_branch)
            map("n", "<c-d>", actions.git_delete_branch)
            return true
        end,
    })
end

return M
