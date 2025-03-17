extends Node

@export var areaAtiva: Area2D
@export var areaAtaque: Area2D
@export var animacao: AnimationPlayer
@export var inimigo: CharacterBody2D
@export var tempo: float = 0.6
@export var dano: float = 5

var cootal_attack: float = 0.0
var in_attack: bool = false


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	cootal_attack += delta
	if cootal_attack >= tempo:
		in_attack = false
		ativarAtacar()
	if not in_attack:
		animacao.play("rum")
	pass

func  ativarAtacar() -> void:
	var corpos = areaAtiva.get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("player") or body.is_in_group("grupo player"):
			animacao.play("attack frente")
			in_attack = true
			cootal_attack = 0.0
		else:
			pass

func atacaPlayer():
	var corpos = areaAtaque.get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("grupo player") or body.is_in_group("player"):
			if body.has_method("tomarDano"):
				body.tomarDano(dano)
	pass
