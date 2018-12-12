extends Area2D

signal door_open(signal_value)
signal door_close(signal_value)

var door


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	door = self.get_parent()
	self.connect("body_entered", self, "_on_detection_body_entered", [self])
	self.connect("body_exited", self, "_on_detection_body_exited", [self])
	self.connect('door_open', door, "open")
	self.connect('door_close', door, "close")

func _on_detection_body_entered(body, origin):
	if body.get_name() == "Character" and not door.open:
		if body.inventory.find(door.KEYCARD) != -1:
			emit_signal("door_open")

func _on_detection_body_exited(body, origin):
	if body.get_name() == "Character" and door.open:
		emit_signal("door_close")
