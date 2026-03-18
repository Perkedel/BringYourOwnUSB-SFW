local toolName = "TNS|ImpExp|TNE"


local function init()
    lcd.clear()
end


function dump_table(o, escSpec, indent)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        local vout = ""
        if type(o) == 'table' then
            vout = dump_table(v, escSpec)
        end
        s = s .. '['..k..'] = ' .. vout .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end


local function get_model()
    return model
end


function serialize_model_index_index(getter, count)
    local input = 0
    local r = {}
    while true do
        local rr = {}
        local tab = true
        local line = 0
        while tab ~= nil do
            tab = getter(input, line)
            if tab ~= nil then
                print("CONT " .. input .. " " .. line)
                table_insert(rr, tab)
                -- print("input="..input.."/".."line="..line.."  "..dump_table(tab))
            end
            line = line + 1
        end
        if (count == -1) and (table_length(rr) == 0) then
            return r
        end
        table_insert(r, rr)
        input = input + 1
        if (input >= count) then
            return r
        end
    end
    return r
end


function serialize_model_index(getter, model, count)
    local rr = {}
    local tab = true
    local line = 0
    while (count > -1) and (tab ~= nil) do
        tab = getter(line, 0)
        if tab ~= nil then
            -- print(dump_table(tab))
            table_insert(rr, tab)
        end
        line = line + 1
        if (line >= count) then
            return rr
        end
    end
    return rr
end


function to_char(c, str)
    local i
    i = string.find(str, c, 1, true)
    if i == nil then
        return str, ""
    end
    return string.sub(str, 1, i-1), string.sub(str, i+1)
end


local function serialize_time(t)
    local ds = t.year .. "-" .. t.mon .. "-" .. t.day
    local ts = t.hour .. "-" .. t.min .. "-" .. t.sec
    return ds .. "T" .. ts
end


local function deserialize_time(str)
    local dt
    local tm
    local y
    local m
    local d
    local h
    local m2
    local s
    dt, tm = to_char("T", str)
    local r = {}
    y, dt = to_char("-", dt)
    m, dt = to_char("-", dt)
    d, dt = to_char("-", dt)
    h, tm = to_char("-", tm)
    m2, tm = to_char("-", tm)
    s, tm = to_char("-", tm)
    r["year"] = tonumber(y)
    r["mon"] = tonumber(m)
    r["day"] = tonumber(d)
    r["hour"] = tonumber(h)
    r["min"] = tonumber(m2)
    r["sec"] = tonumber(s)
    return r
end


local function compare_time(t1, t2)
    if t1.year < t2.year then
        return -1
    end
    if t1.year > t2.year then
        return 1
    end
    if t1.mon < t2.mon then
        return -1
    end
    if t1.mon > t2.mon then
        return 1
    end
    if t1.day < t2.day then
        return -1
    end
    if t1.day > t2.day then
        return 1
    end
    if t1.hour < t2.hour then
        return -1
    end
    if t1.hour > t2.hour then
        return 1
    end
    if t1.min < t2.min then
        return -1
    end
    if t1.min > t2.min then
        return 1
    end
    if t1.sec < t2.sec then
        return -1
    end
    if t1.sec > t2.sec then
        return 1
    end
    return 0
end


function skip_first_spaces(str)
    local max = 1
    local i
    for i = 1, #str do
        if string.sub(str,i,i) ~= " " then
            return string.sub(str,i)
        end
    end
    return str
end


function table_length(tab)
    local c = 0
    local _
    for _ in pairs(tab) do c = c + 1 end
    return c
end


function typeify(s)
    if string.sub(s,1,1) == "n" then
        return tonumber(string.sub(s,2))
    end
    if string.sub(s,1,1) == "s" then
        return string.sub(s, 2)
    end
    if string.sub(s,1,1) == "b" then
        local v = string.sub(s,2)
        if (v == "T") or (v == "t") or (t == "1") then
            return true
        end
        return false
    end
end


function process_worker(str)
    local tab = {}
    local line
    while #str > 0 do
        line, str = to_char("\n", str)
        local k, v = to_char("=", skip_first_spaces(line))
        if skip_first_spaces(k) == "END" then
            return tab, str
        elseif skip_first_spaces(v) == "" then
            v, str = process_worker(str)
        end
        if string.match(k, '^[0-9]+$') then
            k = tonumber(k)
        end
        if type(v) == "table" then
            tab[k] = v
        else
            tab[k] = typeify(v)
        end
    end
    return tab, str
