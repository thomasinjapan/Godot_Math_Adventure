class_name Wall
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#region Internal Functions

## returns wallpiece by y coordinate
## y: row
func getWallByY(y:int) -> WallPiece:
	for singleWallField in self.get_children():
		if singleWallField is WallPiece:
			if singleWallField.y == y :
				return singleWallField
	return null

## takes damage if any from the monster in a given row
## y: row
## value: amount of damage
func takeDamage(y:int, value:int) -> void:
	getWallByY(y).takeDamage(value)

#endregion
