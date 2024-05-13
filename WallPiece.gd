class_name WallPiece
extends Node2D

#region variables
@export var HP:int = 4
@export_group("location")
@export var y:int = 1
#endregion

#region Signals
signal damaged(WallPiece)   # emits if the wall took damage
signal destroyed(WallPiece) # emits if the wall was destroyed
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabels()

#region UI functions

## updates the labels based on the current values
func updateLabels():
	$labels/HP.text = str(HP)
	$labels/y.text  = "y = " + str(y)
#endregion

#region functions
## causes taking damage and handles all concequences
func takeDamage(damage:int) -> void:
	#do math
	HP -= damage
	
	#update ui
	updateLabels()

	#emit signals
	damaged.emit(self)
	if HP <= 0: destroyed.emit(self)
#endregion
