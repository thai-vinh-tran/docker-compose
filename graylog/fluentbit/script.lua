-- docker-metadata.lua
cjson = require("cjson")
DOCKER_VAR_DIR = "/var/lib/docker/containers/"
DOCKER_CONFIG_FILE = "/config.v2.json"

function enrich_with_docker_metadata(tag, timestamp, record)
    -- Extract container ID from tag
    local container_id = tag:match("docker%.(.+)")
    if not container_id then
        return 0, timestamp, record
    end

    -- Read metadata from config.v2.json
    local config_file_path = DOCKER_VAR_DIR .. container_id .. DOCKER_CONFIG_FILE
    local config_file = io.open(config_file_path, "r")
    if not config_file then
        return 0, timestamp, record
    end

    local config_json = config_file:read("*a")
    config_file:close()

    -- Parse JSON and extract container name
    local config = cjson.decode(config_json)
    local container_name = config.Name:gsub("^/", "") -- Remove leading '/'

    -- Add container name to record
    local new_record = record
    new_record["container_name"] = container_name

    return 1, timestamp, new_record
end