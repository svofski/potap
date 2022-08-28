extends Node2D

onready var tilemap: TileMap = $TileMap
onready var potap1: AnimatedSprite = $Potap1
onready var potap2: AnimatedSprite = $Potap2
onready var exitsprite: AnimatedSprite = $Exit1
onready var evil1: AnimatedSprite = $Evil1
onready var evil2: AnimatedSprite = $Evil2

onready var playnik = $Play
#' данные уровней: 11 строк в каждом экране
#' 2 = кирпич
#' 1 = фон
#' 8 = замок
#' A = вишенка
#' B = яблочко
#' 3 = затычка для врага
#' 4 = [?]
#' 5 = секретный кирпич
#'

var leveldata_cursor: int = 0
var leveldata = [20,16,1,10,6,1,10,12,
	"2222222222222222","2111111111111112","2111111111111182","211AA11111131122",
	"2222222222511222","2111111111111222","21BB111113112222","2222222221142222",
	"2222211111222222","27111111111AABB2","2222222222222222",
	28,16,1,8,18,1,23,18,
	"2222222222222222","211111AA2BB11112","2112222228222212","221111AA2BB11112",
	"2711222222252122","221111AA2BB11122","2221122222221222","222211AA2B111222",
	"2222212222122222","2B111111111111B2","2222222222222222",
	8,18,1,4,10,1,24,10,
	"2111111111111112","2111111111111112","2111111BB1111112","2211111281111152",
	"2111111111111112","2311111331111132","2122222112222212","2C112117B11211C2",
	"2211211221121122","2111211111121112","2666266666626662",
	30,18,5,10,8,6,20,8,
	"2222222222222222","2111133111111132","2111113111111172","2182111111112222",
	"2131111331111112","2111121111211112","2111111CC1111112","2311111221111132",
	"2111112222111112","2BBBB222225BBBB2","2222222222222222",
	2,18,1,18,18,1,10,10,
	"2222222222222222","211122221CCCCC12","211111211CCCCCD2","2212212412222222",
	"2212111111221112","2712311111128112","2212666666621122","2212222222221112",
	"2211122112222112","2211111111111122","2222222222222222",
	24,20,2,14,8,2,22,14,
	"2222222222222222","2111111111111112","2111111111111712","2111111111111212",
	"23BCD11111111132","2122211111111112","2121111111111112","2128111111111112",
	"2111111111111112","2111111111111112","2666666666666662",
	12,16,4,14,2,5,20,2,
	"2222222222222222","2111111121111112","211122212AA11112","2111121125211112",
	"2211522111111112","21BB221112211182","212222211221DD12","21CC121112212212",
	"2222122112111112","2171121112111112","2222222662666662",
	16,14,8,12,6,7,22,18,
	"2222222222222222","2111111DDDDDDDD2","2112122222222282","2112111222111372",
	"2212211221111322","2111111211121112","2112221222311112","2111111221111512",
	"2221122222212212","2B311111111112E2","2222222222222222",
	30,16,6,14,10,5,16,10,
	"2222222222222222","2112111221111172","2111111111112222","2211121111211112",
	"2111111121111112","2112111111112112","2D111121121111D2","2111211111121112",
	"2181111221111212","2111111331111112","2666666666666662",
	2,20,6,14,8,5,16,8,
	"2222222222222222","2111111221111112","2112711111117512","2112811DD1118212",
	"2111111111111112","2111111111111112","2111112332111112","2332332112332332",
	"2112112112112112","2112112112112112","2662662662662662",
	4,4,7,14,17,6,14,14,
	"2222222222222222","2111221111711112","2121228171222112","2111112626211112",
	"2221212222212122","2221111121111122","2222212121212522","2222211111112522",
	"2222222181222522","2222222111222222","2222222222222222",
	20,14,4,16,4,4,26,4,
	"2222222222222222","2111111111111112","2111221111DD1112","2211122212222182",
	"2111121111111112","2112228212211112","2111125222221112","2221127DCC222112",
	"2111121111111112","2711221111111122","2266226626626622",
	28,20,7,18,18,7,22,18,
	"2222222222222222","21111111DDDDDDD2","2555551262626262","2AAAA11222222222",
	"2222212211111112","2BBB112112112212","2222122122122212","2CC1121121112212",
	"2221221221212212","27711112211122E2","2282222222822222",
	30,4,1,6,16,2,24,16,
	"2222222222222222","2111111111111112","2111111111111112","2111DDD11DDD1112",
	"2111282112851112","2111272112751112","2211212112121122","2111111111111112",
	"2131111331111312","21111D1111D11112","2666626666266662",
	0,14,5,8,6,6,22,14,
	"2222222222222222","2113333111111132","2111111111111112","2811111111311172",
	"2266266266266422","2222222222222522","2112221222122512","2111111111111112",
	"2111131111111312","2726662666266682","2222222222222222"]


