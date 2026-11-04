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
	tilesize = 8
	offset_x = 24
	offset_y = 20
	border_col = 9
	d_sat_point = 3
	debris_poimt = 1
	a_sat_point = -3

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
	mx = stat(32)
	my = stat(33)

	if (timer > 0) then
		timer = timer - 1
		true_timer = flr(timer / 30)

		cannon_x = mid(10, mx, 117)

		local hover_x = flr((mx - offset_x) / tilesize)
		local hover_y = flr((my - offset_y) / tilesize)

		local mouse_down = (stat(34) > 0)
		local clicked = (mouse_down and not prev_mouse_down) or btnp(4)
		prev_mouse_down = mouse_down

		if clicked then
			if hover_x >= 0 and hover_x <= 9 and hover_y >= 0 and hover_y <= 9 then
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
	spr(1, 4, 54)
	spr(1, 4, 44)
	spr(1, 4, 34)
	spr(1, 116, 64)
	spr(1, 116, 54)
	spr(1, 116, 44)
	spr(1, 116, 34)

	-- ui text
	print("timer: "..true_timer, 1, 1, 10)
	print("points: "..point_counter, 82, 1, 10)
	print("space spree:", 40, 10, 12)

	-- cannon body 
	rectfill(cannon_x - 8, cannon_y, cannon_x + 8, cannon_y + 8, 12)

	-- cannon barrel 
	rectfill(cannon_x - 2, cannon_y - 6, cannon_x + 2, cannon_y, 7)

	local hover_x = flr((mx - offset_x) / tilesize)
	local hover_y = flr((my - offset_y) / tilesize)
	local val_colors = {11, 9, 8, 14}

	for x = 0, 9 do 
		for y = 0, 9 do 
			local px = offset_x + (x * tilesize)
			local py = offset_y + (y * tilesize)

			rect(px, py, px + tilesize - 1, py + tilesize - 1, border_col)

			if revealed[x][y] then
				local val = grid[x][y]
				local col = val_colors[val + 1] 
				line(px + tilesize - 1, py, px, py + tilesize - 1, col)
			end

			if x == hover_x and y == hover_y then
				rect(px, py, px + tilesize - 1, py + tilesize - 1, 6)
			end
		end
	end

	-- custom cursor sprite
	spr(2, mx, my)
end


__gfx__
00000000000000000000000006dd000006dd00000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000100000d6d00000d6d00000665500066666666000000000000000000000000000000000000000000000000000000000000000000000000
0000000006606600001710000dd130000dd180000655855066666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000002620000017710000037300000878000555565066666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000006b600000177710000031dd000081dd0566b66066666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000006060000017777100000d6d00000d6d0566656066666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000060006000017711000000dd600000dd60055565066666666000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000001171000000000000000000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000
