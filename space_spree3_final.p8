pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
 poke(0x5f2d,1)

 grid_size=10
 tile_size=8
 grid_x=24
 grid_y=32

 turns=10
 score=0

 empty=0
 debris=1
 dead=2
 alive=3

 game_state="intro"
 intro_page=1
 mouse_was_down=false

 init_board()
end

function init_board()
 board={}
 revealed={}

 for x=1,grid_size do
  board[x]={}
  revealed[x]={}

  for y=1,grid_size do
   board[x][y]=empty
   revealed[x][y]=false
  end
 end

 place_tiles(debris,15)
 place_tiles(dead,8)
 place_tiles(alive,5)

 turns=10
 score=0

 debris_found=0
 dead_found=0
 alive_found=0

 game_state="intro"
 intro_page=1
end

function place_tiles(tile_type,amount)
 local placed=0

 while placed<amount do
  local x=flr(rnd(grid_size))+1
  local y=flr(rnd(grid_size))+1

  if board[x][y]==empty then
   board[x][y]=tile_type
   placed+=1
  end
 end
end

function begin_game()
 start_scan()
end

function advance_intro()
 if intro_page<5 then
  intro_page+=1
 else
  begin_game()
 end
end

function go_back_intro()
 if intro_page>1 then
  intro_page-=1
 end
end

function start_scan()
 scan_timer=60
 game_state="scan"
 find_scan_area()
end

function find_scan_area()
 scan_x=flr(rnd(7))+1
 scan_y=flr(rnd(7))+1

 scan_debris=0
 scan_dead=0
 scan_alive=0

 for x=scan_x,scan_x+3 do
  for y=scan_y,scan_y+3 do
   local tile=board[x][y]

   if tile==debris then
    scan_debris+=1
   elseif tile==dead then
    scan_dead+=1
   elseif tile==alive then
    scan_alive+=1
   end
  end
 end
end

function _update()
 local mouse_down=(stat(34)&1)>0
 local clicked=mouse_down and not mouse_was_down

 mouse_was_down=mouse_down

 if game_state=="intro" then
  if btnp(4) or btnp(0) then
   go_back_intro()

  elseif btnp(5) or btnp(1) or clicked then
   advance_intro()
  end

 elseif game_state=="scan" then
  scan_timer-=1

  if scan_timer<=0 then
   game_state="playing"
  end

 elseif game_state=="playing" then
  if clicked then
   handle_mouse_click()
  end

 elseif game_state=="gameover" then
  if btnp(5) then
   init_board()
  end
 end
end

function handle_mouse_click()
 local mx=stat(32)
 local my=stat(33)

 local gx=flr((mx-grid_x)/tile_size)+1
 local gy=flr((my-grid_y)/tile_size)+1

 if gx>=1 and gx<=grid_size and
    gy>=1 and gy<=grid_size then

  if not revealed[gx][gy] then
   reveal_area(gx,gy)
  end
 end
end

function reveal_one(x,y)
 if x<1 or x>grid_size or
    y<1 or y>grid_size then
  return
 end

 if revealed[x][y] then
  return
 end

 revealed[x][y]=true

 local tile=board[x][y]

 if tile==debris then
  score+=10
  debris_found+=1

 elseif tile==dead then
  score+=30
  dead_found+=1

 elseif tile==alive then
  score-=30
  alive_found+=1
 end
end

function reveal_area(x,y)
 reveal_one(x,y)
 reveal_one(x,y-1)
 reveal_one(x,y+1)
 reveal_one(x-1,y)
 reveal_one(x+1,y)

 turns-=1

 if turns<=0 then
  game_state="gameover"
 else
  start_scan()
 end
end

-- hover preview for five tiles.
function draw_hover_preview()
 if game_state~="playing" then
  return
 end

 local mx=stat(32)
 local my=stat(33)

 local gx=flr((mx-grid_x)/tile_size)+1
 local gy=flr((my-grid_y)/tile_size)+1

 if gx<1 or gx>grid_size or
    gy<1 or gy>grid_size then
  return
 end

 if revealed[gx][gy] then
  return
 end

 highlight_tile(gx,gy)
 highlight_tile(gx,gy-1)
 highlight_tile(gx,gy+1)
 highlight_tile(gx-1,gy)
 highlight_tile(gx+1,gy)