#' 20x по 4 тайла квадратиками 2х2 (начинаем с 1)

var tiledata = [\
	# 1:фон, 2:кирпичи, 3:заглушка куда врагам не пройти, 4: [?]
	"20202020","77787877","60606060","7E808182",
	# 5:секретный кирпич, 6: огонь, 7: бусинка, 8: кирпич под бусинку
	"7D787877","75757676","2020726D","797A7877",
	# 9:успешный выход, 10:вишенка (счет), 11: яблочко (счет), 12: ананасик (счет)
	"60607460","206B6E6C","63646F65","66677068",
	# 13: виноградик, 14: перстень, 15: лимонолет, 16: лимонолет
	"2069716A","61207362","84858687","88898687",
	# 17: крыска, 18: крыска, 19: капелька, 20: капелька
	"8B8C8D8E","8F909192","93949596","9798999A"]
	
var macrotiles = [[0000]] # start with a dummy for 1-based indexing
	
var stick= [0,0,0,0,0] # left, right, up, down, trig
	
var rng: RandomNumberGenerator
	
enum { GM_TITLE, GM_ROUND, GM_EXITBONUS, GM_GAME_OVER, GM_WIN, GM_HISCORE, GM_DEATH }

enum { AN_EXIT_FLASH, AN_DEATHROLL }
	
var game_mode: int = GM_ROUND

var animations = [[0], [0]]
	
var score = 0
var score_step = 2000
var hiscore = 2000
var level_num = 1
var nt_time = 14
var remaining = 3
var cles = 0
var open_locks = 0
var potap_rl = 0
var potap_c3 = 3

var level = []
var screen = []
var timer: int 
var jump: int
var jump_timer: int # pw
var player_xy: Vector2
var k1k2: int = 0
var p1p2: int = 1

var exit_xy: Vector2
var level_foe = [[0,0,0], [0,0,0], [0,0,0]]
var foe = [[0,0,0], [0,0,0], [0,0,0]]

var state_frame_count = 0	# how many frames in this state

enum  {FS_DROPLET_RT = 1, FS_DROPLET_LT,
		   FS_RAT_UP, FS_RAT_DOWN,
		   FS_LEMON_RT, FS_LEMON_LT, FS_LEMON_UP, FS_LEMON_DN,
		   FS_SUN_APPROACH, FS_SUN_CHASE}
			
var foe_brain = [null,
	funcref(self, "brain_droplet_right"), funcref(self, "brain_droplet_left"),
	funcref(self, "brain_rat_up"), funcref(self, "brain_rat_down"),
	funcref(self, "brain_lemon_right"), funcref(self, "brain_lemon_left"),
	funcref(self, "brain_lemon_up"), funcref(self, "brain_lemon_down"),
	funcref(self, "brain_evil_approach"), funcref(self, "brain_evil_chase")]

func hide_sprites(also: bool = false):
	exitsprite.visible = false
	evil1.visible = false
	evil2.visible = false
	if also:
		potap1.visible = false
		potap2.visible = false

func wipe_foes():
	for f in foe:
		if f[1] > 0 and f[2] > 0:
			set_bigtile(f[1], f[2], 1)

func brain_droplet_right(state):
	var x = state[1]
	var y = state[2]
	x = x + 1
	var z = (screen[y][x + 1] != 0x20) || (screen[y + 1][x + 1] != 0x20)
	if z:
		state[0] = FS_DROPLET_LT
	else:
		set_bigtile(state[1], y, 1)
		state[1] = x
		set_bigtile(state[1], y, 20)
	
func brain_droplet_left(state):
	var x = state[1]
	var y = state[2]
	x = x - 1
	var z = (screen[y][x] != 0x20) || (screen[y + 1][x] != 0x20)
	if z:
		state[0] = FS_DROPLET_RT
	else:
		set_bigtile(state[1], y, 1)
		state[1] = x
		set_bigtile(state[1], y, 19)
	
