extends CharacterBody2D

@export var vida: float = 40
@export var soldadosPorMinuto: float = 2
@export var dead: PackedScene
@export var marker: Marker2D
@onready var marcarDanoScene: PackedScene = load("res://cenas/danoDomato.tscn")
@export var soldado: PackedScene

@export var marker1: Marker2D
@export var marker2: Marker2D
@export var marker3: Marker2D
@export var marker4: Marker2D

var array: Array[Marker2D] = []
var tempo_spawn: float  # Tempo entre cada spawn de soldado
var spawn_timer: float = 0  # Contador para spawn

func _ready() -> void:
	# Calcula o tempo de spawn correto
	tempo_spawn = 60.0 / soldadosPorMinuto
	spawn_timer = tempo_spawn  # Inicia o timer com esse valor

	# Adiciona os markers ao array
	array.append(marker1)
	array.append(marker2)
	array.append(marker3)
	array.append(marker4)

	# Spawna soldados iniciais
	for marca in array:
		if marca:  # Verifica se o marker não é nulo
			var instanciaSoldado = soldado.instantiate()
			instanciaSoldado.position = marca.global_position
			get_parent().add_child(instanciaSoldado)

func _process(delta):
	# Atualiza o timer
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_soldado()
		spawn_timer = tempo_spawn  # Reseta o timer

func spawn_soldado():
	# Escolhe um marcador aleatório para spawnar um soldado
	if array.size() > 0:
		var marca = array[randi() % array.size()]
		if marca:
			var instanciaSoldado = soldado.instantiate()
			instanciaSoldado.position = marca.global_position
			get_parent().add_child(instanciaSoldado)

func tomarDano(dano: int) -> void:
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
