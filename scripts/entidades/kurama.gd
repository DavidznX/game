extends CharacterBody3D
var morte: bool = false
var target : Node3D
const SPEED =17 
const turnSpeed = 0.3
var isTargetSet: bool = false
var lastTargetPosition: Vector3 = Vector3.ZERO
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
var vida_maxima = 100
var vida_atual = vida_maxima
var dano = 20
const JUMP_VELOCITY = 4.5
@onready var animation_player: AnimationPlayer = $blockbench_export/AnimationPlayer

@onready var collision_shape_3d: CollisionShape3D = $blockbench_export/Node/root/body3/neck2/head27/head25/Area3D/CollisionShape3D
func _ready() -> void:
	
	target = get_tree().get_first_node_in_group("player")
	isTargetSet = true
func _physics_process(delta: float) -> void:
	if morte:
		animation_player.play("death")
		set_physics_process(false)
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if target:
		va_ate_la(target.global_position)
		
	move_and_slide()

func va_ate_la(targetposition: Vector3):
	
	if not isTargetSet or lastTargetPosition != targetposition:
		navigation_agent_3d.set_target_position(targetposition)
		lastTargetPosition = targetposition
		isTargetSet = true
		
	var nextPathPosition = navigation_agent_3d.get_next_path_position()
	var currentEnemyPosition = global_position
	var newVelocity = (nextPathPosition - currentEnemyPosition).normalized()*SPEED
	var olhe_para = atan2(-velocity.x, -velocity.z)
	rotation.y = lerp_angle(rotation.y, olhe_para, turnSpeed)
	
	if navigation_agent_3d.is_navigation_finished():
		isTargetSet = false
		return
	
	if navigation_agent_3d.avoidance_enabled:
		navigation_agent_3d.set_velocity(newVelocity.move_toward(newVelocity, 0.25))
		
	else:
		velocity = newVelocity.move_toward(newVelocity, 0.25)
	

func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("player"):
		body.tomar_dano(dano)
		print("colidio")# Replace with function body.


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)


func  tomar_dano(dano):
	vida_atual -= dano
	if vida_atual <= 0:
		morte = true
		print("player morreu")
