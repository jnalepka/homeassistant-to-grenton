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

   > Note: If you use a different name for the Gate HTTP or the virtual object, modify it in the script.

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

## Run the Home Assistant service

1. On the Gate HTTP, create an `HttpRequest` virtual object:

   ![image](https://github.com/user-attachments/assets/2de2248c-6992-42a3-b91e-ad0506311d89)

   * `Name`: HA_Request_Set
   * `Host`: http://<your HA IP Address>:8123 (e.g. http://192.168.0.114:8123)
   * `Path`: /api/state (any value)
   * `Method`: POST
   * `RequestType`: JSON
   * `ResponseType`: JSON
   * `RequestHeadres`: Authorization: Bearer <your Long-lived access token> (e.g. Authorization: Bearer eyJhbGciOiJIUz.....)

2. On the Gate HTTP, create a script, named `HA_Integration_Set`:

    ```lua
      -- ╔═══════════════════════════════════════════════════════════════════════╗
      -- ║                        Author: Jan Nalepka                            ║
      -- ║                                                                       ║
      -- ║ Script: HA_Integration_Set                                            ║
      -- ║ Description: Send a service command for an entity in Home Assistant.  ║
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
      -- ║    Script parameters:                                                 ║
      -- ║          1.  ha_entity, default: "light.my_lamp", string              ║
      -- ║          2.  ha_method, default: "toggle", string                     ║
      -- ║                                                                       ║
      -- ║    Http_Request virtual object:                                       ║
      -- ║          Name: HA_Request_Set                                         ║
      -- ║          Host: http://192.168.0.114:8123  (example)                   ║
      -- ║          Path: /api/state (any value)                                 ║
      -- ║          Method: "POST"                                               ║
      -- ║          RequestType: JSON                                            ║
      -- ║          ResponseType: JSON                                           ║
      -- ║          RequestHeaders: Authorization: Bearer <your HA token>        ║
      -- ║                                                                       ║
      -- ╚═══════════════════════════════════════════════════════════════════════╝
      
      local ha_service, ha_entity_name = string.match(ha_entity, "([^%.]+)%.([^%.]+)")
      local path = "/api/services/"..ha_service.."/"..ha_method
      local reqJson = { entity_id = ha_entity }
      
      GATE_HTTP->HA_Request_Set->SetPath(path)
      GATE_HTTP->HA_Request_Set->SetRequestBody(reqJson)
      GATE_HTTP->HA_Request_Set->SendRequest()

    ```

    > Note: If you use a different name for the Gate HTTP or the virtual object, modify it in the script.

3. Add the script parameters to the `HA_Integration_Set` script:

   ![image](https://github.com/user-attachments/assets/d8e08f3d-7d67-4b77-9d2f-b5a50c7d52d9)

   * `Name`: ha_entity `Type`: string
   * `Name`: ha_method `Type`: string

4. (Optional) Attach the `HA_Request_Timer` Start() method to the `HA_Request_Set` OnResponse event:

   ![image](https://github.com/user-attachments/assets/bb1b97ed-0c33-4530-8390-06ff0992ad0d)

   This operation will update all states from HomeASsistant after the action.

5. Now you can call the `HA_Integration_Set` script from everywhere in the Grenton System!

   ![image](https://github.com/user-attachments/assets/948074ff-c0ac-4ecd-bdfa-75c5f8e74b5c)





   


