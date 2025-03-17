extends Node2D

@export var area: Area2D
@export var player: CharacterBody2D
@export var dano: float = 3
@export var animacao: AnimationPlayer
@export var tempodeAtivacao: float = 30.0

var tempo2 = tempodeAtivacao

func _process(delta):
	var player_position = GameManager.player_position
	position = player_position
	tempodeAtivacao -= delta
	if tempodeAtivacao <= 0 and player.habilidade_ritual:
		tempodeAtivacao = tempo2
		ativarRitual()
	if tempodeAtivacao <= 0 and not player.habilidade_ritual:
		tempodeAtivacao += 10

func ativarRitual():
	animacao.play("pulso do ritual")
	pass

func danoRitual():
	var corpos = area.get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("grupo enemy"):
			player.danoRitual(dano, body)