func brain_rat_up(state):
	var x = state[1]
	var y = state[2]
	y = y - 1
	if (screen[y][x] != 0x20) || (screen[y][x + 1] != 0x20):
		state[0] = FS_RAT_DOWN
	else:
		set_bigtile(x, state[2], 1)
		state[2] = y
		set_bigtile(x, state[2], 16 + p1p2)
	
func brain_rat_down(state):
	var x = state[1]
	var y = state[2]
	y = y + 1
	if (screen[y + 1][x] != 0x20) || (screen[y + 1][x + 1] != 0x20):
		state[0] = FS_RAT_UP
	else:
		set_bigtile(x, state[2], 1)
		state[2] = y
		set_bigtile(x, state[2], 16 + p1p2)
	
func brain_lemon_right(state):
	var x = state[1]
	var y = state[2]
	x = x + 1
	if screen[y][x + 1] != 0x20 || screen[y + 1][x + 1] != 0x20:
		set_bigtile(state[1], state[2], 14 + p1p2)
		if player_xy.y > state[2]:
			state[0] = FS_LEMON_DN
		else:
			state[0] = FS_LEMON_UP
	else:
		set_bigtile(state[1], state[2], 1)
		state[1] = x
		set_bigtile(state[1], state[2], 14 + p1p2)

func brain_lemon_left(state):
	var x = state[1]
	var y = state[2]
	x = x - 1
	if screen[y][x] != 0x20 || screen[y + 1][x] != 0x20:
		set_bigtile(state[1], state[2], 14 + p1p2)
		if player_xy.y > state[2]:
			state[0] = FS_LEMON_DN
		else:
			state[0] = FS_LEMON_UP
	else:
		set_bigtile(state[1], state[2], 1)
		state[1] = x
		set_bigtile(state[1], state[2], 14 + p1p2)
	
func brain_lemon_up(state):
	var x = state[1]
	var y = state[2]
	y = y - 1
	if (screen[y][x] != 0x20) || (screen[y][x + 1] != 0x20):
		set_bigtile(state[1], state[2], 14 + p1p2)
		if player_xy.x > state[1]:
			state[0] = FS_LEMON_RT
		else:
			state[0] = FS_LEMON_LT
	else:
		set_bigtile(state[1], state[2], 1)
		state[2] = y
		set_bigtile(state[1], state[2], 14 + p1p2)

func brain_lemon_down(state):
	var x = state[1]
	var y = state[2]
	y = y + 1
	if (screen[y + 1][x] != 0x20) || (screen[y + 1][x + 1] != 0x20):
		set_bigtile(state[1], state[2], 14 + p1p2)
		if player_xy.x > state[1]:
			state[0] = FS_LEMON_RT
		else:
			state[0] = FS_LEMON_LT
	else:
		set_bigtile(state[1], state[2], 1)
		state[2] = y
		set_bigtile(state[1], state[2], 14 + p1p2)

# state 9
func brain_evil_approach(state):
	if game_mode != GM_DEATH:
		if state[1] < player_xy.x:
			state[1] += 1
		else:
			state[1] -= 1
		
		if state[2] < player_xy.y:
			state[2] += 1
		else:
			state[2] -= 1
			
		if state[2] < 23:
			draw_evil(state[1], state[2])
	
	if abs(player_xy.x - state[1]) < 2 and abs(player_xy.y - state[2]) < 2:
		set_game_mode(GM_DEATH)
	
func brain_evil_chase(state):
	pass

func code_to_subtile(c: int) -> Vector2:
	# cycle fire: originally tile 117
	if c == 117:
		c = 0xa0 + state_frame_count % 2
	return Vector2(c % 32, c / 32)

func init_screen():
	screen = []
	for y in 32:
		var row = []
		for x in 32:
			row.append(0x20)
		screen.append(row)

func cls():
	for y in screen.size():
		for x in screen[y].size():
			screen[y][x] = 0x20

func loadtiles():
	for tilestr in tiledata:
		var macrotile = [0,0,0,0]
		for n in 4:
			var index = ("0x" + tilestr.substr(n * 2, 2)).hex_to_int()
			macrotile[n] = index 
		macrotiles.append(macrotile)

