-- SET KEYMAPS
-- this will unmap any existing <leader>p combos
vim.keymap.set('n', '<Leader>p', '<Nop>')

-- maps <leader>pm to show changelists
vim.keymap.set('n', '<Leader>pm', '<cmd>lua p4_show_menu()<cr>')

-- maps the <leader>pc to check out the current file, under the default changelist
vim.keymap.set('n', '<Leader>pc', '<cmd>lua p4_checkout_file()<cr>')

local popup = require("plenary.popup")
local Win_id

local curr_changelist = {}

local changelist_count
local changelist = {}
local change_num = {}
local change_date = {}
local change_desc = {}

local default_changelist = {}
local pending_changelist = {}


function sizeof(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end



function p4_draw_menu(opts, cb)
	local height = 20
	local width =  70
	local borderchars = {"-", "|", "-", "|", "╭", "╮", "╯", "╰"}

	Win_id = popup.create(opts, {
		title = "P4NEOVIM", 
		highlight = "MyProjectWindow", 
		line = math.floor(((vim.o.lines - height) / 2) - 1), 
		col = math.floor((vim.o.columns - width) / 2), 
		minwidth = width, 
		minheight = height, 
		borderchars = borderchars, 
		callback = cb,
	})
	local bufnr = vim.api.nvim_win_get_buf(Win_id)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua p4_close_menu()<CR>", { silent =false })
end


function p4_close_menu()
	vim.api.nvim_win_close(Win_id, true)
end

function combine_list()
    -- get length
    local table_size = sizeof(change_num)

    -- clear table first
    for x = 1, table_size, 1 do
        table.remove(pending_changelist, x)
    end

    -- concatenate into a single line and insert into table
    for x = 1, table_size, 1 do
        local line = change_date[x].."   "..change_num[x].."    "..change_desc[x]
        table.insert(pending_changelist, line)
    end
end


function p4_show_menu()

    p4_load_changelist()
    combine_list()

	local opts = {
        "                                                             ",
    }

    -- -- append pending_changelist to opts
    -- for _, v in ipairs(pending_changelist) do
    --     table.insert(opts, v)
    -- end

    -- -- append various text prompts to opts
    -- table.insert(opts, "")
    -- table.insert(opts, "")
    -- table.insert(opts, "")
    table.insert(opts, "FILES CHECKED-OUT UNDER THE DEFAULT CHANGELIST")

    -- append default_changelist to opts
    for _, v in ipairs(default_changelist) do
        table.insert(opts, v)
    end


	local cb = function(_, sel)
		print("Displaying current changelists")
	end
	p4_draw_menu(opts, cb)
	print("Displaying current changelists")
end


function p4_checkout_file()
	local curr_file = vim.api.nvim_buf_get_name(0)
	-- print(curr_file)
	-- init_command = "p4 edit"
	init_command = "p4 edit"
	command = init_command.." "..curr_file
	-- local output = vim.fn.system {'echo', 'hi'}
	-- vim.fn.system {'echo', 'hi'}
	-- local job = vim.fn.jobstart('echo hello')
	command = ":!"..command
	vim.cmd(string.format(command, f))
end





function p4_load_changelist()
    local command = ":! p4 changes -l -u ntan2 -s pending"
    --          -- DISABLE THE CURR CHANGELIST THINGY FOR NOW
    --          -- local command = ":! ls"
    --          -- vim.cmd(string.format(command, f))
    --          curr_changelist = vim.api.nvim_exec(command, true)

  
    --          -- Parse the output of the command
    --          changelist = mysplit(curr_changelist, "\n")
    --          table.remove(changelist, 1)

    --          -- Determine the total number of pending changelist
    --          changelist_count = sizeof(changelist)


    --          -- Parse the descriptions first
    --          for x = 2, changelist_count, 2 do
    --              table.insert(change_desc, changelist[x])
    --          end
   
    --          -- Parse each line in the main list
    --          for x = 1, changelist_count, 2 do
    --              local line = mysplit(changelist[x])
    --              table.insert(change_num, line[2])
    --              table.insert(change_date, line[4])
    --          end

    -- Parse default changelist
    command = ":! p4 opened -c default"
    curr_changelist = vim.api.nvim_exec(command, true)
    
    -- Parse the output of the command
    changelist = mysplit(curr_changelist, "\n")
    table.remove(changelist, 1)

    -- assign to global var
    default_changelist = changelist
end



