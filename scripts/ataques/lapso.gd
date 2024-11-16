extends Area3D
var dano = 20
@export var speed: float = 100.0  # Velocidade configurável
@export var direction: Vector3 = Vector3.FORWARD  # Direção configurável
var velocity: Vector3  # Velocidade calculada com base na direção e velocidade

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass  # Exemplo de limite


func _on_body_entered(body: CharacterBody3D) -> void:
	body.tomar_dano(dano)
