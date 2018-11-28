extends KinematicBody2D

var speed = 3
var state = 'active'
var replay_index = null

var event_list = []

func _ready():
	event_list.append(['motion', global.time, {'position' : self.position, 'velocity' : Vector2(0,0), 'rotation' : Vector2(0,1)}])
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
			if event_list[0][0] != 'motion' or event_list[len(event_list) - 1][2]['velocity'] != velocity:
				event_list.append(['motion', global.time, {'position' : self.position, 'velocity' : velocity, 'rotation' : rotation}])
		elif event_list[len(event_list) - 1][0] != 'wait':
			event_list.append(['wait', global.time, {'position' : self.position, 'velocity' : velocity, 'rotation' : rotation}])
		#update position AFTER storing the event (if necessary)
		position += velocity
	elif self.state == 'replay':
		var event = event_list[replay_index]
		if event[0] == 'motion':
			# set velocity to go to (not past) next waypoint
			var target_pos = event_list[replay_index + 1][2]['position']
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
				print("replay player arrived at " + str(target_pos))
				replay_index += 1
				print("new event = " + str(event_list[replay_index]) + " with target = " + (str(event_list[replay_index + 1][2]['position']) if replay_index + 1 < len(event_list) else "null"))
		if event[0] == 'wait':
			# TODO consider making this a check of relative number of ticks waited instead of matching the global timer
			if event[1] <= global.time:
				replay_index += 1
		if event[0] == 'depart':
			self.hide()
		if event[0] == 'arrive':
			position = event[2]['position']
			rotation = event[2]['rotation']
			replay_index += 1
			self.show()

func reset_to_events(events):
	if events == null:
		return
	var early_event = events[0]
	print('player early_event: ' + str(early_event))
	if early_event[0] == 'arrive' and early_event[1] > global.time:
		self.hide()
		return
	if early_event[0] == 'depart' and early_event[1] < global.time:
		self.hide()
		return
	self.show()
	self.position = early_event[2]['position']
	if events[1] and early_event[1] != global.time:
		var late_event = events[1]
		print(late_event)
		rotation = early_event[2]['rotation']
		var time_ratio = float(global.time - early_event[1]) / float(late_event[1] - early_event[1])
		print("time_ratio = " + str(time_ratio) + " num = " + str(global.time - early_event[1]) + " den " + str(late_event[1] - early_event[1]))
		position = Vector2(lerp(position.x, late_event[2]['position'].x, time_ratio), lerp(position.y, late_event[2]['position'].y, time_ratio))
		print(position)

func finalize_jump(t):
	if state == 'replay':
		var event = global.find_adjacent_events(t, event_list)[0]
		if event:
			replay_index = self.event_list.find(event)+1