func dbgprint_bigtile(x: int, y: int, index: int):
	var big = macrotiles[index]
	tilemap.set_cell(x, y, 		   0, false, false, false, code_to_subtile(big[0]))
	tilemap.set_cell(x + 1, y,     0, false, false, false, code_to_subtile(big[1]))
	tilemap.set_cell(x, y + 1,     0, false, false, false, code_to_subtile(big[2]))
	tilemap.set_cell(x + 1, y + 1, 0, false, false, false, code_to_subtile(big[2]))
	
func set_bigtile(x: int, y: int, index: int):
	var big = macrotiles[index]
	screen[y][x] = big[0]
	screen[y][x+1] = big[1]
	screen[y+1][x] = big[2]
	screen[y+1][x+1] = big[3]
	
func set_tile(x: int, y: int, code: int):
	screen[y][x] = code
	
func print_at(x: int, y: int, msg: String) -> void:
	for c in msg:
		screen[y][x] = ord(c)
		x += 1

func flush_screen():
	for y in screen.size():
		for x in screen[y].size():
			var subtile = screen[y][x]
			tilemap.set_cell(x, y, 0, false, false, false, code_to_subtile(subtile))

func loadlevel(index: int):
	var ofs: int = (index - 1) * 19
	
	exit_xy = Vector2(leveldata[ofs], leveldata[ofs+1])
	level_foe[1] = [leveldata[ofs+2], leveldata[ofs+3], leveldata[ofs+4]] # state, x, y
	level_foe[2] = [leveldata[ofs+5], leveldata[ofs+6], leveldata[ofs+7]] # state, x, y
			
	for y in 11:
		var levs = leveldata[ofs + 8 + y]
		for x in levs.length():
			var block = ("0x" + levs[x]).hex_to_int()
			set_bigtile(x * 2, y * 2, block)

const POTAP = [\
	"   ›››  ›› › ››››  ›› › ›››",
	"   ›› › ›› ›  ››   ›› › ›› ›",
	"   ›› › ›› ›  ››   ›› › ›› ›",
	"   ›››  ›› ›  ››   ›› › ›››",
	"   ››    ››   ››    ››  ››"]

func title_screen():
	hide_sprites(true)
	cls()	
	var y = 8
	for s in POTAP:
		var mu: String = s
		var q = mu.replace("›", char(155))
		print_at(0, y, q)
		y += 1
	
	print_at(8, 17, "PUSH SPACE KEY")
	print_at(2, 20, "MSX MAGAZINE & NEMOSOFT,1987")
	print_at(10, 2, "HI %5d0" % hiscore)

func restart_level():
	play("restart level")	
	loadlevel(level_num)
	timer = 0
	jump = 0
	nt_time = 14
	player_xy = Vector2(2, 1)
	foe = level_foe.duplicate(true)
	potap_rl = 0
	potap_c3 = 3
	cles = 0
	open_locks = 0	
	hide_sprites()
	printscore()
	printlives()
	printstats()

func process_foe(n: int):
	var braincell:FuncRef = foe_brain[foe[n][0]]
	braincell.call_func(foe[n])

#### STATS
func printstats():
	print_at(15, 22, "ROUND %2d" % level_num)
	var beads = ""
	for n in nt_time:
		beads = beads + char(155)
	print_at(0, 23, "  TIME " + beads )

func update_timebar():
	set_tile(21 - int(timer/20), 23, ord(' '))
	
func printscore():
	print_at(1, 22, "SCORE %5d0" % score)
	if score > score_step - 1:
		remaining = remaining + 1
		printlives(true)
		score_step += 2000
		
func printlives(chime: bool = false):
	print_at(25, 22, "      ")
	for x in min(6, remaining):
		set_tile(25 + x, 22, 0x8a)
	
func make_haste():
	nt_time = 7
	timer = 120
	printstats()
	var item = rng.randi_range(0, 3) + 10
	set_bigtile(foe[1][1], foe[1][2], item)
	set_bigtile(foe[2][1], foe[2][2], item)
	foe[1][1] = player_xy.x
	foe[1][2] = 35
	print_at(10, 0, " HURRY UP ! ")
	play("hurry up")
	foe[1][0] = 9
	foe[2][0] = 10

func process_time():
	timer = timer + 1
	if timer % 20 == 0:
		update_timebar()
	if timer > 280:
		make_haste()

func trigger() -> bool:
	return stick[4]