end

function highlight_tile(x,y)
 if x<1 or x>grid_size or
    y<1 or y>grid_size then
  return
 end

 if revealed[x][y] then
  return
 end

 local px=grid_x+(x-1)*tile_size
 local py=grid_y+(y-1)*tile_size

 rect(
  px,py,
  px+tile_size-1,
  py+tile_size-1,
  12
 )

 pset(px+3,py+3,7)
 pset(px+4,py+4,7)
end

function _draw()
 cls(1)

 if game_state=="intro" then
  draw_intro()

 elseif game_state=="gameover" then
  draw_gameover()

 else
  draw_stars()
  draw_title()
  draw_radar()
  draw_grid()
  draw_hover_preview()
  draw_stats()

  if game_state=="scan" then
   draw_scan_effect()
  end
 end

 if game_state~="gameover" then
  draw_mouse()
 end
end

function draw_stars()
 for i=1,40 do
  local x=(i*37)%128
  local y=(i*53)%128
  pset(x,y,5)
 end
end

function draw_title()
 print("space spree",43,3,11)
 line(8,11,120,11,5)
end

-- intro screen

function draw_intro()
 draw_stars()
 draw_title()

 if intro_page==1 then
  draw_intro_page1()

 elseif intro_page==2 then
  draw_intro_page2()

 elseif intro_page==3 then
  draw_intro_page3()

 elseif intro_page==4 then
  draw_intro_page4()

 elseif intro_page==5 then
  draw_intro_page5()
 end

 print("page "..intro_page.."/5",48,110,6)

 if intro_page>1 then
  print("z: back",5,121,7)
 end

 if intro_page<5 then
  print("x: next",85,121,7)
 else
  print("x: start",85,121,10)
 end
end

function draw_intro_page1()
 print("welcome to the iasc,",8,19,7)
 print("operator!",8,27,7)

 print("your mission:",8,41,12)
 print("clear as much space",8,51,7)
 print("junk as possible with",8,59,7)
 print("limited cannon shots.",8,67,7)

 print("good luck, operator!",8,85,10)
end

function draw_intro_page2()
 print("how it works:",8,19,12)

 print("each shot collects",8,32,7)
 print("objects from the tile",8,40,7)
 print("you select and its",8,48,7)
 print("4 neighbouring tiles.",8,56,7)

 print("all 5 tiles become",8,72,7)
 print("unselectable after",8,80,7)
 print("your shot.",8,88,7)
end

function draw_intro_page3()
 print("sector scanning:",8,19,12)

 print("before each turn, you",8,32,7)
 print("will briefly scan a",8,40,7)
 print("4x4 area to get info",8,48,7)
 print("about hidden objects.",8,56,7)

 print("remember what you see",8,72,7)
 print("and choose your actions",8,80,7)
 print("wisely!",8,88,10)
end

function draw_intro_page4()
 print("your targets:",8,17,12)

 draw_dead_icon(9,31)
 print("dead satellite",25,31,9)
 print("collect them to make",8,41,7)
 print("room for new ones.",8,49,7)
 print("+30 ed each",8,57,9)

 draw_alive_icon(9,69)
 print("alive satellite",25,69,12)
 print("avoid collecting them!",8,79,7)
 print("-30 ed each",8,87,12)

 draw_debris_icon(9,99)
 print("space debris: +10 ed",25,99,6)
end

