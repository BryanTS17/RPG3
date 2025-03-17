extends CharacterBody2D

@export var vida: float = 40
@export var soldadosPorMinuto: float = 2
@export var dead: PackedScene
@export var marker: Marker2D
@export var areaAtivacao: Area2D
@onready var marcarDanoScene: PackedScene = load("res://cenas/danoDomato.tscn")
@export var soldado: PackedScene

@export var marker1: Marker2D

var array: Array[Marker2D] = []
var tempo_spawn: float
var spawn_timer: float = 0  # Contador para o tempo de spawn

func _ready() -> void:
	# Calcula o tempo entre os spawns corretamente
	tempo_spawn = 60.0 / soldadosPorMinuto
	spawn_timer = tempo_spawn  # Inicializa o contador
	
	# Adiciona os markers ao array
	array.append(marker1)

	# Spawna um soldado inicial se houver um marker válido
	for marca in array:
		if marca:
			var instanciaSoldado = soldado.instantiate()
			instanciaSoldado.position = marca.global_position
			get_parent().add_child(instanciaSoldado)

func _process(delta):
	# Controla o tempo de spawn
	spawn_timer -= delta
	var corpos = areaAtivacao.get_overlapping_bodies()
	for body in corpos:
		if body.is_in_group("player") or body.is_in_group("grupo player"):
			if spawn_timer <= 0:
				spawn_soldado()
				spawn_timer = tempo_spawn  # Reseta o tempo
	

func spawn_soldado():
	# Se houver um marker válido, cria um soldado
	if array.size() > 0:
		var marca = array[randi() % array.size()]  # Escolhe um marker aleatório
		if marca:
			var instanciaSoldado = soldado.instantiate()
			instanciaSoldado.position = marca.global_position
			get_parent().add_child(instanciaSoldado)

func tomar_dano(dano: int) -> void:
	vida -= dano
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	var marcarDano = marcarDanoScene.instantiate()
	if marker:
		marcarDano.global_position = marker.global_position
	else:
		marcarDano.position = position
		
	marcarDano.tomouDano(dano)
	get_parent().add_child(marcarDano)
	
	if vida <= 0:
		die()

func die() -> void:
	if dead:
		var morreu = dead.instantiate()
		morreu.position = position
		get_parent().add_child(morreu)
	
	queue_free()