func stick_dir() -> int:
	# left right up down
	if stick[2] and stick[1]:
		return 2 # up-right
	if stick[2] and stick[0]:
		return 8
	if stick[2]:
		return 1
		
	if stick[3] and stick[0]:
		return 6 # down-left
	if stick[3] and stick[1]:
		return 4 # down-right
	if stick[3]:
		return 5
		
	if stick[0]:
		return 7
	if stick[1]:
		return 3
		
	return 0

func move_right() -> void:
	var x = player_xy.x + 1
	var y = player_xy.y
	potap_rl = 0
	if not (screen[y][x + 1] > 0x76 || screen[y+1][x + 1] > 0x76):
		player_xy.x = x
	k1k2 = (k1k2 + 1) % 2
	if k1k2:
		potap_c3 = 3
	else:
		potap_c3 = p1p2

func move_left() -> void:
	var x = player_xy.x - 1
	var y = player_xy.y
	potap_rl = 1
	if not (screen[y][x] > 0x76 || screen[y+1][x] > 0x76):
		player_xy.x = x
	k1k2 = (k1k2 + 1) % 2
	if k1k2:
		potap_c3 = 3
	else:
		potap_c3 = p1p2

func move_down() -> void:
	var item = screen[player_xy.y + 2][player_xy.x]
	match item:
		0x7e:	pickup_mystery()
		0x7d:	open_secret_brick()
		0x79:	put_key()

func handle_stick() -> void:
	potap_c3 = 3
	#print("stick_dir=", stick_dir())
	match stick_dir():
		0, 1, 2, 8:
			pass
		3, 4:
			move_right()
		5:
			move_down()
		6, 7:
			move_left()
		
func draw_potap(x: int = -1, y: int = -1, frame: int = -1) -> void:
	if x == -1:
		x = player_xy.x * 8
		y = player_xy.y * 8
	if frame == -1:
		potap1.frame = potap_c3 + 3 * potap_rl - 1
		potap2.frame = potap_c3 + 3 * potap_rl - 1
	else:
		potap1.frame = frame
		potap2.frame = frame
	potap1.position = Vector2(x, y)
	potap2.position = potap1.position
	potap1.visible = true
	potap2.visible = true

func draw_evil(x: int, y: int) -> void:
	evil1.visible = true
	evil2.visible = true
	evil1.position = Vector2(foe[1][1] * 8, foe[1][2] * 8)
	evil2.position = evil1.position

#func cycle_fire() -> void:
#	# tile 117 = fire
#	pass


func next_attempt():
	cles = 0
	remaining = remaining - 1

func exitbonus():
	if timer >= 280:
		return true
	for i in 20:
		timer += 1
		if timer % 20 == 0:
			update_timebar()
			play("bonus")
			score += 10
			printscore()

func test_collision() -> void:
	var collision = screen[player_xy.y][player_xy.x] > 0x74 or \
	   screen[player_xy.y][player_xy.x + 1] > 0x74 or \
	   screen[player_xy.y+1][player_xy.x] > 0x74 or \
	   screen[player_xy.y+1][player_xy.x+1] > 0x74
	if collision:
		set_game_mode(GM_DEATH)
		
func set_game_mode(newmode) -> void:
	print("game_mode: ", game_mode, " -> ", newmode)
	if newmode == GM_DEATH and game_mode != GM_DEATH:
		deathroll(true)
	elif newmode == GM_TITLE and game_mode != GM_TITLE:
		title_screen()
	game_mode = newmode
	state_frame_count = 0

func item_value(item: int) -> int:
	match item:
		1:	return 10
		2:	return 30
		3: 	return 50
		4:	return 80
	return 0

func wipe_item():
	set_bigtile(player_xy.x, player_xy.y, 1)

func pickup_fruit(item: int):
	score += item_value(item)
	printscore()
	wipe_item()
		
func pickup_key():
	score += 100
	cles += 1
	printscore()
	print_at(23 + 2 * cles, 23, "rm")
	wipe_item()

func pickup_ring():
	remaining += 1
	printlives(true)
	wipe_item()

func pickup_stuff() -> void:
	var tile = screen[player_xy.y + 1][player_xy.x]
	if tile < 0x6e:   
		return
	play("pickup")
	var item = tile - 0x6d
	match item:
		1, 2, 3, 4:
			pickup_fruit(item)
		5:
			pickup_key()
		6:
			pickup_ring()
		7:
			draw_potap(player_xy.x * 8, player_xy.y * 8, 7)
			set_game_mode(GM_EXITBONUS)

