extends CharacterBody3D


const SPEED = 9.0
const JUMP_VELOCITY = 5.5
const run_mult = 2
var veloc:Vector3 = Vector3.ZERO
@onready var TREE:AnimationTree = $cam/glock/AnimationTree
@onready var ray:RayCast3D = $cam/glock/Armature/Skeleton3D/barrel/muzzle/ray

@onready var muzzle:Node3D = $cam/glock/Armature/Skeleton3D/barrel/muzzle
@onready var renderer:Node3D = $cam/glock/Armature/Skeleton3D/barrel/muzzle/shoot

@onready var SHOOTRENDER:Node3D = $cam/glock/Armature/Skeleton3D/barrel/muzzle/shoot


var cansh:bool = true
var firereate:float = 0.05
var reloading:bool = false
var reloading_empty:bool = false
var ballets:int = 20

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	veloc = veloc.lerp(Vector3.ZERO,delta * 5)
	if direction:
		veloc.x += clampf(direction.x * SPEED,-1,1) * (run_mult if Input.is_action_pressed("sprint") else 1)
		veloc.z += clampf(direction.z * SPEED,-1,1) * (run_mult if Input.is_action_pressed("sprint") else 1)
	
	if Input.is_action_just_pressed("reload") && !reloading_empty:
		reloading_empty = true
		ballets = 30
		await get_tree().create_timer(0.02).timeout
		reloading_empty = false

	if Input.is_action_just_pressed("shoot") && cansh && ballets > 0:
		TREE["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		ballets -= 1
		await get_tree().process_frame
		
		ray.force_raycast_update()
		if ray.is_colliding():
			var nd:Node3D = ray.get_collider()
			#print(nd)
			var POINT:MeshInstance3D = MeshInstance3D.new()
			POINT.mesh = BoxMesh.new()
			
			var map:Node = get_tree().root.get_node("map")
			map.add_child(POINT)
			POINT.global_position = ray.get_collision_point()
			POINT.scale = Vector3(0.3,0.3,0.3)
			
			
		cansh = false
		await get_tree().create_timer(firereate).timeout
		cansh = true
		
		SHOOTRENDER.visible = true
		await get_tree().create_timer(0.02).timeout
		SHOOTRENDER.visible = false
		#renderer.global_position = muzzle.global_position
		#renderer.position.y -= 50
		
	#print(veloc.z)
	veloc.y = velocity.y
	velocity = transform.basis * veloc
	move_and_slide()
	#print(TREE.tree_root.get_property_list())
	#print(Vector2(veloc.x, veloc.z) / SPEED)
	if (Vector2(veloc.x, veloc.z) / SPEED).length() > 0.5:
		TREE["parameters/jog/transition_request"] = "jog"
		if Input.is_action_pressed("sprint") && is_on_floor():
			TREE["parameters/jog/transition_request"] = "run"
	else:
		TREE["parameters/jog/transition_request"] = "idle"
	
	
