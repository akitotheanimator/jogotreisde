extends Node3D


@onready var parent:Node = $".."
var sens:float = 1
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * sens / 10
		rotation_degrees.x = clampf(rotation_degrees.x,-90,90)
		parent.rotation_degrees.y -= event.relative.x * sens / 10
