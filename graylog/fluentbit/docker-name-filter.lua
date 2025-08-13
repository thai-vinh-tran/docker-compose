-- docker-name-filter.lua
cjson = require("cjson")

function filter_by_container_name(tag, timestamp, record)
    local container_id = tag:match("docker%.(.+)")
    if not container_id then
        return 0, timestamp, record
    end

    local config_file_path = "/var/lib/docker/containers/" .. container_id .. "/config.v2.json"
    local config_file = io.open(config_file_path, "r")
    if not config_file then
        return 0, timestamp, record
    end

    local config_json = config_file:read("*a")
    config_file:close()

    local config = cjson.decode(config_json)
    local container_name = config.Name:gsub("^/", "")

    local regex = "^container_name_needed*" -- Adjust regex as needed
    if not string.match(container_name, regex) then
        return 0, timestamp, record
    end

    local new_record = record
    new_record["container_name"] = container_name

    return 1, timestamp, new_record
end