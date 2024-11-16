extends CharacterBody3D
@export var player_mesh := MeshInstance3D
var correndo:bool = false
var SPEED = 7.0
var velocidade_atual = SPEED
const JUMP_VELOCITY = 5

@export var vida_maxima: float = 300.0
@export var vida_atual = vida_maxima

var morte: bool = false
@onready var camera: Camera3D = $camera/horizontal/vertical/Spring_arm/Camera

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_mode = animation_tree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $blockbench_export/AnimationPlayer
@onready var life_number: Label = $HUD/Life_number

const LAPSO = preload("res://scene/attack/lapso.tscn")


func _ready() -> void:
	animation_tree.active = true
	life_number.text = str(vida_atual)



func _physics_process(delta: float) -> void:
	life_number.text = str(vida_atual)
	
	if morte:
		animation_mode.travel("death")
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	velocidade_atual = SPEED * 2 if Input.is_action_pressed("run") else SPEED

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	


	var horizontal_rotation = $camera/horizontal.global_transform.basis.get_euler().y
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP,horizontal_rotation)
	if direction:
		velocity.x = direction.x * velocidade_atual
		velocity.z = direction.z * velocidade_atual
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(-direction.x,-direction.z),delta*15)
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade_atual)
		velocity.z = move_toward(velocity.z, 0, velocidade_atual)

	move_and_slide()

	animation_tree.set("parameters/movement/blend_position" , input_dir.length() * velocidade_atual)

func  tomar_dano(dano):
	vida_atual -= dano
	if vida_atual <= 0:
		morte = true
		print("player morreu")


func cegar():
	pass