# [?]
func pickup_mystery() -> void:
	var item: int = 0
	while true:
		item = rng.randi_range(0, 4)
		if rng.randi_range(0, 1) == 1:
			continue
		break
	set_bigtile(player_xy.x, player_xy.y + 2, 10 + item)

func play(jingle: String):
	print("PLAY: ", jingle)
	match jingle:
		"pickup":
			#playnik.beepq(554.37, 0.1)   # "T255O5V10C+32V8D32"
			#playnik.beepq(587.33, 0.1)
			playnik.noteq(0, 85-12, 0.1, 8/15.0)
			playnik.noteq(0, 86-12, 0.1, 4/15.0)
		"restart level":
			# "S1M3000T150R2L16O5CDEFM20000G1."
			# "S1M2000T150R2L16O7CDEFM10000G1."
			for n in 6:
				playnik.noteq(0, 72 + n, 0.1 + int(n == 5))
				playnik.noteq(1, 72 + 24 + n, 0.1 + int(n == 5))
		"death":
			# "T250O5V11D16","T250O4V9D16"
			playnik.noteq(0, 74, 0.1, 11 * 1.0/15)
			playnik.noteq(1, 74-12, 0.1, 9 * 1.0/15)
		"insert key":
			#"S1M2000T150O7C32"
			playnik.noteq(0, 72+24, 0.1, 1.0)
		"opened exit":
			# "T150O3L4 V12E V6E V3E"
			playnik.noteq(1, 72-24+5, 0.1, 12/15.0)
			playnik.noteq(1, 72-24+5, 0.1, 6/15.0)
			playnik.noteq(1, 72-24+5, 0.1, 3/15.0)
		"bonus":
			# "O6V9C32","O5V7C32"
			playnik.noteq(0, 72+12, 0.05, 9/15.0)
			playnik.noteq(1, 72,    0.05, 7/15.0)
		"hurry up":
			# "M600T180S8O7C2","M600T180S8O5C2"
			var dur = 0.03
			for n in 8:
				playnik.noteq(0, 72, dur, 0.6)
				playnik.noteq(0, 72, dur, 0.0)
				playnik.noteq(1, 72 + 12 * 2, dur, 0.6)
				playnik.noteq(1, 72 + 12 * 2, dur, 0.0)

# start=true: init death roll
# start=false: animate death roll
# return true: finished, next game state
func deathroll(start) -> bool:
	if start:
		play("death")
		animate(AN_DEATHROLL, true)
	return not animations[AN_DEATHROLL][0]

func animate(what: int, start: bool):
	match what:
		AN_EXIT_FLASH:
			if start:
				animations[AN_EXIT_FLASH] = [1, 7]
				exitsprite.visible = true
				exitsprite.position = Vector2(exit_xy.x * 8, exit_xy.y * 8)
			else:
				var m = animations[AN_EXIT_FLASH][1]
				exitsprite.self_modulate = Color8(100, 100, 255, 255) * (0.8 + 0.2 * (m % 2))
				m -= 1
				if m == 0:
					animations[AN_EXIT_FLASH] = [0, 0]
				else:
					animations[AN_EXIT_FLASH][1] = m
		AN_DEATHROLL:
			if start:
				animations[AN_DEATHROLL] = [1, player_xy.x * 8, player_xy.y * 8 - 36, -4]
			else:
				var x = animations[AN_DEATHROLL][1]
				var y0 = animations[AN_DEATHROLL][2]
				var cnt = animations[AN_DEATHROLL][3]
				var y = y0 + cnt * cnt
				draw_potap(x, y, 7)
				if y >= 200:
					animations[AN_DEATHROLL] = [0, 0, 0, 0]
					#set_game_mode(GM_ROUND)
				else:
					animations[AN_DEATHROLL][3] += 1

func process_animations():
	for n in animations.size():
		if animations[n][0]:
			animate(n, false)

func open_secret_brick() -> void:
	set_bigtile(player_xy.x, player_xy.y + 2, 4)
	
func put_key() -> void:
	if cles > 0 and screen[player_xy.y + 2][player_xy.x] == 0x79:
		play("insert key")
		print_at(player_xy.x, player_xy.y + 2, "{|")
		cles -= 1
		open_locks += 1
	if open_locks >= floor(level_num / 10) + 1:
		set_bigtile(exit_xy.x, exit_xy.y, 9)
		play("opened exit")
		animate(AN_EXIT_FLASH, true)

