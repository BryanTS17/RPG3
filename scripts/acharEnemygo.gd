extends Node

@export var personagem: CharacterBody2D
@export var areaProcurar: Area2D

@export var speed: float = 1

@onready var conta: Vector2

var menorDistancia = INF
var maisProximo = null

func _process(delta):
	var personagemDistancia: Vector2 = personagem.position
	var corpos = areaProcurar.get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("grupo enemy"):
			var positionEnemy: Vector2 = body.position
			var distancia = personagemDistancia.distance_to(positionEnemy)
			if distancia < menorDistancia:
				menorDistancia = distancia
				maisProximo = body
				
	if is_instance_valid(maisProximo):
		conta = (personagemDistancia - maisProximo.position).normalized()
		GameManager.conta_sequir_enemigo = (conta * -1)
		personagem.velocity = (conta * -1) * speed * 100
		personagem.move_and_slide()
	else:
		maisProximo = null
		menorDistancia = INF
