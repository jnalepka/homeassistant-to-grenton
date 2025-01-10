-- ╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗
-- ║                        Author: Jan Nalepka                                                           ║
-- ║                                                                                                      ║
-- ║ Script: HA_Integration_Set_Cover                                                                     ║
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
-- ║          1.  ha_entity, default: "cover.my_blind", string                                            ║
-- ║          2.  ha_method, default: "toggle", string                                                    ║
-- ║          3.  attr_position, default: -1, number [0-100]                                              ║
-- ║          4.  attr_tilt_position, default: -1, number [0-100]                                         ║
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
-- ║          -  open_cover                                                                               ║
-- ║          -  close_cover                                                                              ║
-- ║          -  toggle                                                                                   ║
-- ║          -  set_cover_position(attr_position)   range=[0-100] %                                      ║
-- ║          -  stop_cover                                                                               ║
-- ║          -  open_cover_tilt                                                                          ║
-- ║          -  close_cover_tilt                                                                         ║
-- ║          -  toggle_cover_tilt                                                                        ║
-- ║          -  set_cover_tilt_position(attr_tilt_position)   range=[0-100] %                            ║
-- ║          -  stop_cover_tilt                                                                          ║
-- ║                                                                                                      ║
-- ║    Examples:                                                                                         ║
-- ║          - entity="cover.blind1", method="toggle"                                                    ║
-- ║          - entity="cover.blind1", method="set_cover_position", position=100                          ║
-- ║          - entity="cover.blind1", method="set_cover_tilt_position", tilt_position=100                ║
-- ║                                                                                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝

local ha_service, ha_entity_name = string.match(ha_entity, "([^%.]+)%.([^%.]+)")
local path = "/api/services/"..ha_service.."/"..ha_method
local reqJson = { entity_id = ha_entity }

if attr_position ~= -1 then 
	reqJson.position = attr_position
end

if attr_tilt_position ~= -1 then 
	reqJson.tilt_position = attr_tilt_position
end

GATE_HTTP->HA_Request_Set->SetPath(path)
GATE_HTTP->HA_Request_Set->SetRequestBody(reqJson)
GATE_HTTP->HA_Request_Set->SendRequest()