end


function process(str)
    local tab, _ = process_worker(str)
    return tab
end


function table_insert(tab, line)
    local n = table_length(tab)
    tab[n+1] = line
    return tab
end


function serialize_table_worker(tab, indent)
    local k, v
    local lines = {}
    for k, v in pairs(tab) do
        if type(v) == 'table' then
            local vv, _
            lines = table_insert(lines, indent .. k)
            for _, vv in pairs(serialize_table_worker(v, indent .. "  ")) do
                lines = table_insert(lines, vv)
            end
            lines = table_insert(lines, indent.."END")
        else
            local t = type(v)
            if t == "boolean" then
                if v then v = "bt" else v = "bf" end
            end
            if t == "string" then v = "s" .. v end
            if t == "number" then v = "n" .. v end
            -- lines.insert(indent .. k .. '=' .. v)
            lines = table_insert(lines, indent .. k .. '=' .. v)
        end
    end
    return lines
end

function serialize_table(tab)
    return serialize_table_worker(tab, "")
end

-- function print_serialized(serial)
--     local _, v
--     for _,v in pairs(serial) do
--         print(v)
--     end
-- end


function array_to_string(serial)
    local s = ""
    local first = true
    local _, v
    for _,v in pairs(serial) do
        if first ~= true then
            s = s .. "\n"
        end
        s = s .. v
        first = false
    end
    return s
end

function read_all(filename)
    local f = io.open(filename, "r")
    local s = ""
    local read_data = "SOMETHING"
    while read_data ~= "" do
        read_data = io.read(f, 99)
        s = s .. read_data
    end
    io.close(f)
    return s
end

function write_all(filename, lines)
    local f = io.open(filename, "w")
    io.write(f, array_to_string(lines))
    io.close(f)
    return true
end

function model_input_getter(index_1, index_2)
    local model = get_model()
    print("GETTER: INPUT: " ..  index_1 .. "/" .. index_2)
    return model.getInput(index_1, index_2)
end

function model_global_variable_values_getter(index_1, index_2)
    local model = get_model()
    print("GETTER: GLOBAL_VARIABLE_VALUES: " ..  index_1 .. "/" .. index_2)
    return model.getGlobalVariable(index_1, index_2)
end

function model_global_variable_values_getter(index_1, index_2)
    local model = get_model()
    print("GETTER: GLOBAL_VARIABLE_DETAILS" ..  index_1 .. "/" .. index_2)
    return model.getGlobalVariable(index_1, index_2)
end

function model_mix_getter(index_1, index_2)
    local model = get_model()
    print("GETTER: MIX: " ..  index_1 .. "/" .. index_2)
    return model.getMix(index_1, index_2)
end

function model_single_meta_getter(f, desc, index_1, zero_or_nil_return)
    if zero_or_nil_return ~= 0 then return nil end
    local model = get_model()
    print("GETTER: " .. desc .. ": " ..  index_1)
    return f(index_1)
end

function model_output_getter(index_1, zero_or_nil_return)
    return model_single_meta_getter(
        function(index_1, zero_or_nil_return) return model.getOutput(index_1) end,
        "GETTER: OUTPUT",
        index_1,
        zero_or_nil_return
    )
end

function model_curve_getter(index_1, zero_or_nil_return)
    return model_single_meta_getter(
        function(index_1, zero_or_nil_return) return model.getCurve(index_1) end,
        "GETTER: CURVE",
        index_1,
        zero_or_nil_return
    )
end

function model_logical_switch_getter(index_1, zero_or_nil_return)
    return model_single_meta_getter(
        function(index_1, zero_or_nil_return) return model.getLogicalSwitch(index_1) end,
        "GETTER: LOGICAL_SWITCH",
        index_1,
        zero_or_nil_return
    )
end

function model_flight_mode_getter(index_1, zero_or_nil_return)
    return model_single_meta_getter(
        function(index_1, zero_or_nil_return) return model.getFlightMode(index_1) end,
        "GETTER: LOGICAL_SWITCH",
        index_1,
        zero_or_nil_return
    )
end

