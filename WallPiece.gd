class_name WallPiece
extends Node2D

#region variables
@export var HP:int = 4
@export_group("location")
@export var x:int = 1
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabels()

#region UI functions

## updates the labels based on the current values
func updateLabels():
	$labels/HP.text = str(HP)
	$labels/x.text  = "x = " + str(x)

#endregion
