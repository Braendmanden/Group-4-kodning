pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	grid = {}
	for x = 0, 15 do
	grid[x] = {}
	for y = 0, 15 do

	grid[x][y] = 0

	end
	end
	
	grid_oofset_x = 12
	grid_offset_y = 10

	 -- dead satellite
	 -- alive satellite
	 -- debris

	poke(0x5f2d, 1)
	cannon_x = 64
	cannon_y = 115
	
	nets_left = 5
	score = 0 
	mouse_was_down = false
	
	position=100
	timer=3000
	true_timer=0
end

function _update()
	if (timer>0) then
	timer=timer-1
	true_timer=flr(timer/30)
 local mouse_x = stat(32) 
 cannon_x = mid(22, mouse_x, 106)
	end
	
	local mouse_down = band(stat(34), 1) !=0 -- checks left mouse button
	
	if mouse_down and not mouse_was_down then 
		if nets_left > 0 then
			nets_left = nets_left - 1
		end
	end
	
	mouse_was_down = mouse_down
	
end

function _draw()
	cls()

	-- draws sprites 
		spr(1,4,64) -- alien guy
		spr(1,4,54) -- one more
		spr(1,4,44) -- one more
		spr(1,4,34) -- one more
		spr(1,116,64) -- one more
		spr(1,116,54) -- one more
		spr(1,116,44) -- one more
		spr(1,116,34) -- one more
	
	print("timer: "..true_timer,1,1,10) -- timer that counts down 
	print("space spree",40,3,12) -- title card

	-- cannon body 
		rectfill(cannon_x-4, cannon_y, cannon_x+4, cannon_y+4, 12)

	-- cannon barrel 
		rectfill(cannon_x-1, cannon_y-3, cannon_x+1, cannon_y, 7)
	
	-- displays counters 
	print("score: " ..score, 1,123,7)
	print("nets: " ..nets_left ,100,123,7)
	
	for x = 0, 9 do 
		for y = 0, 9 do 

			local px = grid_oofset_x + x * 10
			local py = grid_offset_y + y * 10

			rect(px, py, px + 9, py + 9, 5)
					
		end
	end
	
end



__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700002620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006360000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700060006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
