extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var parent = null
var space_state = null

var vision_queue = []

func _ready():
	parent = self.get_parent()
	space_state = get_world_2d().direct_space_state
	self.connect("body_entered", self, "_add_to_vision_queue")
	self.connect("body_exited",  self, "_remove_from_vision_queue")

func _add_to_vision_queue(body):
	if body is TileMap or body == parent or body == self:
		return
	print("guard ADDING TO vision_queue = " + str(body))
	vision_queue.append(body)

func _remove_from_vision_queue(body):
	print("guard REMOVING FROM vision_queue = " + str(body))
	vision_queue.erase(body)

func _physics_process(delta):
	#print("guard vision_queue = " + str(vision_queue))
	for body in vision_queue:
		var result = space_state.intersect_ray(parent.position, body.position, [parent, self])
		#print("guard has seen:\n" + str(result))
		if result != null and result.has('collider'):
			#print("collider = " + str(result['collider']))
			if result['collider'] == body:
				parent.see_entity(body)