extends Node3D

@export var sensi:= 0.2
@export var aceleracao := 10

const MIN := -300
const MAX := 250

var cam_hor := 0.0
var cam_ver := 0.0
@onready var camera: Camera3D = $horizontal/vertical/Spring_arm/Camera


	



func  _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		cam_hor -= event.relative.x * sensi
		cam_ver -= event.relative.y * sensi
	
	if Input.is_action_just_pressed('ui_cancel'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		
func _physics_process(delta: float) -> void:
	cam_ver = clamp(cam_ver, MIN, MAX)
	$horizontal.rotation_degrees.y = lerp($horizontal.rotation_degrees.y,cam_hor, aceleracao*delta)
	$horizontal/vertical.rotation_degrees.x = lerp($horizontal.rotation_degrees.x,cam_ver, aceleracao*delta)
		
