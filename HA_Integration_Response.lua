-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║                        Author: Jan Nalepka                            ║
-- ║                                                                       ║
-- ║ Script: HA_Integration_Response                                       ║
-- ║ Description: Analyze all entities from Home Assistant.                ║
-- ║                                                                       ║
-- ║ License: MIT License                                                  ║
-- ║ Github: https://github.com/jnalepka                                   ║
-- ║                                                                       ║
-- ║ Version: 1.0.0                                                        ║
-- ║                                                                       ║
-- ║ Requirements:                                                         ║
-- ║    Gate Http:                                                         ║
-- ║          1.  Gate Http NAME: "GATE_HTTP" <or change it in this script>║
-- ║                                                                       ║
-- ║    Http_Request virtual object:                                       ║
-- ║          Name: HA_Request_Get_States                                  ║
-- ║          Host: http://192.168.0.114:8123  (example)                   ║
-- ║          Path: /api/states                                            ║
-- ║          RequestType: JSON                                            ║
-- ║          ResponseType: JSON                                           ║
-- ║          RequestHeaders: Authorization: Bearer <your HA token>        ║
-- ║                                                                       ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

local respJson = GATE_HTTP->HA_Request_Get_States->ResponseBody

if respJson ~= nil then
	for i = 1, #respJson do
	    local entity_id = respJson[i].entity_id
	    
-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║                   READ YOUR ENTITIES BELOW                            ║
-- ╚═══════════════════════════════════════════════════════════════════════╝
		
		-- EXAMPLE, YOU CAN DELETE IT
	
	    if entity_id == "light.tv_light" then
	    	if respJson[i].state == "on" then
	    		GATE_HTTP->HA_tv_light_value = 1
	    	else
	    		GATE_HTTP->HA_tv_light_value = 0
	    	end
	    	
	    	-- example of getting an attributes
			local FriendlyName = respJson[i].attributes.friendly_name
			local ColorMode = respJson[i].attributes.color_mode
	    end
	    
	    
	    
	    -- TO DO
	    
	end
end