function model_custom_function_getter(index_1, zero_or_nil_return)
    return model_single_meta_getter(
        function(index_1, zero_or_nil_return) return model.getCustomFunction(index_1) end,
        "GETTER: CUSTOM_FUNCTION",
        index_1,
        zero_or_nil_return
    )
end

function model_global_variable_details_getter(index_1, zero_or_nil_return)
    return model_single_meta_getter(
        function(index_1, zero_or_nil_return) return model.getGlobalVariableDetails(index_1) end,
        "GETTER: GLOBAL_VARIABLE_DETAILS",
        index_1,
        zero_or_nil_return
    )
end

function dump_model_index_index(filename, getter, count)
    write_all(filename, serialize_table(serialize_model_index_index(getter, count)))
end

function dump_model_index(filename, getter, count)
    write_all(filename, serialize_table(serialize_model_index(getter, "", count)))
end

function del_inputs()
    print("LOAD INPUTS")
    local input, input_contents
    local del_inputs = serialize_model_index_index(model_input_getter, 32)
    for input, input_contents in pairs(del_inputs) do
        print("" .. input .. "=" .. table_length(input_contents))
        local i = table_length(input_contents)
        while i > 0 do
            print("model.deleteInput(" .. input - 1 .. ", " .. i - 1 .. ")")
            model.deleteInput(input - 1, i - 1)
    		i = i - 1
        end
    end
end

function load_inputs()
    print("LOAD INPUTS")
    local input, line, value, input_contents
    local inputs = process(read_all("inputs.dat"))

    del_inputs()

    for input, input_contents in pairs(inputs) do
        for line, value in pairs(input_contents) do
            model.insertInput(input - 1, line - 1, value)
        end
    end
end

function del_global_variable_value()
    print("DEL GLOBAL_VARIABLE_VALUES")
    local line, value, input_contents
    local inputs = serialize_model_index_index(model_global_variable_values_getter, 9)

    for input, input_contents in pairs(inputs) do
        for line, value in pairs(input_contents) do
            model.setGlobalVariable(input - 1, line - 1, 0)
        end
    end
end

function load_global_variable_value()
    print("LOAD GLOBAL_VARIABLE_VALUES")
    local line, value, input_contents
    local inputs = process(read_all("global_variable_values.dat"))

    for input, input_contents in pairs(inputs) do
        for line, value in pairs(input_contents) do
            model.setGlobalVariable(input - 1, line - 1, value)
        end
    end
end

function del_mixes()
    print("DEL MIXES")
    local mix, mix_contents, mix

    local del_mixes = serialize_model_index_index(model_mix_getter, 32)
    for mix, mix_contents in pairs(del_mixes) do
        print("" .. mix .. "=" .. table_length(mix_contents))
        local i = table_length(mix_contents)
        while i > 0 do
            print("model.deleteMix(" .. mix - 1 .. ", " .. i - 1 .. ")")
            model.deleteMix(mix - 1, i - 1)
    		i = i - 1
        end
    end

end

function load_mixes()
    print("LOAD MIXES")
    local line, value, mix, mix_contents, mix
    local mixes
    mixes = process(read_all("mixes.dat"))

    del_mixes()

    for mix, mix_contents in pairs(mixes) do
        for line, value in pairs(mix_contents) do
            model.insertMix(mix - 1, line - 1, value)
        end
    end
end

function load_global_variable_details(f, filename)
    print("LOAD " .. filename)
    local line, value, input_contents, idx, tab
    local inputs = process(read_all(filename))
    -- print(array_to_string(serialize_table(process(txt))))
    for idx, tab in pairs(inputs) do
        f(idx, tab)
    end
end

local sel_0 = 0
local sel_1 = 0
local mode = 0
local ui_info = { ["menu"] = { 0 }, ["pos"] = 0, ["selected"] = 0 }

local function maybe_to_upper(b, s)
    if (b) then
        return string.upper(s)
    end
    return s
end

function get_delete_model_index_f(func, max_index)
    local function deleter()
        local i = 0
        while i < max_index do
            local r = func(i, {})
            -- print("R=" .. r .. " for " .. i)
            i = i + 1
        end
    end
    return deleter
end

local function uiPushMenuIndex(ui_pos, n)
    print("uiPushMenuIndex(" .. n .. ")")
    table_insert(ui_pos["menu"], n)
    ui_pos["pos"] = 0
end

