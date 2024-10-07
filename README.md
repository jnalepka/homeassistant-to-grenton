# Home Assistant to Grenton

Run services and read entities from Home Assistant in the Grenton system.

## Home Assistant Long-lived access token

In Home Assistant go to the Profile->Security->Long-lived access tokens, and create the long-lived access token. Token will be valid for 10 years from creation.

## Read entities from Home Assistant

1. On the Gate HTTP, create an `HttpRequest` virtual object:

   ![image](https://github.com/user-attachments/assets/dfa7284b-c2d7-409c-9e85-8979bc95d209)

   * `Name`: HA_Request_Get_States
   * `Host`: http://<your HA IP Address>:8123 (e.g. http://192.168.0.114:8123)
   * `Path`: /api/states
   * `Method`: GET
   * `RequestType`: JSON
   * `ResponseType`: JSON
   * `RequestHeadres`: Authorization: Bearer <your Long-lived access token> (e.g. Authorization: Bearer eyJhbGciOiJIUz.....)
  
2. On the Gate HTTP, create a script, named `HA_Integration_Response`:

    ```lua
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ║                        Author: Jan Nalepka                            ║
    -- ║                                                                       ║
    -- ║ Script: HA_Integration_Response                                       ║
    -- ║ Description: Analyze all entities from Home Assistant.                ║
    -- ║                                                                       ║
    -- ║ License: MIT License                                                  ║
    -- ║ Github: https://github.com/jnalepka/homeassistant-to-grenton          ║
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
    
    ```

3. Attach the script to the `HA_Request_Get_States` OnResponse event:

   ![image](https://github.com/user-attachments/assets/23921008-6963-4f0c-964b-4337c9821a3f)

4. On the Gate HTTP, create a `Timer` virtual object:

  ![image](https://github.com/user-attachments/assets/4a398e02-8c5d-4246-85fa-335cd73fcbce)

  * `Name`: HA_Request_Timer
  * `Time`: 10000 ms ((You can change it if you want, but 10 seconds is quite enough)
  * `Mode`: Interval

5. Attach the `HA_Request_Get_States` SendRequest() method to the `HA_Request_Timer` OnStart and OnTimer events:

  ![image](https://github.com/user-attachments/assets/e0ac09b7-13e8-4984-8e6f-f681d37cfe1d)

6. Attach the `HA_Request_Timer` Start() method to the `GATE_HTTP` OnInit event:

   ![image](https://github.com/user-attachments/assets/f847371c-3bf0-4225-a3cc-abdf6be467b1)










   


