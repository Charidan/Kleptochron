extends Node

var time = 0

func _physics_process(delta):
	time += 1
	print(time)

func reset_time():
	time = 0

func find_adjacent_events(t, event_list):
	#Does a binary search
	var start = 0
	var end = len(event_list) - 1
	if len(event_list) < 1:
		return null
	if len(event_list) == 1:
		return [event_list[0], null]
	while true:
		if end < start:
			return [event_list[end], event_list[start]]
		var m = int((start + end)/2)
		if event_list[m][1] < t:
			start = m + 1
		elif event_list[m][1] > t:
			end = m - 1
		else:
			return [event_list[m], event_list[m]]

func time_travel_back(delta, children):
	time -= delta
	for child in children:
		if 'event_list' in child:
			var events = self.find_adjacent_events(time, child.event_list)
			child.reset_to_events(events)