local function uiPopMenuIndex(ui_pos)
    local l = table_length(ui_pos["menu"])
    local a = {}
    local r = false
    for k, m in pairs(ui_pos["menu"]) do
        if k < l then
            r = true
            table_insert(a, m)
        end
    end
    ui_pos["menu"] = a
    ui_pos["pos"] = 0
    return r
end

local function uiPeekMenuIndex(ui_pos)
    local l = table_length(ui_pos["menu"])
    print("L=" .. l)
    return ui_pos["menu"][l]
end

local function uiGetPos(ui_pos)
    return ui_pos["pos"]
end

local function uiSetPos(ui_pos, n)
    ui_pos["pos"] = n
end

local function uiRender(menu, ui_pos, event)
    if event == EVT_EXIT_BREAK then
        if uiPopMenuIndex(ui_pos) == false then
            return 1
        end
    end

    if event == EVT_ENTER_BREAK then
        local m = menu[uiGetPos(ui_pos) + 1]
        if m["f"] ~= nil then
            m["f"]()
            return 1
        end
        if m["m"] ~= nil then
            m["m"]()
            return 0
        end
    end
    if event == EVT_ROT_LEFT then
        uiSetPos(ui_pos,uiGetPos(ui_pos) - 1)
        if uiGetPos(ui_pos) < 0 then
            uiSetPos(ui_pos, table_length(menu) - 1)
        end
    end
    if event == EVT_ROT_RIGHT then
        uiSetPos(ui_pos, uiGetPos(ui_pos) + 1)
        if uiGetPos(ui_pos) >= table_length(menu) then
            uiSetPos(ui_pos, 0)
        end
    end

    lcd.clear()
    local mn, k
    for k,mn in pairs(menu) do
        print("mn/" .. uiPeekMenuIndex(ui_pos) .. "/" .. uiGetPos(ui_pos), dump_table(mn))
        lcd.drawText(mn["x"], mn["y"], maybe_to_upper(uiGetPos(ui_pos) + 1 == k, mn["t"]), mn["s"])
    end
    return 0
end




