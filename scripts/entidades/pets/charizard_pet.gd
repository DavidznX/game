extends CharacterBody3D
var target : Node3D
const SPEED = 10.0
const turnSpeed = 0.3
var isTargetSet: bool = false
var lastTargetPosition: Vector3 = Vector3.ZERO
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
const JUMP_VELOCITY = 4.5
@onready var animation_player: AnimationPlayer = $blockbench_export/AnimationPlayer

func _ready() -> void:
	
	target = get_tree().get_first_node_in_group("player")
	isTargetSet = true
func _physics_process(delta: float) -> void:

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
	animation_player.play("animation_charizard_ground_idle")
	set_physics_process(false)
	
func _on_area_3d_body_exited(body: Node3D) -> void:
	animation_player.play("animation_charizard_air_fly")
	set_physics_process(true)
	
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
