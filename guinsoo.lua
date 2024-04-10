local bin_lookup = {
    ["0"] = "0000",
    ["1"] = "0001",
    ["2"] = "0010",
    ["3"] = "0011",
    ["4"] = "0100",
    ["5"] = "0101",
    ["6"] = "0110",
    ["7"] = "0111",
    ["8"] = "1000",
    ["9"] = "1001",
    ["A"] = "1010",
    ["B"] = "1011",
    ["C"] = "1100",
    ["D"] = "1101",
    ["E"] = "1110",
    ["F"] = "1111"
}


local print_binary = function(value)
    local hs = string.format("%.2X", value) -- convert number to HEX
    local ln, str = hs:len(), "" -- get length of string
    for i = 1, ln do -- loop through each hex character
        local index = hs:sub(i, i) -- each character in order
        str = str .. bin_lookup[index] -- lookup a table
        str = str .. " " -- add a space
    end
    return str
end


local clean_binary = function(value)
    local ln, str = value:len(), "" -- get length of string
    for i = 1, ln do
       if (value:sub(i, i) == "0" or  value:sub(i, i) == "1") then
           str = str .. value:sub(i, i)
       end
    end
    return str
end


local function parse_input(input_str)

    if (input_str == nil) then
        error("input is null")
    end

    local data_type = string.sub(input_str, 1, 1) 
    local data_length = string.len(input_str)
    local data = string.sub(input_str, 2, data_length)


    -- if input is decimal...
    if (data_type == "d") then
        out_dec = data
        out_hex = string.format("%x", data)
        out_bin = print_binary(data)
    end
    
    -- if input is hexadecimal...
    if (data_type == "h") then
        out_hex = data
        out_dec = tonumber(data, 16)
    end

    -- if input is hexadecimal...
    if (data_type == "b") then
        out_bin = data
        data = clean_binary(data)
        out_dec = tonumber(data, 2)
        out_hex = string.format("%x", out_dec)
    end

    print("\n")
    print("Dec = "..out_dec)
    print("Hex = "..out_hex)
    print("Bin = "..out_bin)
end


function guinsoo_main()
    print("ENTER VALUE")
    -- enter something like d32, ha5 or b0000_1101...
    parse_input(vim.fn.input("> "))
end


-- START OF KEYMAPS?
vim.keymap.set('n', '<Leader>c', '<cmd>lua guinsoo_main()<cr>')
-- END OF KEYMAPS