local function run(event)

    local delete_funcs = {
            del_inputs,
            del_mixes,
            get_delete_model_index_f(
                function(i) model.setOutput(i, {}) end,
                32
            ),
            get_delete_model_index_f( -- DOES DELETE FIRST???
                function(i)
                    local tab = {
                        points = 5,
                        type = 0,
                        x = { 0, 0, 0, 0, 0 },
                        smooth = false,
                        name = "",
                    }
                    return model.setCurve(i, tab)
                end,
                32
            ),
            del_global_variable_value,
            get_delete_model_index_f(
                function(i) model.setCustomFunction(i, {}) end,
                9
            ),
            get_delete_model_index_f(
                function(i) model.setLogicalSwitch(i, {}) end,
                64
            ),
            function() model.deleteFlightModes() end,
            get_delete_model_index_f(
                function(i) model.setGlobalVariableDetails(i, {}) end,
                9
            ),
    }
    local write_funcs = {
            function() return dump_model_index_index("inputs.dat", model_input_getter, 32) end,
            function() return dump_model_index_index("mixes.dat", model_mix_getter, 32) end,
            function() return dump_model_index("outputs.dat", model_output_getter, 32) end,
            function() return dump_model_index("curves.dat", model_curve_getter, 32) end,
            function() return dump_model_index_index("global_variable_values.dat", model_global_variable_values_getter, 9) end,
            function() return dump_model_index("custom_functions.dat", model_custom_function_getter, 64) end,
            function() return dump_model_index("logical_switches.dat", model_logical_switch_getter, 64) end,
            function() return dump_model_index("flight_modes.dat", model_flight_mode_getter, 8) end,
            function() return dump_model_index("global_variable_details.dat", model_global_variable_details_getter, 9) end,
        }

    local read_funcs = {
            load_inputs,
            load_mixes,
            function()
                return load_global_variable_details(
                    function(idx, tab) model.setOutput(idx - 1, tab) end,
                    "outputs.dat"
                )
            end,
            function()
                load_global_variable_details(
                    function(idx, tab)
                        print("set curve " .. idx)
                        -- print(dump_table(tab))
                        local r = model.setCurve(idx - 1, tab)
                        print("R=" .. r)
                    end,
                    "curves.dat"
                )
            end,
            load_global_variable_value,
            function()
                load_global_variable_details(
                    function(idx, tab) model.setCustomFunction(idx - 1, tab) end,
                    "custom_functions.dat"
                )
            end,
            function()
                load_global_variable_details(
                    function(idx, tab) model.setLogicalSwitch(idx - 1, tab) end,
                    "logical_switches.dat"
                )
            end,
            function()
                load_global_variable_details(
                    function(idx, tab) model.setFlightMode(idx - 1, tab) end,
                    "flight_modes.dat"
                )
            end,
            function()
                load_global_variable_details(
                    function(idx, tab) model.setGlobalVariableDetails(idx - 1, tab) end,
                    "global_variable_details.dat"
                )
            end,
        }

    local funcs = { write_funcs, read_funcs, delete_funcs }


    local function which_to_process_from_mark(mark_time)
        local file_list = {
            "inputs.dat",
            "mixes.dat",
            "outputs.dat",
            "curves.dat",
            "global_variable_values.dat",
            "custom_functions.dat",
            "logical_switches.dat",
            "flight_modes.dat",
            "global_variable_details.dat",
        }
        local r = {}
        local k
        local fle
        for k,fle in pairs(file_list) do
            local fle_fstat = fstat(fle)
            if fle_fstat ~= nil and fle_fstat.time ~= nil then
                print(k .. " " .. fle .. ": " .. serialize_time(mark_time) .. "/" .. serialize_time(fle_fstat.time) .. "=" .. compare_time(fle_fstat.time, mark_time))
                if compare_time(fle_fstat.time, mark_time) > 0 then
                    r = table_insert(r, k)
                end
            end
        end
        return r
    end

    local function set_time_mark()
        s = serialize_time(getDateTime())
        local f = io.open("mark.time", "w")
        io.write(f, s)
        return 1
    end

    local function load_from_mark()
        local mark_time_str = read_all("mark.time")
        local mark_time = deserialize_time(mark_time_str)
        local file_list = which_to_process_from_mark(mark_time)
        for k,func_index in pairs(file_list) do
            local f = funcs[2][func_index]
            print("DO: " .. func_index)
            f()
        end
        return 1
    end

    local function getUiMenu(n)
        if uiPeekMenuIndex(ui_info) == 0 then
            return {
                { ["x"] = 1, ["y"] = 1, ["s"] = SMLSIZE, ["t"] = "export", ["m"] = function() uiPushMenuIndex(ui_info, 1) end },
                { ["x"] = 1, ["y"] = 9, ["s"] = SMLSIZE, ["t"] = "import", ["m"] = function() uiPushMenuIndex(ui_info, 2) end },
                { ["x"] = 1, ["y"] = 18, ["s"] = SMLSIZE, ["t"] = "clear", ["m"] = function() uiPushMenuIndex(ui_info, 3) end },
                { ["x"] = 1, ["y"] = 27, ["s"] = SMLSIZE, ["t"] = "set time mark", ["f"] = set_time_mark },
                { ["x"] = 1, ["y"] = 36, ["s"] = SMLSIZE, ["t"] = "load from time", ["f"] = load_from_mark },
            }
        end

        funcs = write_funcs
        if uiPeekMenuIndex(ui_info) == 2 then
            print("R")
            funcs = read_funcs
        end
        if uiPeekMenuIndex(ui_info) == 3 then
            print("D")
            funcs = delete_funcs
        end

        return {
            { ["x"] = 1,  ["y"] = 9,  ["s"] = SMLSIZE, ["t"] = "inputs", ["f"] = funcs[1] },
            { ["x"] = 64, ["y"] = 9,  ["s"] = SMLSIZE, ["t"] = "mixes", ["f"] = funcs[2] },
            { ["x"] = 1,  ["y"] = 18, ["s"] = SMLSIZE, ["t"] = "outputs", ["f"] = funcs[3] },
            { ["x"] = 64, ["y"] = 18, ["s"] = SMLSIZE, ["t"] = "curves", ["f"] = funcs[4] },
            { ["x"] = 1,  ["y"] = 27, ["s"] = SMLSIZE, ["t"] = "gvar values", ["f"] = funcs[5] },
            { ["x"] = 64, ["y"] = 27, ["s"] = SMLSIZE, ["t"] = "functions", ["f"] = funcs[6] },
            { ["x"] = 1,  ["y"] = 36, ["s"] = SMLSIZE, ["t"] = "logical sw", ["f"] = funcs[7] },
            { ["x"] = 64, ["y"] = 36, ["s"] = SMLSIZE, ["t"] = "flight modes", ["f"] = funcs[8] },
            { ["x"] = 1,  ["y"] = 45, ["s"] = SMLSIZE, ["t"] = "gvar details", ["f"] = funcs[9] },
        }

    end

    return uiRender(getUiMenu(uiPeekMenuIndex(ui_info)), ui_info, event)

