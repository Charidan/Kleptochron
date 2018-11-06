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
var LEFT_DOOR = find_node("leftdoor")
var RIGHT_DOOR = find_node("rightdoor")

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
			moving = move_towards(LEFT_DOOR, POS_LEFT_OPEN, delta)
			move_towards(RIGHT_DOOR, POS_RIGHT_OPEN, delta)
			if !moving:
				event_list.append(['open_end', global.time, {'left_position' : self.POS_LEFT_OPEN, 'right_position' : self.POS_RIGHT_OPEN}])
		else:
			moving = move_towards(LEFT_DOOR, POS_LEFT_CLOSE, delta)
			move_towards(RIGHT_DOOR, POS_RIGHT_CLOSE, delta)
			if !moving:
				event_list.append(['close_end', global.time, {'left_position' : self.POS_LEFT_CLOSE, 'right_position' : self.POS_RIGHT_CLOSE}])

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
		event_list.append(['open_begin', global.time, {'left_position' : LEFT_DOOR.position, 'right_position' : RIGHT_DOOR.position}])

func close(signal_value):
	if signal_value == PASSWORD:
		moving = true
		open = false
		event_list.append(['close_begin', global.time, {'left_position' : LEFT_DOOR.position, 'right_position' : RIGHT_DOOR.position}])

func reset_to_events(events):
	var early_event = events[0]
	var late_event = events[1]
	LEFT_DOOR.position = early_event[2]['left_position']
	RIGHT_DOOR.position = early_event[2]['right_position']
	if early_event == 'open_begin':
		move_towards(LEFT_DOOR, POS_LEFT_OPEN, global.time - early_event[1])
		move_towards(RIGHT_DOOR, POS_RIGHT_OPEN, global.time - early_event[1])
	elif early_event == 'close_begin':
		move_towards(LEFT_DOOR, POS_LEFT_CLOSE, global.time - early_event[1])
		move_towards(RIGHT_DOOR, POS_RIGHT_CLOSE, global.time - early_event[1])