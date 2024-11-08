extends CharacterBody3D
@export var player_mesh := MeshInstance3D
var correndo:bool = false
var SPEED = 7.0
var velocidade_atual = SPEED
const JUMP_VELOCITY = 5
@onready var mao_direita: Node3D = $mao_direita

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_mode = animation_tree.get("parameters/playback")


func _ready() -> void:
	animation_tree.active = true


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("run") and is_on_floor():
		velocidade_atual = SPEED * 1.5
		correndo = true
	if Input.is_action_just_released("run") and is_on_floor():
		velocidade_atual = SPEED
		correndo = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal_rotation = $camera/horizontal.global_transform.basis.get_euler().y
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP,horizontal_rotation)
	if direction:
		velocity.x = direction.x * velocidade_atual
		velocity.z = direction.z * velocidade_atual
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(-direction.x,-direction.z),delta*15)
	
	if direction.length():
		animation_tree.set("parameters/idle/blend_position",direction)
		animation_tree.set("parameters/run/blend_position",direction)
		animation_tree.set("parameters/walking/blend_position",direction)
		if correndo:
			animation_mode.travel("run")	
		else:
			animation_mode.travel("walking")
		
			
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade_atual)
		velocity.z = move_toward(velocity.z, 0, velocidade_atual)
		animation_mode.travel("idle")
	
	
 
	move_and_slide()
