extends Node

var time = 600
var furthest_present = 600

func _physics_process(delta):
	time += 1
	if time > furthest_present:
		furthest_present = time
	if time % 100 == 0:
		print(time)

func reset_time():
	time = 600

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

func time_travel_back(delta, children):
	print(children)
	delta = int(delta)
	var prevtime = time
	time -= delta
	print("TIME TRAVEL from " + str(prevtime) + " to " + str(time))
	for child in children:
		if 'event_list' in child:
			var events = self.find_adjacent_events(time, child.event_list)
			child.reset_to_events(events)