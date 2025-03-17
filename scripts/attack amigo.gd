extends Node

@export var personagem: CharacterBody2D
@export var areaAtiva: Area2D
@export var areaAtaque: Area2D
@export var animacao: AnimationPlayer
@export var ataque: float
@export var tempo: float

var cootal_attack: float = 0.0
var in_ataque: bool = false

func _ready():
	cootal_attack = tempo
	if not in_ataque:
		animacao.play("rum")
		
func _process(delta):
	cootal_attack -= delta
	if cootal_attack <= 0:
		in_ataque = false
	else:
		in_ataque = true
		
	if not in_ataque:
		animacao.play("rum")
		
	procurarEnemy()
	
func procurarEnemy() -> void:
	var corpos = areaAtiva.get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("grupo enemy"):
			if cootal_attack <= 0:
				ativarAtaque()

func ativarAtaque() -> void:
	var corpos = areaAtiva.get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("grupo enemy"):
			animacao.play("attack frente amigo")
			in_ataque = true
			cootal_attack = tempo
		
func atacarEnemy() -> void:
	var corpos = areaAtaque.get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("grupo enemy"):
			body.tomar_dano(ataque)

