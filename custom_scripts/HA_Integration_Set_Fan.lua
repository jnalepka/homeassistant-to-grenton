
-- ╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
-- ║                        Author: Jan Nalepka                                                           ║
-- ║                                                                                                      ║
-- ║ Script: HA_Integration_Set_Fan                                                                       ║
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
-- ║          1.  ha_entity, default: "fan.my_fan", string                                                ║
-- ║          2.  ha_method, default: "toggle", string                                                    ║
-- ║          3.  attr_percentage, default: -1, number [0-100] %                                          ║
-- ║          4.  attr_preset_mode, default: "-", string   "auto",...                                     ║
-- ║          5.  attr_direction, default: "-", string   "forward", "reverse"                             ║
-- ║          6.  attr_oscilating, default: "-", string   "true", "false"                                 ║
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
-- ║          -  turn_on(attr_percentage)                                                                 ║
-- ║          -  turn_on(attr_preset_mode)                                                                ║
-- ║          -  turn_on(attr_percentage, attr_preset_mode)                                               ║
-- ║          -  set_percentage(attr_percentage)                                                          ║
-- ║          -  set_preset_mode(attr_preset_mode)                                                        ║
-- ║          -  turn_off                                                                                 ║
-- ║          -  toggle                                                                                   ║
-- ║          -  set_direction(attr_direction)                                                            ║
-- ║          -  increase_speed(attr_percentage)                                                          ║
-- ║          -  decrease_speed(attr_percentage)                                                          ║
-- ║          -  oscillate(attr_oscilating)                                                               ║
-- ║                                                                                                      ║
-- ║    Examples:                                                                                         ║
-- ║          - entity="fan.fan1", method="turn_on"                                                       ║
-- ║          - entity="fan.fan1", method="turn_on", percentage=100                                       ║
-- ║          - entity="fan.fan1", method="turn_on", preset_mode="auto"                                   ║
-- ║          - entity="fan.fan1", method="turn_on", percentage=100, preset_mode="auto"                   ║
-- ║          - entity="fan.fan1", method="set_percentage", percentage=100                                ║
-- ║          - entity="fan.fan1", method="set_preset_mode", preset_mode="auto"                           ║
-- ║          - entity="fan.fan1", method="set_direction", direction="forward"                            ║
-- ║          - entity="fan.fan1", method="increase_speed", percentage=100                                ║
-- ║          - entity="fan.fan1", method="decrease_speed", percentage=100                                ║
-- ║          - entity="fan.fan1", method="oscillate", oscilating="true"                                  ║
-- ║                                                                                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝

local ha_service, ha_entity_name = string.match(ha_entity, "([^%.]+)%.([^%.]+)")
local path = "/api/services/"..ha_service.."/"..ha_method
local reqJson = { entity_id = ha_entity }

if ha_method == "increase_speed" or ha_method == "decrease_speed" then 
	reqJson.percentage_step = attr_percentage 
elseif attr_percentage ~= -1 then 
	reqJson.percentage = attr_percentage 
end

if attr_preset_mode ~= "-" then 
	reqJson.preset_mode = attr_preset_mode
end

if attr_direction ~= "-" then 
	reqJson.direction = attr_direction
end

if attr_oscilating ~= "-" then
	if attr_oscilating == "true" then 
  	reqJson.oscillating = true
  else
    reqJson.oscillating = false
  end
end

GATE_HTTP->HA_Request_Set->SetPath(path)
GATE_HTTP->HA_Request_Set->SetRequestBody(reqJson)
GATE_HTTP->HA_Request_Set->SendRequest()
