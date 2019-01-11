extends KinematicBody2D

var speed = 3
var state = 'active'
var replay_index = null
#Inventory may want to be a dictionary
var inventory = ['default_access']
var old_shape = null

var event_list = []

func _ready():
	event_list.append({'type':'wait', 'time':0, 'position' : self.position, 'velocity' : Vector2(0,0), 'rotation' : rotation})
	if global.player == null:
		global.player = self

func _physics_process(delta):
	if self.state == 'active':
		var velocity = Vector2()
		#Change the below to not use ui input at some point
		#TODO: Change this later
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			look_at(position - velocity)
			velocity = move_and_slide(velocity)
			# record a temporal event if our trajectory differs from the previous frame
			# this *could* get data intensive, but there's only one character
			if event_list[len(event_list) - 1]['type'] != 'motion' or event_list[len(event_list) - 1]['velocity'] != velocity:
				event_list.append({'type': 'motion', 'time': global.time, 'position': self.position, 'velocity': velocity, 'rotation': rotation})
		elif event_list[len(event_list) - 1]['type'] != 'wait':
			event_list.append({'type': 'wait', 'time': global.time, 'position' : self.position, 'velocity' : velocity, 'rotation' : rotation})
		#update position AFTER storing the event (if necessary)
		position += velocity
	elif self.state == 'replay':
		if replay_index >= len(event_list):
			return
		var event = event_list[replay_index]
		if event['type'] == 'pickup':
			replay_index += 1
			print(name)
			return _physics_process(delta)
		if event['type'] == 'motion':
			# set velocity to go to (not past) next waypoint
			var target_pos = event_list[replay_index + 1]['position']
			var distance = target_pos - self.position
			var velocity = distance.normalized() * speed
			if distance.length() < velocity.length():
				velocity = distance
			#set angle and check collisions
			if velocity.length() > 0:
				look_at(position - velocity)
				velocity = move_and_slide(velocity)
			#actually move
			position += velocity
			#check if we reached the target
			if (position - target_pos).length() < speed / 10.0:
				#print("replay player arrived at " + str(target_pos))
				replay_index += 1
				#print("new event = " + str(event_list[replay_index]) + " with target = " + (str(event_list[replay_index + 1][2]['position']) if replay_index + 1 < len(event_list) else "null"))
		if event['type'] == 'wait':
			# TODO consider making this a check of relative number of ticks waited instead of matching the global timer
			if event['time'] <= global.time:
				replay_index += 1
		if event['type'] == 'depart':
			self.disable()
		if event['type'] == 'arrive':
			position = event['position']
			rotation = event['rotation']
			replay_index += 1
			self.enable()

func disable():
	collision_mask = 0
	collision_layer = 0
	hide()
	
func enable():
	collision_mask = 1
	collision_layer = 1
	show()

func pickup(item):
	inventory.append(item.card_name)
	event_list.append({'type': "pickup", 'time': global.time, 'position': position, 'item': item.card_name, 'rotation': rotation, 'velocity': Vector2(0,0)})

func reset_to_events(events, prevtime):
	if state == 'active':
		return
	if events == null:
		self.disable()
		return
	var early_event = events[0]
	print('player early_event: ' + str(early_event))
	if early_event['type'] == 'arrive' and early_event['time'] > global.time:
		self.disable()
		return
	if early_event['type'] == 'depart' and early_event['time'] < global.time:
		self.disable()
		return
	self.enable()
	self.position = early_event['position']
	if events[1] and early_event['time'] != global.time:
		var late_event = events[1]
		print(late_event)
		rotation = early_event['rotation']
		var time_ratio = float(global.time - early_event['time']) / float(late_event['time'] - early_event['time'])
		print("time_ratio = " + str(time_ratio) + " num = " + str(global.time - early_event['time']) + " den " + str(late_event['time'] - early_event['time']))
		position = Vector2(lerp(position.x, late_event['position'].x, time_ratio), lerp(position.y, late_event['position'].y, time_ratio))
		print(position)

func finalize_jump(t):
	if state == 'replay':
		var event = global.find_adjacent_events(t, event_list)[0]
		if event:
			replay_index = self.event_list.find(event)+1
			var cursor = 0
			while cursor <= replay_index && cursor < len(self.event_list):
				var item_event = event_list[cursor]
				if item_event['type'] == 'pickup':
					inventory.append(item_event['item'])
				if item_event['type'] == 'drop':
					inventory.remove(inventory.find(item_event['item']))
				cursor += 1
		event_list.append({'type': 'depart', 'time': global.time, 'position' : position, 'rotation' : rotation, 'velocity' : Vector2(0,0)})
	elif state == 'active':
		# override event_list with our arrival
		event_list = [{'type': 'arrive', 'time': global.time, 'position' : position, 'rotation' : rotation, 'velocity' : Vector2(0,0)}]