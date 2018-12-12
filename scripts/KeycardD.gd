extends Area2D
signal picked_up(signal_value)

export(String) var card_name
var event_list = []
export(String) var card_color
var sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.connect("body_entered", self, "_on_keycard_body_entered", [self])
	sprite = find_node("Keycard_Sprite")
	if card_color == "blue":
		sprite.modulate = Color(0, 0, 1)
	elif card_color == "green":
		sprite.modulate = Color(0, 1, 0)
	elif card_color == "red":
		sprite.modulate = Color(1, 0, 0)

func _on_keycard_body_entered(body, origin):
	if body.get_name() == "Character":
		origin.pickup(body)

func pickup(body):
	#TODO check to see if they keycard has already been picked up
	self.hide()
	#add keycard to inventory
	body.inventory.append(self.card_name)
	print("Picked up " + self.card_name)

func reset_to_events(events):
	if events == null:
		return
	var early_event = events[0]
	#var late_event = null
	#if events[1]:
	#	late_event = events[1][0]
	print(early_event)
	