func process_player():
	#print("trigger=", trigger(), " jump=", jump, "  jump_timer=", jump_timer)
	if trigger() and jump in [1,2]:
		match jump:
			1:	
				var y = player_xy.y - 1
				var x = player_xy.x
				if screen[y][x] > 0x76 or screen[y][x+1] > 0x76:
					jump = 0
					jump_timer = 0 # pw
				else:
					player_xy.y = y
					jump_timer = jump_timer + 1
					if jump_timer > 3:
						jump_timer = 0
						jump = 2
			2:  
				jump_timer = jump_timer + 1
				if jump_timer > 2:
					jump = 0
					jump_timer = 0
	else:
		var y = player_xy.y + 1
		var x = player_xy.x
		var z = (screen[y + 1][x] > 0x76) or (screen[y + 1][x + 1] > 0x76)
		if z:
			jump = 1
			jump_timer = 0
		else:
			jump = 0
			player_xy.y = y
	
	handle_stick()
	draw_potap()
	#cycle_fire()	
	test_collision()
	process_time()
	pickup_stuff()

# 4 = lemons, 7 = rats
func restart_game():
	level_num = 7
	score = 0
	score_step = 2000
	remaining = 3
	restart_level()
	
func win_screen():
	cls()
	hide_sprites()
	for y in 12:
		for x in 32:
			set_tile(x, y + 7 + 1, 0x9c)
	for x in 16:
		set_bigtile(x * 2, 20, 2)
	printscore()
	printlives()
	printstats()
	set_tile(16, 18, 0x9d)
	set_tile(16, 19, 0x9e)

	player_xy.x = 0
	player_xy.y = 18
	potap_rl = 0

func win_game():
	player_xy.x += 1
	potap_c3 = 1 + (int(player_xy.x) % 3)
	draw_potap(player_xy.x * 4, player_xy.y * 8)
	if player_xy.x >= 28:
		set_tile(16, 18, 0x9c)
		print_at(7, 4, "CONGRATULATION !")
		print_at(6, 6, "BONUS 50000 POINTS")
		score += 5000
		printscore()
		hide_sprites(true)
		set_game_mode(GM_HISCORE)

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

	loadtiles()
	init_screen()
	set_process(true)
	hide_sprites(true)
	set_game_mode(GM_TITLE)
	
	# hax to win screen
	if false:
		level_num = 15
		set_game_mode(GM_WIN)
		win_screen()
		win_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var elapsed = 0
var elapsed_anim = 0
const frametime = 0.2
const anim_frametime = 0.1

func _process(delta):
	elapsed_anim += delta
	if elapsed_anim >= anim_frametime:
		elapsed_anim -= anim_frametime
		process_animations()

	elapsed += delta
	if elapsed < frametime:
		return
	elapsed -= frametime

	state_frame_count += 1

	if state_frame_count % 2 == 0:
		p1p2 += 1
		if p1p2 == 3:
			p1p2 = 1
	
	match game_mode:
		GM_TITLE:
			if trigger():
				restart_game()
				set_game_mode(GM_ROUND)
		GM_ROUND:
			process_foe(1 + (state_frame_count % 2))
			process_player()
		GM_DEATH:
			if deathroll(false):
				hide_sprites(true)
				next_attempt()
				if remaining < 0:
					set_game_mode(GM_GAME_OVER)
				else:
					restart_level()
					set_game_mode(GM_ROUND)
			else:
				process_foe(1)
				process_foe(2)
		GM_EXITBONUS:
			if state_frame_count % 2 == 0 and exitbonus():
				level_num += 1
				if level_num > 15:
					set_game_mode(GM_WIN)
					win_screen()
				else:
					restart_level()
					set_game_mode(GM_ROUND)
		GM_WIN:
			win_game()

		GM_GAME_OVER:
			hide_sprites(true)
			print_at(10, 10, "GAME OVER")
			set_game_mode(GM_HISCORE)
			
		GM_HISCORE:
			if score > hiscore:
				hiscore = score
			if state_frame_count > 25:
				set_game_mode(GM_TITLE)

	flush_screen()

func _unhandled_key_input(event):
	match event.as_text():
		'A':	stick[0] = event.is_pressed()
		'D':	stick[1] = event.is_pressed()
		'W':	stick[2] = event.is_pressed()
		'S': 	stick[3] = event.is_pressed()
		'Space':stick[4] = event.is_pressed()
		
