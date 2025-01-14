
-- ╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
-- ║                        Author: Jan Nalepka                                                           ║
-- ║                                                                                                      ║
-- ║ Script: HA_Integration_Set_Climate                                                                   ║
-- ║ Description: Send a service command for an entity in Home Assistant.                                 ║
-- ║                                                                                                      ║
-- ║ License: MIT License                                                                                 ║
-- ║ Github: https://github.com/jnalepka/homeassistant-to-grenton                                         ║
-- ║                                                                                                      ║
-- ║ Version: 1.0.0                                                                                       ║
-- ║                                                                                                      ║
-- ║ Requirements:                                                                                        ║
-- ║    Gate Http:                                                                                        ║
-- ║          1.  Gate Http NAME: "GATE_HTTP" <or change it in this script>                               ║
-- ║                                                                                                      ║
-- ║    Script parameters:                                                                                ║
-- ║          1.  ha_entity, default: "climate.my_therm", string                                     ║
-- ║          2.  ha_method, default: "toggle", string                                                    ║
-- ║          3.  attr_temperature, default: -1, number [0-250] step: 0.1                                 ║
-- ║          4.  attr_hvac_mode, default: "-", string "off/auto/cool/dry/fan_only/heat_cool/heat"        ║
-- ║          5.  attr_fan_mode, default: "-", string "low"                                               ║
-- ║          6.  attr_preset_mode, default: "-", string "away"                                           ║
-- ║                                                                                                      ║
-- ║    Http_Request virtual object:                                                                      ║
-- ║          Name: HA_Request_Set                                                                        ║
-- ║          Host: http://192.168.0.114:8123  (example)                                                  ║
-- ║          Path: /api/state (any value)                                                                ║
-- ║          Method: "POST"                                                                              ║
-- ║          RequestType: JSON                                                                           ║
-- ║          ResponseType: JSON                                                                          ║
-- ║          RequestHeaders: Authorization: Bearer <your HA token>                                       ║
-- ║                                                                                                      ║
-- ║    Available methods:                                                                                ║
-- ║          -  turn_on                                                                                  ║
-- ║          -  turn_off                                                                                 ║
-- ║          -  toggle                                                                                   ║
-- ║          -  set_temperature(attr_temperature)                                                        ║
-- ║          -  set_hvac_mode(attr_hvac_mode)                                                            ║
-- ║          -  set_fan_mode(attr_fan_mode)                                                              ║
-- ║          -  set_preset_mode(attr_preset_mode)                                                        ║
-- ║                                                                                                      ║
-- ║    Examples:                                                                                         ║
-- ║          - entity="climate.my_therm", method="turn_on"                                               ║
-- ║          - entity="climate.my_therm", method="set_temperature", attr_temperature=21.1                ║
-- ║          - entity="climate.my_therm", method="set_hvac_mode", attr_hvac_mode="heat"                  ║
-- ║          - entity="climate.my_therm", method="set_fan_mode", attr_fan_mode="low"                     ║
-- ║          - entity="climate.my_therm", method="set_preset_mode", attr_preset_mode="away"              ║
-- ║                                                                                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝

local ha_service, ha_entity_name = string.match(ha_entity, "([^%.]+)%.([^%.]+)")
local path = "/api/services/"..ha_service.."/"..ha_method
local reqJson = { entity_id = ha_entity }

if attr_temperature ~= -1 then 
	reqJson.temperature = attr_temperature 
end

if attr_hvac_mode ~= "-" then 
	reqJson.hvac_mode = attr_hvac_mode
end

if attr_fan_mode ~= "-" then 
	reqJson.fan_mode = attr_fan_mode
end

if attr_preset_mode ~= "-" then 
	reqJson.preset_mode = attr_preset_mode
end


GATE_HTTP->HA_Request_Set->SetPath(path)
GATE_HTTP->HA_Request_Set->SetRequestBody(reqJson)
GATE_HTTP->HA_Request_Set->SendRequest()
