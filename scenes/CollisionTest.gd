extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#print(find_node("pressureplate"))
	#connect('body_enter', find_node("pressureplate"), "_on_pressureplate_body_enter")

func _on_pressureplate_body_entered(body):
	print("entered")
	if body.get_name() == "Character":
		find_node("pressureplate").toggle()
