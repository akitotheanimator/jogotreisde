extends Skeleton3D


@onready var pl:CharacterBody3D = $"../../../.."

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	rotation_degrees.x += pl.get_real_velocity().y * delta * 7
	position.x += Input.get_axis("a","d") * delta / 9
	position.y -= Input.get_axis("w","s") * delta / 9
	
	
	position.z -= pl.get_real_velocity().y * delta / 60
	
	
	rotation_degrees = rotation_degrees.lerp(Vector3.ZERO, delta * 7)
	position = position.lerp(Vector3.ZERO, delta * 5)
	pass
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y / 15
		rotation_degrees.y -= event.relative.x / 15
	
