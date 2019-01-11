extends AcceptDialog

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready(): 
	self.connect('confirmed', self, "restart")

func restart():
	# Remove the current level
	var root = get_tree().get_root()
	var level = root.get_children()[len(get_tree().get_root().get_children()) - 1]
	root.remove_child(level)
	level.call_deferred("free")
	
	global.reset()
	
	root.get_tree().change_scene_to(load("res://scenes/SampleLevel.tscn"))
	
	root.get_tree().paused = false
	queue_free()