extends KinematicBody2D

var speed = 5
var state = 'active'

var event_list = []

func _ready():
	event_list.append(['motion', global.time, {'position' : self.position, 'velocity' : Vector2(0,0), 'facing' : Vector2(0,1)}])
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
			# python ternary
			# var a = THEN if COND else ELSE
			var facing = rotation #velocity if velocity != Vector2(0,0) else event_list[len(event_list) - 1][2]['velocity']
			event_list.append(['motion', global.time, {'position' : self.position, 'velocity' : velocity, 'facing' : facing}])
		#update position AFTER storing the event (if necessary)
		position += velocity
	elif self.state == 'replay':
		var event = global.find_adjacent_events(global.time, self.event_list)
		if event[0][0] == 'motion':
			var velocity = event[1][2]['position'] - self.position
			velocity = velocity.normalized() * speed
			position += velocity
		if event[0][0] == 'depart':
			self.hide()
		if event[0][0] == 'arrive':
			position = event[0][2]['potition']
			rotation = event[0][2]['facing']
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
		rotation = early_event[2]['facing'] #look_at(self.position - early_event[2]['facing'])
		var time_ratio = float(global.time - early_event[1]) / float(late_event[1] - early_event[1])
		print("time_ratio = " + str(time_ratio) + " num = " + str(global.time - early_event[1]) + " den " + str(late_event[1] - early_event[1]))
		position = Vector2(lerp(position.x, late_event[2]['position'].x, time_ratio), lerp(position.y, late_event[2]['position'].y, time_ratio))
		print(position)