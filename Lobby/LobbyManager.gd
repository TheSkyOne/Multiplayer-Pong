class_name LobbyManager extends Node

const PORT := 56000
const DEFAULT_SERVER_IP := "localhost"
const MAX_CONNECTIONS := 2

signal server_connections_filled

#key:value = peer_id:score
var players := {}
var peer := ENetMultiplayerPeer.new()

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func host_game() -> void:
	var err := peer.create_server(PORT, MAX_CONNECTIONS)
	if err != OK:
		print("couldnt create server, error %s" %error_string(err))
		return
		
	multiplayer.multiplayer_peer = peer
	print("created server")
	_register_player(peer.get_unique_id())


func join_game(address: String) -> void:
	if address.is_empty():
		address = DEFAULT_SERVER_IP
		
	var err := peer.create_client(address, PORT)
	if err != OK:
		print("couldnt create client, error %s" %error_string(err))
		return
	
	multiplayer.multiplayer_peer = peer
	print("created client")
	_register_player(peer.get_unique_id())


func _on_peer_connected(id: int) -> void:
	var this_peer_id := multiplayer.get_unique_id()
	_register_player(id)
	print("peer id %d connected with peer id %d" %[this_peer_id, id])
	if multiplayer.is_server():
		_check_filled()


func _on_peer_disconnected(id: int) -> void:
	_deregister_player(id)
	print("peer id %d disconnected" %id)


func _register_player(id: int) -> void:
	if not players.has(id):
		players[id] = 0


func _deregister_player(id: int) -> void:
	if players.has(id):
		players.erase(id)


func _check_filled() -> void:
	#subtracting one to account for server which isnt "connected" to itself
	if multiplayer.get_peers().size() == MAX_CONNECTIONS - 1:
		multiplayer.multiplayer_peer.refuse_new_connections = true
		Globals.players = players #make the players info accessable everywhere
		server_connections_filled.emit()

