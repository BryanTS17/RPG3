extends Area2D

@export var player: CharacterBody2D
@export var animacao: AnimationPlayer
@export var dano: float = 25
@export var area: Area2D

func _process(delta):
	var corpos = get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("player"):
			body.habilitar_ritual()
			animacao.play("autoDestruição")

func danoAtivação():
	var corpos = area.get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("grupo enemy"):
			player.danoRitual(dano, body)

