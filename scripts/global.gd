extends Node

var Character = preload("res://scenes/Character.tscn")

const UPP_DISTANCE = 600
var time = UPP_DISTANCE
var furthest_present = UPP_DISTANCE
var player = null
var player_ghost = null

func reset_time():
	time = UPP_DISTANCE
	furthest_present = time
	var slider = find_children()[0].get_parent().find_node("time_slider")
	if slider:
		print("found it")
		slider.set_time(time)

func _physics_process(delta):
	time += 1
	if time > furthest_present:
		furthest_present = time
	if time % 100 == 0:
		print(time)

func find_adjacent_events(t, event_list):
	#Does a binary search
	var start = 0
	var end = len(event_list) - 1
	#check for empty history
	if len(event_list) < 1:
		return null
	#if there is only one element, return it iff it is in the past
	if len(event_list) == 1:
		if event_list[0][1] <= t:
			return [event_list[0], null]
		else:
			return null
	#search for an event on the specified tick
	while true:
		#if end[1] is less than start
		#if end[1] is less than time, then start[1] is greater than time and we want [end, (end + 1)]
		#else start[1] is greater than time, and we want [(start - 1), start]
		#BUT in small arrays (or always for start) we might be going off the end, so check for bounds
		if end < start:
			if event_list[end][1] < t:
				if end + 1 < len(event_list):
					return [event_list[end], event_list[end + 1]]
				else:
					return [event_list[end], null]
			elif start < len(event_list):
				return [event_list[start - 1], event_list[start]]
			else:
				return [event_list[start], null]
		var m = int((start + end)/2)
		if event_list[m][1] < t:
			start = m + 1
		elif event_list[m][1] > t:
			end = m - 1
		else:
			return [event_list[m], event_list[m]]

#returns the top-level nodes of the level scene
func find_children():
	# the tree will have two children. children[0] is global
	# the most recently loaded top-level scene, children[len(children) - 1], *should* be the active level if we don't fuck up load order
	return get_tree().get_root().get_children()[len(get_tree().get_root().get_children()) - 1].get_children()

func time_travel(target_time, children):
	if time == target_time:
		return
	print(children)
	var prevtime = time
	time = target_time
	print("TIME TRAVEL from " + str(prevtime) + " to " + str(time))
	# if *returning* to the present
	if time == furthest_present and prevtime != furthest_present:
		if player_ghost:
			# give the old player a camera back
			var cam = player_ghost.find_node("Camera2D")
			player_ghost.remove_child(cam)
			player.add_child(cam)
			
			# delete the ghost
			player_ghost.queue_free()
			player_ghost = null
			
			# return control to the player
			player.state = 'active'
			player.event_list.pop_back()
	else:
		if not player_ghost:
			# set previous player to replay state preemptively
			player.state = 'replay'
			
			# spawn ghost player to sit in the present, add it to the node tree
			player_ghost = Character.instance()
			player.get_parent().add_child(player_ghost)
			player_ghost.position = player.position
			player_ghost.rotation = player.rotation
			
			# delete the old player's camera so only one camera exists in the scene
			var oldcam = player.find_node("Camera2D")
			if oldcam:
				oldcam.queue_free()
			
			# add a temporal departure to the player
			player.event_list.append(['depart', prevtime, {'position' : player_ghost.position, 'rotation' : player_ghost.rotation, 'velocity' : Vector2(0,0)}])
		# override the ghost's event list so its only event is its arrival
		player_ghost.event_list = [['arrive', time, {'position' : player_ghost.position, 'rotation' : player_ghost.rotation, 'velocity' : Vector2(0,0)}]]
	for child in children:
		if 'event_list' in child:
			var events = self.find_adjacent_events(time, child.event_list)
			child.reset_to_events(events)

func jump(children):
	player.state = 'replay'
	player = player_ghost
	player_ghost = null
	
	for child in children:
		if child.has_method('finalize_jump'):
			print("finalizing for object " + str(child))
			child.finalize_jump(time)
	print('jump done')

func wipe_future(entity, t):
	#remove all events after the specified time
	var wipe_index = entity.event_list.find(global.find_adjacent_events(t, entity.event_list)[0]) + 1
	while wipe_index < len(entity.event_list):
        entity.event_list.remove(wipe_index)