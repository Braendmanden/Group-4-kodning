pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function randomize_grid()
	for x = 0, 9 do
		for y = 0, 9 do
			grid[x][y] = flr(rnd(4))
		end
	end
end

function _init()
	grid = {}
	revealed = {}
	for x = 0, 9 do
		grid[x] = {}
		revealed[x] = {}
		for y = 0, 9 do
			grid[x][y] = 0
			revealed[x][y] = false
		end
	end
	
	randomize_grid()

	poke(0x5f2d, 1)
	cannon_x = 64
	cannon_y = 115
	timer = 3000
	true_timer = 0
	point_counter = 0
	prev_mouse_down = false
end

function _update()
	if (timer > 0) then
		timer = timer - 1
		true_timer = flr(timer / 30)
		
		-- mouse controls
		local mouse_x = stat(32) 
		local mouse_y = stat(33)
		cannon_x = mid(10, mouse_x, 117)
		
		-- click detection
		local cols = 10
		local rows = 10
		local cell_size = 8
		local grid_w = cols * cell_size
		local grid_h = rows * cell_size
		local start_x = flr((128 - grid_w) / 2)
		local start_y = flr((128 - grid_h) / 2)
		
		local hover_x = flr((mouse_x - start_x) / cell_size)
		local hover_y = flr((mouse_y - start_y) / cell_size)
		
		
		local mouse_down = (stat(34) > 0)
		local clicked = (mouse_down and not prev_mouse_down) or btnp(4)
		prev_mouse_down = mouse_down
		
		if clicked then
			if hover_x >= 0 and hover_x <= 9 and hover_y >= 0 and hover_y <= 9 then
				-- only reveal and add points if it hasn't been clicked yet
				if not revealed[hover_x][hover_y] then
					revealed[hover_x][hover_y] = true
					point_counter = point_counter + grid[hover_x][hover_y]
				end
			end
		end
	end
end

function _draw()
	cls()
	spr(1, 4, 64) --alien guy
	spr(1, 4, 54) --one more
	spr(1, 4, 44) --one more
	spr(1, 4, 34) --one more
	spr(1, 116, 64) --one more
	spr(1, 116, 54) --one more
	spr(1, 116, 44) --one more
	spr(1, 116, 34) --one more
	
	-- ui text
	print("timer: "..true_timer, 1, 1, 10)
	print("points: "..point_counter, 82, 1, 10)
	
	print("space spree:", 40, 10, 12) --title card

	--cannon body 
	rectfill(cannon_x - 8, cannon_y, cannon_x + 8, cannon_y + 8, 12)

	--cannon barrel 
	rectfill(cannon_x - 2, cannon_y - 6, cannon_x + 2, cannon_y, 7)
	
	-- grid setup 
	local cols = 10
	local rows = 10
	local cell_size = 8
	local grid_w = cols * cell_size
	local grid_h = rows * cell_size
	local start_x = flr((128 - grid_w) / 2)
	local start_y = flr((128 - grid_h) / 2)

	-- get mouse position
	local mouse_x = stat(32)
	local mouse_y = stat(33)
	local hover_x = flr((mouse_x - start_x) / cell_size)
	local hover_y = flr((mouse_y - start_y) / cell_size)

	-- color palette mapping for points (just for visualizing right now)
	local val_colors = {11, 9, 8, 14}

	for x = 0, cols - 1 do 
		for y = 0, rows - 1 do 
			local px = start_x + (x * cell_size)
			local py = start_y + (y * cell_size)
			
			-- draw base grid square box
			rect(px, py, px + cell_size - 1, py + cell_size - 1, 5)
			
			-- if the cell has been draw top-right to bottom-left line in value color
			if revealed[x][y] then
				local val = grid[x][y]
				local col = val_colors[val + 1] 
				-- top-right (px + 7, py) to bottom-left (px, py + 7)
				line(px + cell_size - 1, py, px, py + cell_size - 1, col)
			end
			
			-- cell outline
			if x == hover_x and y == hover_y then
				rect(px, py, px + cell_size - 1, py + cell_size - 1, 6)
			end
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
