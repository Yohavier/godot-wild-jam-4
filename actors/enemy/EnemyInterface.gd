extends "res://actors/enemy/Enemy.gd"


#Use this to handle animations.
#Possible animations are:

#Die
#Falling
#Hit
#Idle
#Jump (not programmed yet)
#Walk


func flip_sprite( boolean ):
	$Sprite2.flip_h = boolean


func _ready():
	self.connect( "change_anim", self, "change_anim" )
	self.connect( "flip_h", self, "flip_sprite" )


func change_anim( new_anim ):
	pass