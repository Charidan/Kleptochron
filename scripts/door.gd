extends StaticBody2D

export(String) var KEYCARD = "None"

var open = false
var moving = false
export(int) var SPEED
export(String) var DOOR_TYPE = "keycard"
const POS_LEFT_OPEN = Vector2(-25, 0)
const POS_LEFT_CLOSE = Vector2(-5, 0)
const POS_RIGHT_OPEN = Vector2(25, 0)
const POS_RIGHT_CLOSE = Vector2(5, 0)
var event_list = []
var LEFT_DOOR
var RIGHT_DOOR

func _ready():
	LEFT_DOOR = find_node("leftdoor")
	RIGHT_DOOR = find_node("rightdoor")
	
	# seed an initial event
	event_list.append({'type': 'close_end', 'time': 0, 'left_position' : self.POS_LEFT_CLOSE, 'right_position' : self.POS_RIGHT_CLOSE})

func _physics_process(delta):
	if moving:
		if open:
			moving = move_towards(LEFT_DOOR, POS_LEFT_OPEN, delta)
			move_towards(RIGHT_DOOR, POS_RIGHT_OPEN, delta)
			if !moving:
				event_list.append({'type': 'open_end', 'time': global.time, 'left_position' : self.POS_LEFT_OPEN, 'right_position' : self.POS_RIGHT_OPEN})
		else:
			moving = move_towards(LEFT_DOOR, POS_LEFT_CLOSE, delta)
			move_towards(RIGHT_DOOR, POS_RIGHT_CLOSE, delta)
			if !moving:
				event_list.append({'type': 'close_end', 'time': global.time, 'left_position' : self.POS_LEFT_CLOSE, 'right_position' : self.POS_RIGHT_CLOSE})

func move_towards(obj, dest, delta):
	var distance = (dest - obj.position)
	var momentum = (SPEED * delta)
	if distance.length() < momentum:
		obj.position = dest
		return false
	obj.position += distance.normalized() * momentum
	return true

func open():
	moving = true
	open = true
	event_list.append({'type': 'open_begin', 'time': global.time, 'left_position' : LEFT_DOOR.position, 'right_position' : RIGHT_DOOR.position})

func close():
	moving = true
	open = false
	event_list.append({'type': 'close_begin', 'time': global.time, 'left_position' : LEFT_DOOR.position, 'right_position' : RIGHT_DOOR.position})

func reset_to_events(events, prevtime):
	if events == null:
		return
	var early_event = events[0]
	var late_event = events[1]
	print(early_event)
	LEFT_DOOR.position = early_event['left_position']
	RIGHT_DOOR.position = early_event['right_position']
	if early_event['type'] == 'open_begin':
		move_towards(LEFT_DOOR, POS_LEFT_OPEN, global.time - early_event['time'])
		move_towards(RIGHT_DOOR, POS_RIGHT_OPEN, global.time - early_event['time'])
	elif early_event['type'] == 'close_begin':
		move_towards(LEFT_DOOR, POS_LEFT_CLOSE, global.time - early_event['time'])
		move_towards(RIGHT_DOOR, POS_RIGHT_CLOSE, global.time - early_event['time'])

func finalize_jump(t):
	global.wipe_future(self, t)