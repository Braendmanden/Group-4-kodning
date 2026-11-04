pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function randomize_grid() -- Fills every cell in the 10x10 grid with a random number from 0 to 3
	for x = 0, 9 do
		for y = 0, 9 do
			grid[x][y] = flr(rnd(4))
		end
	end
end

function _init() -- Initializes the grid and revealed 10x10 tables with default values (0 and false)
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
	
	randomize_grid() --runs the randomize grid logic 

	poke(0x5f2d, 1)
	cannon_x = 64
	cannon_y = 115
	timer = 3000
	true_timer = 0
	point_counter = 0
	prev_mouse_down = false
	nets_left = 5

cols = 10 --centers the grid, basically it makes the position of the grid dependant on the amount of cols and the cell size
rows = 10
cell_size = 8
grid_w = cols * cell_size 
grid_h = rows * cell_size
start_x = flr((128 - grid_w) / 2) 
start_y = flr((128 - grid_h) / 2)
end

val_colors = {11, 9, 8, 14} --maps grid values to colours for testing, pico8 is weird dont ask why theres 4 values instead of 3

function _update()
	if (timer > 0) then -- timer countdown logic
		timer = timer - 1
		true_timer = flr(timer / 30)
		
		-- mouse controls
		mouse_x = stat(32) --stat 32 and stat 33 hold mouse position value, i assign those values to variables named mouseX and Y (cant be in init because of update reqs)
		mouse_y = stat(33)
		cannon_x = mid(10, mouse_x, 117) --mid clamps the cannons side to side movement so it doesnt go out of screen
		
		hover_x = flr((mouse_x - start_x) / cell_size) -- converts pixel position x and y to grid positions. HoverX and HoverY 
		hover_y = flr((mouse_y - start_y) / cell_size)
		
		
		local mouse_down = (stat(34) > 0) --stat34 checks for m1 clicks. Mouse_down is a variable for when the click goes down
		local clicked = (mouse_down and not prev_mouse_down) or btnp(4) --clicked happens when either mouse down or btnp4
		prev_mouse_down = mouse_down
		
		if clicked then
			if hover_x >= 0 and hover_x <= 9 and hover_y >= 0 and hover_y <= 9 then --only proceeds with the rest of this block if hoverx and y is actually within parameters
				
				if not revealed[hover_x][hover_y] then 
				if nets_left > 0 then -- only proceed if revealed for that specific point in the 2d array is set to false
					revealed[hover_x][hover_y] = true --set revealed to true
					point_counter = point_counter + grid[hover_x][hover_y] -- add points
					nets_left = nets_left-1
				


				
				end
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
	print("Nets left: "..nets_left, 52, 120, 10)
	
	print("space spree:", 40, 10, 12) --title card

	--cannon body 
	rectfill(cannon_x - 8, cannon_y, cannon_x + 8, cannon_y + 8, 12)

	--cannon barrel 
	rectfill(cannon_x - 2, cannon_y - 6, cannon_x + 2, cannon_y, 7)

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
