extends PanelContainer

onready var _scroll_container  = get_node("VBoxContainer/ChatContainer/ScrollContainer")
onready var _chat_list = get_node("VBoxContainer/ChatContainer/ScrollContainer/ChatList")
onready var _chat_input = get_node("VBoxContainer/ChatInput")

func _ready():
	set_process_input(true)
	_scroll_bottom()
	#Link window resize method listener 
	get_node("/root").connect("size_changed",self,"resize")
	
var _drag_starting_point

#Window resize callback
func resize():
	var pos = get_pos()
	_safe_set_pos(pos)


func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if Input.is_action_pressed("ui_cursor_selection"):
			#Start drag
			_drag_starting_point = event.pos
		else :
			#End drag
			_drag_starting_point = null
	if event.type == InputEvent.MOUSE_MOTION:
		if _drag_starting_point != null :
			#Drag
			var final_pos = Vector2(0,0)
			final_pos.x = event.global_x - _drag_starting_point.x
			final_pos.y = event.global_y - _drag_starting_point.y
			_safe_set_pos(final_pos)
			

#Adds a message to the chat
func add_message(channel, message):
	if message != null and message != "":
		var scene = load("res://TextEntry.tscn")
		var node = scene.instance()
		node.get_node("Label").set_text(message)
		_chat_list.add_child(node)
		_scroll_bottom()

#Scrolls the chat list to bottom
func _scroll_bottom():
	yield(get_tree(), "idle_frame")
	_scroll_container.set_v_scroll(65535)

func _on_ChatInput_text_entered( text ):
	_chat_input.set_text("")
	add_message(0, text)
	
#Perform a check on the final position: if the chat is outside the window will be moved inside.
func _safe_set_pos(pos):
	if pos.x > 0:
		if pos.x + get_size().x < OS.get_window_size().width:
			pass
		else :
			pos.x = OS.get_window_size().width - get_size().x
	else :
		pos = Vector2(0, pos.y)
	if pos.y > 0:
		if pos.y + get_size().y < OS.get_window_size().height:
			pass
		else :
			pos.y = OS.get_window_size().height - get_size().y
	else :
		pos = Vector2(pos.x, 0)
	set_pos(pos)
