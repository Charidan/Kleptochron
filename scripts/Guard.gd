extends KinematicBody2D

var speed_patrol = 2
var speed_alert  = 3
var state = 'patrol'
var delay = 0

var event_list = []

export(Array, Vector2) var patrol_path = []
var dest_index = null

# for remembering where we were when a time scan started
var origin_pos = null
var origin_time

func _ready():
	event_list.append({'type':'wait', 'time':0, 'state': 'patrol', 'position' : self.position, 'velocity' : Vector2(0,0), 'rotation' : rotation})

func _physics_process(delta):
	if state == 'patrol':
		if dest_index == null:
			if patrol_path == null or len(patrol_path) == 0:
				return
			dest_index = 0
		if delay > 0:
			delay -= 1
			return
		var dest_point = patrol_path[dest_index]
		# set velocity to go to (not past) next waypoint
		var distance = dest_point - self.position
		var velocity = distance.normalized() * speed_patrol
		if distance.length() < velocity.length():
			velocity = distance
		#set angle and check collisions
		if velocity.length() > 0:
			look_at(position - velocity)
			velocity = move_and_slide(velocity)
		#actually move
		position += velocity
		#check if we reached the target
		if (position - dest_point).length() < speed_patrol / 10.0:
			event_list.append({'type':'patrol_point', 'time':global.time, 'state': self.state, 'position' : self.position, 'velocity' : velocity, 'rotation' : rotation})
			dest_index += 1
			if dest_index >= len(patrol_path):
				dest_index = 0
			delay = 60

func see_entity(body):
	if body.get_filename() == global.CHARACTER_FILEPATH:
		#spotted a player character
		var dialog = global.gg_dialog.instance()
		self.get_parent().find_node("CanvasLayer").add_child(dialog)
		print("showing popup = " + str(dialog))
		dialog.popup_centered()
		get_tree().paused = true

func disable():
	collision_mask = 0
	collision_layer = 0
	hide()
	
func enable():
	collision_mask = 1
	collision_layer = 1
	show()

func make_anchor(anchor_time):
	event_list.append({'type':'anchor', 'time': anchor_time, 'state': self.state, 'position' : self.position, 'velocity' : Vector2(0,0), 'rotation' : rotation})

func reset_to_events(events, prevtime):
	if events == null:
		self.disable()
		return
	if origin_pos == null:
		origin_pos = position
		origin_time = prevtime
	var early_event = events[0]
	#print('guard early_event: ' + str(early_event))
	#guards cannot currently arrive or depart, but they may become time-travel enabled later
	if early_event['type'] == 'arrive' and early_event['time'] > global.time:
		self.disable()
		return
	if early_event['type'] == 'depart' and early_event['time'] < global.time:
		self.disable()
		return
	self.enable()
	self.position = early_event['position']
	var late_pos = null
	var late_time = null
	if events[1] and early_event['time'] != global.time:
		var late_event = events[1]
		#print(late_event)
		rotation = early_event['rotation']
		state = early_event['state']
		late_pos = late_event['position']
		late_time = late_event['time']
	else:
		late_pos = origin_pos
		late_time = origin_time
	if late_time != early_event['time']:
		var time_ratio = float(global.time - early_event['time']) / float(late_time - early_event['time'])
		#print("time_ratio = " + str(time_ratio) + " num = " + str(global.time - early_event['time']) + " den " + str(late_event['time'] - early_event['time']))
		position = Vector2(lerp(position.x, late_pos.x, time_ratio), lerp(position.y, late_pos.y, time_ratio))
		#print(position)

func finalize_jump(t):
	global.wipe_future(self, t)
	origin_pos = null
	origin_time = null