extends Node2D

@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var congradulation_panel: Panel = $HUD/CongradulationPanel
@onready var congradulation_label: Label = $HUD/CongradulationPanel/CongradulationLabel

var level: int = 1
var score: int = 0
var total_coins: int = 0
var collected_coins: int = 0
var current_level_root: Node = null 

func _ready() -> void:
	current_level_root = get_node("LevelRoot")
	_load_level(level)


func _load_level(level_number: int) -> void:
	if current_level_root:
		current_level_root.queue_free()
	
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	var level_scene = load(level_path)

	if level_scene == null:
		print("Level file not found: ", level_path)
		return

	current_level_root = level_scene.instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"

	_setup_level(current_level_root)


func _setup_level(level_root: Node) -> void:
	collected_coins = 0
	total_coins = 0

	congradulation_panel.visible = false

	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

	var coins = level_root.get_node_or_null("Coins")
	if coins:
		total_coins = coins.get_child_count()

		for coin in coins.get_children():
			coin.colleted.connect(increase_score)


func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level += 1
		body.can_move = false
		_load_level(level)


func increase_score() -> void:
	score += 1
	collected_coins += 1

	score_label.text = "SCORE: %s" % score

	if collected_coins == total_coins:
		congradulation_panel.visible = true
