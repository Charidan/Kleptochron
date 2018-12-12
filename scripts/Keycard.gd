extends Area2D
signal picked_up(signal_value)

export(String) var card_name
var event_list = []
export(String) var card_color
var sprite

func _ready():
	self.connect("body_entered", self, "_on_keycard_body_entered", [self])
	sprite = find_node("Keycard_Sprite")
	if card_color == "blue":
		sprite.modulate = Color(0, 0, 1)
	elif card_color == "green":
		sprite.modulate = Color(0, 1, 0)
	elif card_color == "red":
		sprite.modulate = Color(1, 0, 0)
	
	#seed initial event
	event_list.append(["spawn", 0, {"position": position}])

func _on_keycard_body_entered(body, origin):
	if self.is_visible() && body.get_name() == "Character":
		body.pickup(origin)
		self.hide()
		event_list.append(["pickup", global.time, {"position": position}])
		print("Picked up " + self.card_name)

func reset_to_events(events):
	if events == null:
		return
	var early_event = events[0]
	if early_event[0] == "spawn":
		self.show()
	if early_event[0] == "pickup":
		self.hide()
	print(early_event)

func finalize_jump(t):
	global.wipe_future(self, t)
