class_name player
extends CharacterBody2D

@export var animacao: AnimationPlayer
@export var sprint: Sprite2D
@export var area_ataque: Area2D

@export var dead: PackedScene
@export var cenario: PackedScene
@export var barraProgreso: ProgressBar
@export var barraXp: ProgressBar

@export var scene_habilidade_Castelo: PackedScene

@export_range(0, 1) var ataqueDot: float = 0.3
@export_range(0, 60) var attack_doll: float = 0.0

@export var vida: float = 100
@export var vidaMaxima: float = 100
@export var ataque: float = 5
@export var speed: float = 3.0
@export var level: int = 1
@export var valor_lerp: float = 0.2
@export var habilidade_castelo: bool = false
@export var habilidade_ritual: bool = false

@export var DanoTempo: float = 0.5
@export var tempo_Habilidade_Castelo: float = 3.0

var kills: int
var XPMax: float
var XP: float
var tempo_Castelo_reset = tempo_Habilidade_Castelo
var in_attack: bool = false
var tempoDano: float = 0.0
var rum: bool = false
var tempo = attack_doll
var atadown: bool = false
var ataup: bool = false
var atafrente: bool = false
var XPInicio = 100

#func _process(delta: float) -> void:
#	if Input.is_action_just_released("mover-right"):
#		if rum:
#			animacao.play("idle")
#			rum = false
#		else:
#			animacao.play("rum")
#			rum = true

func _ready():
	kills = 0
	GameManager.player = self
	tempo_Habilidade_Castelo *= 60.0
	tempo_Castelo_reset = tempo_Habilidade_Castelo
	XPMax = XPInicio

func _process(delta: float) -> void:
	barraXp.max_value = XPMax
	barraXp.value = XP
	barraProgreso.max_value = vidaMaxima
	barraProgreso.value = vida
	GameManager.player_position = position
	attack_doll -= delta
	tempoDano -= delta
	tempo_Habilidade_Castelo -= delta
	if Input.is_action_pressed("usar") and tempo_Habilidade_Castelo <= 0 and habilidade_castelo:
		tempo_Habilidade_Castelo = tempo_Castelo_reset
		ativarCastelo()
	if attack_doll <= 0.0:
		in_attack = false
	if Input.is_action_pressed("atacar"):
		attack() 
	if XP >= XPMax:
		upar_level()


func _physics_process(delta: float) -> void:
	var direcao = Input.get_vector("mover esquerda", "mover direita", "mover cima", "mover baixo")

	var maximo_speed = direcao * speed * 100
	
	if in_attack:
		maximo_speed = maximo_speed * 0.25
		
	velocity = lerp(velocity, maximo_speed, valor_lerp)
	move_and_slide()

	rum = not direcao.is_zero_approx()
	
	if not in_attack:
		rodar_personagem()

	# Animação de movimento

func rodar_personagem() -> void:
	if in_attack:
		
		if Input.is_action_pressed("mover cima"):
			if ataup:
				animacao.play("attack up")
			
			if not ataup:
				animacao.play("attack up2")
			
		elif Input.is_action_pressed("mover baixo"):
			if atadown:
				animacao.play("attack down")
			
			if not atadown:
				animacao.play("attack down2")
			
		else:
			if atafrente:
				animacao.play("attack frente")
			
			if not atafrente:
				animacao.play("attack frente2")
			
	elif rum:
		animacao.play("rum")
	else:
		animacao.play("idle")

	# 🔹 Garantir que a direção horizontal tenha prioridade no flip_h
	if Input.is_action_pressed("mover direita"):
		sprint.flip_h = false  # Sempre vira para a direita se "mover-right" estiver pressionado
	elif Input.is_action_pressed("mover esquerda"):
		sprint.flip_h = true   # Sempre vira para a esquerda se "mover-left" estiver pressionado
		

func attack() -> void:
	
	if in_attack:
		return
	if Input.is_action_pressed("mover cima"):
		if not ataup:
			animacao.play("attack up")
			ataup = true
			
		elif ataup:
			animacao.play("attack up2")
			ataup = false
		
	elif Input.is_action_pressed("mover baixo"):
		if not atadown:
			animacao.play("attack down")
			atadown = true
			
		elif atadown:
			animacao.play("attack down2")
			atadown = false
			
	else:
		if not atafrente:
			animacao.play("attack frente")
			atafrente = true
			
		elif atafrente:
			animacao.play("attack frente2")
			atafrente = false
			
	attack_doll = 0.53
	in_attack = true

func tomarDano(dano: int) -> void:
	#tomou dano
	if tempoDano <= 0:
		vida -= dano
		tempoDano = DanoTempo
		
		#mudar de cor
		modulate = Color.RED
		var tewn = create_tween()
		tewn.set_ease(Tween.EASE_IN)
		tewn.set_trans(Tween.TRANS_QUINT)
		tewn.tween_property(self, "modulate", Color.WHITE, 0.3)
		#se morreu acabou
		if vida <= 0:
			var morreu = dead.instantiate()
			morreu.position = position
			var camera = Camera2D.new()
			camera.position = position
			get_parent().add_child(morreu)
			get_parent().add_child(camera)
			queue_free()

func coletarCarne(cura: float) -> void:
	vida += cura
	if vida > vidaMaxima:
		vida = vidaMaxima

func darDanoUp() -> void:
	area_ataque.monitoring = true
	var bodies = area_ataque.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("grupo enemy"):
			var direcao_para_inimigo = (body.position - position).normalized()
			var direcao_ataque: Vector2
			direcao_ataque = Vector2.UP
			var ataque_dot = direcao_para_inimigo.dot(direcao_ataque)
			if ataque_dot >= ataqueDot:
				body.tomar_dano(ataque)

func darDanoDown() -> void:
	area_ataque.monitoring = true
	var bodies = area_ataque.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("grupo enemy"):
			var direcao_para_inimigo = (body.position - position).normalized()
			var direcao_ataque: Vector2
			direcao_ataque = Vector2.DOWN
			var ataque_dot = direcao_para_inimigo.dot(direcao_ataque)
			if ataque_dot >= ataqueDot:
				body.tomar_dano(ataque)

func darDanoFrente() -> void:
	area_ataque.monitoring = true
	var bodies = area_ataque.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("grupo enemy"):
			var direcao_para_inimigo = (body.position - position).normalized()
			var direcao_ataque: Vector2
			
			if sprint.flip_h:
					direcao_ataque = Vector2.LEFT
			else:
				direcao_ataque = Vector2.RIGHT
				
			var ataque_dot = direcao_para_inimigo.dot(direcao_ataque)
			if ataque_dot >= ataqueDot:
				body.tomar_dano(ataque)
				
func danoRitual(dano: float, body) -> void:
	body.tomar_dano(dano)

func ativarCastelo() -> void:

	var instanciaCastelo = scene_habilidade_Castelo.instantiate()
	var position_player = position
	position_player.y -= 60
	instanciaCastelo.position = position_player

	var parent = get_parent()
	if parent:
		parent.add_child(instanciaCastelo)
		get_parent().add_child(instanciaCastelo)
		
func habilitar_castelo() -> void:
	habilidade_castelo = true

func habilitar_ritual() -> void:
	habilidade_ritual = true

func upar_level():
	XPMax = XPInicio * ((level / 5) + 1)
	XP = 0
	vida += vidaMaxima / 2
	ataque += 2
	level += 1