end

function zzz ()

    if mode == 2 then
        if sel_1 == 4 then
            s = serialize_time(getDateTime())
            local f = io.open("mark.time", "w")
            io.write(f, s)
            return 1
        end
        if sel_1 == 3 then
            local mark_time_str = read_all("mark.time")
            local mark_time = deserialize_time(mark_time_str)
            local file_list = which_to_process_from_mark(mark_time)
            for k,func_index in pairs(file_list) do
                local f = funcs[2][func_index]
                print("DO: " .. func_index)
                f()
            end
            return 1
        end
        print(sel_1 .. "/" .. sel_0)
        local f = funcs[sel_1 + 1][sel_0 + 1]
        print("call f ++" .. sel_1 .. "/" .. sel_0)
        print("t1=" .. table_length(funcs[1]))
        print("t2=" .. table_length(funcs[2]))
        f()
        print("call f --")
        return 1
    end







    if event == EVT_EXIT_BREAK then
        if mode == 0 then
            return 1
        end
        if mode == 1 then
            mode = 0
        end
    end

    if mode == 0 then
        local max_menu = 8
        if event == EVT_ROT_LEFT then
            sel_0 = sel_0 - 1
        end
        if event == EVT_ROT_RIGHT then
            sel_0 = sel_0 + 1
        end
        if (sel_0 < 0) then
            sel_0 = max_menu
        end
        if (sel_0 > max_menu) then
            sel_0 = 0
        end
    end

    if mode == 1 then
        local max_menu = 4
        if event == EVT_ROT_LEFT then
            sel_1 = sel_1 - 1
        end
        if event == EVT_ROT_RIGHT then
            sel_1 = sel_1 + 1
        end
        if (sel_1 < 0) then
            sel_1 = max_menu
        end
        if (sel_1 > max_menu) then
            sel_1 = 0
        end
    end

    lcd.clear()
    lcd.drawText(1, 1, maybe_to_upper(sel_0 == 0, 'inputs'), SMLSIZE)
    lcd.drawText(1, 9, maybe_to_upper(sel_0 == 1, 'mixes'), SMLSIZE)
    lcd.drawText(1, 18, maybe_to_upper(sel_0 == 2, 'outputs'), SMLSIZE)
    lcd.drawText(1, 27, maybe_to_upper(sel_0 == 3, 'curves'), SMLSIZE)
    lcd.drawText(1, 36, maybe_to_upper(sel_0 == 4, 'gvar values'), SMLSIZE)
    lcd.drawText(64, 1,  maybe_to_upper(sel_0 == 5, 'functions'), SMLSIZE)
    lcd.drawText(64, 9,  maybe_to_upper(sel_0 == 6, 'logical sw'), SMLSIZE)
    lcd.drawText(64, 18, maybe_to_upper(sel_0 == 7, 'flight modes'), SMLSIZE)
    lcd.drawText(64, 27, maybe_to_upper(sel_0 == 8, 'gvar details'), SMLSIZE)

    lcd.drawText(12, 48, maybe_to_upper((mode == 1) and (sel_1 == 0), '[exp]'), SMLSIZE)
    lcd.drawText(44, 48, maybe_to_upper((mode == 1) and (sel_1 == 1), '[imp]'), SMLSIZE)
    lcd.drawText(76, 48, maybe_to_upper((mode == 1) and (sel_1 == 2), '[del]'), SMLSIZE)
    lcd.drawText(12, 57, maybe_to_upper((mode == 1) and (sel_1 == 3), '[mrk_imp]'), SMLSIZE)
    lcd.drawText(76, 57, maybe_to_upper((mode == 1) and (sel_1 == 4), '[mrk]'), SMLSIZE)

    return 0
end

run()

return {init = init, run = run}


