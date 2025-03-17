class_name amigo
extends CharacterBody2D

@export var vida: float = 40
@export var dead: PackedScene
@export var marker: Marker2D
@onready var marcarDanoScene: PackedScene = load("res://cenas/danoDomato.tscn")

func _process(delta):
	pass

func _ready():
	GameManager.grupo_player = [self]
	pass

func tomarDano(dano: int) -> void:
	vida -= dano
	
	modulate = Color.RED
	var tewn = create_tween()
	tewn.set_ease(Tween.EASE_IN)
	tewn.set_trans(Tween.TRANS_QUINT)
	tewn.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	var marcarDano = marcarDanoScene.instantiate()
	if marker:
		marcarDano.global_position = marker.global_position
	else:
		marcarDano.position = position
		
	marcarDano.tomouDano(dano)
	get_parent().add_child(marcarDano)
	
	if vida <= 0:
		die()
		pass
		
func die() -> void:
	if dead:
		var morreu = dead.instantiate()
		morreu.position = position
		get_parent().add_child(morreu)
	
	queue_free()
