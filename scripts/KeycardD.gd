extends Area2D
signal picked_up(signal_value)

export(String) var card_name
var event_list = []
export(String) var card_color

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _on_pressureplate_body_entered(body, origin):
	if body.get_name() == "Character":
		origin.pickup()

func pickup():
	pass

func reset_to_events(events):
	if events == null:
		return
	var early_event = events[0]
	#var late_event = null
	#if events[1]:
	#	late_event = events[1][0]
	print(early_event)
	