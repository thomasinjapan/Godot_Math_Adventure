extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


#region Debug area
func _on_attack_button_up():
	$mathArea.attack()

#endregion
