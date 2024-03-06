extends MultiplayerSynchronizer

##export to be able to add it to InputSynchronizer's sync propety list
@export var direction_y : int


func _ready() -> void:
	set_physics_process(is_multiplayer_authority())
	set_process_input(is_multiplayer_authority())


func _physics_process(delta: float) -> void:
	direction_y = Input.get_axis("up", "down")
