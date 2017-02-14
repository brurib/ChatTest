extends TabContainer

var _drag_starting_point
var _resize_starting_point
var _add_tab_button
func _ready():
	#Link window resize method listener 
	get_node("/root").connect("size_changed",self,"relocate")
	_add_tab_button = get_node("+")
	

#Window resize callback
func relocate():
	var pos = get_pos()
	_safe_set_size(get_size(), get_pos(), Rect2(Vector2(0,0), OS.get_window_size()))
	_safe_set_pos(pos, get_size(), Rect2(Vector2(0,0), OS.get_window_size()))
	
func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			#Start drag
			if event.pos.x > get_size().width - 10 and event.pos.x < get_size().width:
				_resize_starting_point = event.pos
			else:
				_drag_starting_point = event.pos
		else :
			#End drag
			_drag_starting_point = null
			_resize_starting_point = null
	if event.type == InputEvent.MOUSE_MOTION:
		if _drag_starting_point != null :
			#Drag
			var final_pos = Vector2(0,0)
			final_pos.x = event.global_x - _drag_starting_point.x
			final_pos.y = event.global_y - _drag_starting_point.y
			_safe_set_pos(final_pos, get_size(), Rect2(Vector2(0,0), OS.get_window_size()))
		elif _resize_starting_point != null:
			_safe_set_size(event.pos, get_pos(), Rect2(Vector2(0,0), OS.get_window_size()))
			

	
#Perform a check on the final position: if the chat is outside the window will be moved inside.
func _safe_set_pos(pos, size, limit):
	if pos.x > limit.pos.x:
		if pos.x + size.x < limit.size.width:
			pass
		else :
			pos.x = limit.size.width - size.x
	else :
		pos = Vector2(limit.pos.x, pos.y)
	if pos.y > limit.pos.y:
		if pos.y + size.y < limit.size.height:
			pass
		else :
			pos.y = limit.size.height - size.y
	else :
		pos = Vector2(pos.x, limit.pos.y)
	set_pos(pos)

func _safe_set_size(pos, size, limit):
	if pos.x > limit.pos.x:
		if pos.x + size.x < limit.size.width:
			pass
		else :
			pos.x = limit.size.width - size.x
	else :
		pos = Vector2(limit.pos.x, pos.y)
	if pos.y > limit.pos.y:
		if pos.y + size.y < limit.size.height:
			pass
		else :
			pos.y = limit.size.height - size.y
	else :
		pos = Vector2(pos.x, limit.pos.y)
	set_size(pos)


func _on_TabContainer_tab_changed( tab ):
	if get_child(tab) == _add_tab_button:
		var scene = load("res://ChatWindow.tscn")
		var node = scene.instance()
		node.dismissable = true
		add_child(node)
		move_child(_add_tab_button, get_child_count() - 1)
		set_current_tab(get_child_count() - 2)
		set_tab_title(get_current_tab(), "ChatWindow" + String(node.get_instance_ID()))


func _on_Close_button_up():
	var position = get_current_tab()
	var toRemove = get_child(position);
	remove_child(toRemove)
	if position > 0:
		if get_child(position) == _add_tab_button:
			set_current_tab(position -1)
		else :
			set_current_tab(position)
	else:
		set_current_tab(0)
	toRemove.free()
