extends Node3D
@export var dano: float = 200.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	animation_player.play("explosao")
	if  body.is_in_group('player'):
		body.tomar_dano(dano)
	if body.is_in_group('enemy'):
		body.tomar_dano(dano)
	print("colidio")
