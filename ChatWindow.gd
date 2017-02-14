extends PanelContainer

export(bool) var dismissable = false


onready var _chat_view = get_node("VBoxContainer/ChatContainer/Label")
onready var _chat_input = get_node("VBoxContainer/ChatInput")
onready var _button_close = get_node("VBoxContainer/HBoxContainer/Close")

func _ready():
	if dismissable :
		_button_close.show()
		if !_button_close.is_connected("button_up", get_parent(), "_on_Close_button_up"):
			_button_close.connect("button_up", get_parent(), "_on_Close_button_up", Array(), 0)
	else :
		_button_close.hide()
	_chat_view.set_scroll_follow(true)
	_chat_view.set_use_bbcode(true)
	_scroll_bottom()

#Adds a message to the chat
func add_message(channel, message):
	if message != null and message != "":
		if _chat_view.get_text().length() <= 0:
			_chat_view.set_bbcode(message)
		else:
			_chat_view.set_bbcode(_chat_view.get_bbcode() + "\n" + message)
		_scroll_bottom()

#Scrolls the chat list to bottom
func _scroll_bottom():
	_chat_view.scroll_to_line(_chat_view.get_text().split("\n").size() - 1)

func _on_ChatInput_text_entered( text ):
	_chat_input.set_text("")
	add_message(0, text)

