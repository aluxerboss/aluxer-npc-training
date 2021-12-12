Aluxer = {} or nil
--[[
    Resource Name : ALUXER NPC TRAINING
    Developer : ALUXER#9951 (Discord)
]]

Aluxer['about'] = {
    zone = {
        [1] = {
            coords = vector3(-737.3802, -2029.596, 8.891602), -- ตำแหน่ง | location coords
            model = "mp_m_freemode_01",-- โมเดลเอ็นพีซี | model ped
            max = 15, -- ลิมิตได้กี่ตัว | limit spawn
            respawn = 1000, -- ดีเลย์การเกิด | delay dpawn
            dist = 50.0, -- ระยะของการเกิด | distand
        },
		
	[2] = {
            coords = vector3(3110.93, -4762.67, 15.25),
            model = "mp_m_freemode_01",
            max = 5,
            respawn = 1000,
            dist = 5.0,
        }
    }
}
