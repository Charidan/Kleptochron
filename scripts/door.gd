extends StaticBody2D

export(String) var PASSWORD

var open = false
var moving = false
export(int) var SPEED
const POS_LEFT_OPEN = Vector2(-10, 0)
const POS_LEFT_CLOSE = Vector2(-5, 0)
const POS_RIGHT_OPEN = Vector2(10, 0)
const POS_RIGHT_CLOSE = Vector2(5, 0)
var event_list = []
var time = 0

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	time = 0

func _physics_process(delta):
	time += 1
	if moving:
		if open:
			moving = move_towards(find_node('leftdoor'), POS_LEFT_OPEN, delta)
			move_towards(find_node('rightdoor'), POS_RIGHT_OPEN, delta)
			if !moving:
				event_list.append('open_end:' + str(global.time))
		else:
			moving = move_towards(find_node('leftdoor'), POS_LEFT_CLOSE, delta)
			move_towards(find_node('rightdoor'), POS_RIGHT_CLOSE, delta)
			if !moving:
				event_list.append('close_end:' + str(global.time))

func move_towards(obj, dest, delta):
	var distance = (dest - obj.position)
	var momentum = (SPEED * delta)
	if distance.length() < momentum:
		obj.position = dest
		return false
	obj.position += distance.normalized() * momentum
	return true

func open(signal_value):
	if signal_value == PASSWORD:
		moving = true
		open = true
		event_list.append('open_begin:' + str(global.time))

func close(signal_value):
	if signal_value == PASSWORD:
		moving = true
		open = false
		event_list.append('close_begin:' + str(global.time))

func toggle():
	moving = true
	open = !open
	if open:
		event_list.append('open_begin:' + str(global.time)) 
	else:
		event_list.append('close_begin:' + str(global.time))
	print(event_list) 