function draw_intro_page5()
 print("example board, with scanner",8,19,10)
 print("highlighting hidden objects",8,27,10)

 -- . empty  d debris  x dead  a alive
 local ex={
  ".......",
  ".d.x...",
  "...d..d",
  "..a....",
  "..d.x..",
  ".a.....",
  "..d...x"
 }

 local ox=36
 local oy=37
 local sx,sy=2,2
 local cd,cx,ca=0,0,0

 for y=1,7 do
  for x=1,7 do
   local px=ox+(x-1)*tile_size
   local py=oy+(y-1)*tile_size
   local inside=x>=sx and x<=sx+3
    and y>=sy and y<=sy+3

   if inside then
    local ch=sub(ex[y],x,x)
    local tile=empty

    if ch=="d" then
     tile=debris
     cd+=1
    elseif ch=="x" then
     tile=dead
     cx+=1
    elseif ch=="a" then
     tile=alive
     ca+=1
    end

    draw_tile(px,py,tile)
   else
    rectfill(px,py,px+tile_size-1,py+tile_size-1,5)
    rect(px,py,px+tile_size-1,py+tile_size-1,6)
   end
  end
 end

 local x1=ox+(sx-1)*tile_size
 local y1=oy+(sy-1)*tile_size
 local c=7
 if flr(t()*4)%2==0 then
  c=12
 end
 rect(x1-1,y1-1,x1+tile_size*4,y1+tile_size*4,c)

 print("deb: "..cd,5,98,6)
 print("dead: "..cx,45,98,9)
 print("alive: "..ca,91,98,12)
end

function draw_dead_icon(x,y)
 pset(x,y,9)
 pset(x+2,y,9)
 pset(x+1,y+1,9)
 pset(x,y+2,9)
 pset(x+2,y+2,9)
end

function draw_alive_icon(x,y)
 circfill(x+1,y+1,2,12)
 pset(x,y,7)
end

function draw_debris_icon(x,y)
 circfill(x+1,y+1,2,6)
 pset(x,y,7)
 pset(x+2,y,7)
end

-- radar

function draw_radar()
 print("sector scan",43,15,12)

 print("deb: "..scan_debris,5,24,6)
 print("dead: "..scan_dead,45,24,9)
 print("alive: "..scan_alive,91,24,12)
end

-- grid

function draw_grid()
 for x=1,grid_size do
  for y=1,grid_size do

   local px=grid_x+(x-1)*tile_size
   local py=grid_y+(y-1)*tile_size

   if revealed[x][y] then
    draw_tile(px,py,board[x][y])
   else
    rectfill(
     px,py,
     px+tile_size-1,
     py+tile_size-1,
     5
    )

    rect(
     px,py,
     px+tile_size-1,
     py+tile_size-1,
     6
    )
   end
  end
 end
end

function draw_tile(px,py,tile)
 rectfill(
  px,py,
  px+tile_size-1,
  py+tile_size-1,
  1
 )

 if tile==debris then
  circfill(px+4,py+4,2,6)
  pset(px+3,py+3,7)

 elseif tile==dead then
  pset(px+3,py+3,9)
  pset(px+5,py+3,9)
  pset(px+4,py+4,9)
  pset(px+3,py+5,9)
  pset(px+5,py+5,9)

 elseif tile==alive then
  circfill(px+4,py+4,2,12)
  pset(px+3,py+3,7)
 end

 rect(
  px,py,
  px+tile_size-1,
  py+tile_size-1,
  6
 )
end

-- scanner effect

function draw_scan_effect()
 local x1=grid_x+(scan_x-1)*tile_size
 local y1=grid_y+(scan_y-1)*tile_size
 local x2=x1+tile_size*4-1
 local y2=y1+tile_size*4-1

 local c=7

 if (flr(scan_timer/8)%2)==0 then
  c=12
 end

 rect(x1-1,y1-1,x2+1,y2+1,c)

 print("scan-",3,62,7)
 print("ning",3,70,7)
 print("area",3,78,7)
end

-- stats

function draw_stats()
 line(8,113,120,113,5)

 print("shots",12,118,7)
 print(turns,43,118,10)

 print("ed",75,118,7)
 print(score,91,118,10)
end

function draw_mouse()
 local mx=stat(32)
 local my=stat(33)

 line(mx-2,my,mx+2,my,7)
 line(mx,my-2,mx,my+2,7)
end

-- game over

function cprint(str,y,c)
 print(str,65-#str*2,y,c)
end

function draw_gameover()
 draw_title()

 cprint("mission complete",25,10)
 cprint("final funds:",40,7)
 cprint(score.." ed",49,10)

 cprint("space debris: "..debris_found,65,6)
 cprint("dead sats: "..dead_found,75,9)
 cprint("alive sats: "..alive_found,85,12)

 cprint("press x to restart",105,7)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700002620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006360000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700060006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
