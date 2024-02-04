local type_name = "DOM"
local input_debug_msg = "hello"
local input_debug_var
local debug_type = "UVM_LOW"
local input_type = "4d"
local str = "412.231has"
local data_type
local data_length
local placeholder


-- START OF FUNCTIONS
function parse_type_length(input_str)
    local type_length = ""
    for i = 1, #input_str do
        local c = input_str:sub(i,i)
        local int = tonumber(c)
        if (int ~= nil or c == ".") then
            if (type_length == nil) then
                type_lenght = c
            else
                type_length = type_length..c
            end
        end
    end
    return type_length
end

function parse_type_type(input_str)
    local type_type = ""
    for i = 1, #input_str do
        local c = input_str:sub(i,i)
        local int = tonumber(c)
        if (int == nil and c ~= ".") then
            if (type_type == nil) then
                type_type = c
            else
                type_type = type_type..c
            end
        end
    end
    return type_type
end
-- END OF FUNCTIONS


function nofax_print()
    local output_string
    if (input_debug_var == nil) then
        -- VERSION 0 NO VARIABLE, JUST MESSAGE
        output_string = "`uvm_info(\""..type_name.."\", $sformat(\""..input_debug_msg.."\"), "..debug_type..")"
        print(output_string)
        vim.fn.setreg('x', output_string)
    else 
        -- VERSION 2 VARIABLE AND JUST MESSAGE
        output_string = "`uvm_info(\""..type_name.."\", $sformat(\""..input_debug_msg.." : "..placeholder.."\", "..input_debug_var.."), "..debug_type..")"
        print(output_string)
    end

    return output_string
end


-- START OF KEYMAPS?
vim.keymap.set('n', '<Leader>d', '<cmd>lua nofax_main()<cr>')
-- END OF KEYMAPS


function nofax_main()
    print("ENTER THE DEBUG MESSAGE")
    input_debug_msg = vim.fn.input("> ")
    print("\n")

    -- enter the data_type and data_length
    print("ENTER THE DATA LENGHT/TYPE")
    input_type = vim.fn.input("> ")
    if (input_type == "") then
        input_type = "4h"
    end
    data_type   = parse_type_type(input_type)
    data_length = parse_type_length(input_type)
    placeholder = "%"..data_length..data_type
    print("\n")
    
    -- enter the variable
    print("ENTER THE VARIABLE NAME")
    input_debug_var = vim.fn.input("> ")
    print("\n")

    local out = nofax_print()
    local current_line = vim.fn.line('.')
    vim.fn.append(current_line -1, out)
    vim.fn.feedkeys([[\<CR>]], 'n')
end

