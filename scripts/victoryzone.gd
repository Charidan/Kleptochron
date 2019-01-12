extends Area2D

func _ready():
	self.connect("body_entered", self, "win")

func win(body):
	print("win")
	var dialog = global.win_dialog.instance()
	self.get_parent().find_node("CanvasLayer").add_child(dialog)
	dialog.popup_centered()
