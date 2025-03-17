extends Node

@export var speed: float = 1.0
@export var nodeAtaqueEnemy: NodePath
# @export var player: CharacterBody2D
@onready var enemy: Enemy = preload('res://scripts/enemy.gd').new()
@onready var sprit: AnimatedSprite2D
@onready var conta: Vector2

var speedmax
var grupoPlayer: Array[CharacterBody2D]
var amigo_perto: CharacterBody2D = null
var amigo_proximo = INF
var conta_perto
var parents_position: Vector2
var ataqueEnemy

func _ready():
	if nodeAtaqueEnemy:
		ataqueEnemy = get_node(nodeAtaqueEnemy)
	speedmax = speed
	grupoPlayer = GameManager.grupo_player
	pass

func _physics_process(delta: float) -> void:
	if nodeAtaqueEnemy:
		if ataqueEnemy.in_attack:
			speed = speedmax / 2
		else:
			speed = speedmax
		
	var player_position = GameManager.player_position # player.position
	var parents = get_parent()
	parents_position = parents.position
	for amigo in grupoPlayer:
		if is_instance_valid(amigo):
			var amigo_position = amigo.position
			conta_perto = player_position.distance_to(amigo_position)
			if conta_perto < amigo_proximo:
				amigo_proximo = conta_perto
				amigo_perto = amigo
		else:
			amigo_perto = null
			amigo_proximo = INF
	if conta_perto:
		
		if is_instance_valid(amigo_perto):
			if conta_perto < parents_position.distance_to(player_position):
				conta = amigo_perto.position - parents_position
				conta = conta.normalized()
				GameManager.conta_sequir_jogador = conta
				parents.velocity = conta * speed * 100
				parents.move_and_slide()
				
			else:
				conta = player_position - parents_position
				conta = conta.normalized()
				GameManager.conta_sequir_jogador = conta
				parents.velocity = conta * speed * 100
				parents.move_and_slide()
			
		else:
			conta = player_position - parents_position
			conta = conta.normalized()
			GameManager.conta_sequir_jogador = conta
			parents.velocity = conta * speed * 100
			parents.move_and_slide()
			
	else:
			conta = player_position - parents_position
			conta = conta.normalized()
			GameManager.conta_sequir_jogador = conta
			parents.velocity = conta * speed * 100
			parents.move_and_slide()
		
	
	
	
	
	
	
	
	
	

