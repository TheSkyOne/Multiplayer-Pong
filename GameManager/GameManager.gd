extends Node


@export var main_game_scene : PackedScene
@export var main_menu_scene : PackedScene

@onready var lobby_manager: LobbyManager = %LobbyManager as LobbyManager
@onready var main_menu: Control = %MainMenu

var main_game : Node2D


func _ready() -> void:
	lobby_manager.server_connections_filled.connect(_on_server_connections_filled)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	_connect_main_menu_signals()


func _on_server_connections_filled() -> void:
	_remove_main_menu.rpc()
	
	#server adds main game scene. MainGameMultiplayerSpawner takes care of adding it to clients
	main_game = main_game_scene.instantiate()
	add_child(main_game)


@rpc("call_local")
func _remove_main_menu() -> void:
	main_menu.queue_free()


func _on_main_menu_host_button_pressed() -> void:
	lobby_manager.host_game()


func _on_main_menu_join_button_pressed(address: String) -> void:
	lobby_manager.join_game(address)


func _on_peer_disconnected(_id) -> void:
	#in case a peer disconnected during the main game timer, unpause here because countdown finished wont be fired
	get_tree().paused = false 
	
	#only queue free if this is running on the server, when running on clients, multiplayerspawner despawns the scene
	if multiplayer.is_server():
		main_game.queue_free()
	
	main_menu = main_menu_scene.instantiate()
	add_child(main_menu)
	_connect_main_menu_signals()


func _connect_main_menu_signals() -> void:
	main_menu.host_button_pressed.connect(_on_main_menu_host_button_pressed)
	main_menu.join_button_pressed.connect(_on_main_menu_join_button_pressed)
