extends Control

signal host_button_pressed
signal join_button_pressed(address)

#written this way so that passing true means "on" (disabled = false)
func toggle_buttons(enable: bool) -> void:
	%HostButton.disabled = not enable
	%JoinButton.disabled = not enable


func _ready() -> void:
	if multiplayer.is_server():
		multiplayer.multiplayer_peer.close()
	
	toggle_buttons(true)


func _on_host_button_pressed() -> void:
	host_button_pressed.emit()
	toggle_buttons(false)


func _on_join_button_pressed() -> void:
	join_button_pressed.emit("localhost")
	toggle_buttons(false)


func _on_close_peer_button_pressed() -> void:
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		toggle_buttons(true)
