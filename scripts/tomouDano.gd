extends Node2D

@export var label: Label
@export var animacao: AnimationPlayer

func tomouDano(dano: float) -> void:
	label.text = str(dano)
	animacao.play("tomou")
	
