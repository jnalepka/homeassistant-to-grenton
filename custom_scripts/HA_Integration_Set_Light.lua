-- ╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
-- ║                        Author: Jan Nalepka                                                           ║
-- ║                                                                                                      ║
-- ║ Script: HA_Integration_Set_Light                                                                     ║
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
-- ║          1.  ha_entity, default: "light.my_lamp", string                                             ║
-- ║          2.  ha_method, default: "toggle", string                                                    ║
-- ║          3.  attr_brightness, default: -1, number [0-255]                                            ║
-- ║          4.  attr_hs_color, default: "-", string "[hue, sat]", "[300, 70]"                           ║
-- ║          5.  attr_color_temp, default: -1, number [153-500]                                          ║
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
-- ║          -  turn_on(attr_brightness)                                                                 ║
-- ║          -  turn_on(attr_brightness, attr_hs_color)                                                  ║
-- ║          -  turn_on(attr_brightness, attr_hs_color)                                                  ║
-- ║          -  turn_off                                                                                 ║
-- ║          -  toggle                                                                                   ║
-- ║                                                                                                      ║
-- ║    Examples:                                                                                         ║
-- ║          - entity="light.lamp1", method="turn_on"                                                    ║
-- ║          - entity="light.lamp1", method="turn_on", brightness=255                                    ║
-- ║          - entity="light.lamp1", method="turn_on", brightness=255, hs_color="[300, 70]"              ║
-- ║          - entity="light.lamp1", method="turn_on", brightness=255, color_temp=450                    ║
-- ║                                                                                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝

local ha_service, ha_entity_name = string.match(ha_entity, "([^%.]+)%.([^%.]+)")
local path = "/api/services/"..ha_service.."/"..ha_method
local reqJson = { entity_id = ha_entity }

if attr_brightness ~= -1 then 
	reqJson.brightness = attr_brightness 
end

if attr_hs_color ~= "-" then 
	reqJson.hs_color = attr_hs_color
end

if attr_color_temp ~= -1 then 
	reqJson.color_temp = attr_color_temp 
end

GATE_HTTP->HA_Request_Set->SetPath(path)
GATE_HTTP->HA_Request_Set->SetRequestBody(reqJson)
GATE_HTTP->HA_Request_Set->SendRequest()
