function split(s, delimiter)
    result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function StringToCoords(s)
    local a = split(s, ",")
    return {x = tonumber(a[1]), y = tonumber(a[2]), z = tonumber(a[3])}
end
