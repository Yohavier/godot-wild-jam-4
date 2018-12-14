extends Node2D

signal new_obstacle

const NUMBER_OF_GROUND_OBSTACLE_TYPES = 5
const GROUND_OBSTACLE_FREQUENCY_MIN_VARIANCE = 0
const GROUND_OBSTACLE_FREQUENCY_MAX_VARIANCE = 0.75
const SKY_OBSTACLE_SPAWN_PROBABILITY = 0.55
const GROUND_OBSTACLE_SPAWN_COORDINATES = Vector2(1125, 530)
const LOW_AIR_SPAWN_COORDINATES = Vector2(1125, 450)
const HIGH_AIR_SPAWN_COORDINATES = Vector2(1125, 425)

export(float) var ground_obstacle_frequency = 0.75 setget _set_ground_obstacle_frequency
export(float) var sky_obstacle_frequency = 1.5 setget _set_sky_obstacle_frequency

var smoke_scene = preload("res://actors/enemy/obstacles/Smoke.tscn")
var single_small_flame_scene = preload("res://actors/enemy/obstacles/SingleSmallFlame.tscn")
var double_small_flame_scene = preload("res://actors/enemy/obstacles/DoubleSmallFlame.tscn")
var single_large_flame_scene = preload("res://actors/enemy/obstacles/SingleLargeFlame.tscn")
var single_deadly_large_flame_scene = preload("res://actors/enemy/obstacles/SingleDeadlyLargeFlame.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$GroundObstacleTimer.set_wait_time(ground_obstacle_frequency)
	$GroundObstacleTimer.start()
	$SkyObstacleTimer.set_wait_time(sky_obstacle_frequency)
	$SkyObstacleTimer.start()
	
func _emit_ground_obstacle():
	var obstacle_choice = randi() % NUMBER_OF_GROUND_OBSTACLE_TYPES
	var obstacle;
	match obstacle_choice:
		0:
			obstacle = single_small_flame_scene.instance()
		1:
			obstacle = double_small_flame_scene.instance()
		2:
			obstacle = single_large_flame_scene.instance()
		3:
			obstacle = single_deadly_large_flame_scene.instance()		
		_:
			obstacle = single_small_flame_scene.instance()
	obstacle.position = GROUND_OBSTACLE_SPAWN_COORDINATES
	emit_signal("new_obstacle", obstacle)
	$GroundObstacleTimer.set_wait_time(ground_obstacle_frequency + rand_range(GROUND_OBSTACLE_FREQUENCY_MIN_VARIANCE, GROUND_OBSTACLE_FREQUENCY_MAX_VARIANCE))
	pass
	
func _emit_sky_obstacle():
	var chance = rand_range(0, 1)
	if chance <= SKY_OBSTACLE_SPAWN_PROBABILITY:
		var obstacle = smoke_scene.instance()
		obstacle.position = LOW_AIR_SPAWN_COORDINATES
		emit_signal("new_obstacle", obstacle)
	
func _clean_up():
	$GroundObstacleTimer.stop()
	$GroundObstacleTimer.queue_free()
	$SkyObstacleTimer.stop()
	$SkyObstacleTimer.queue_free()
	
func _set_ground_obstacle_frequency(value):
	ground_obstacle_frequency = value
	
func _set_sky_obstacle_frequency(value):
	sky_obstacle_frequency = value	

func _on_LevelDurationTimer_timeout():
	_clean_up()
