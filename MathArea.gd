class_name MathArea
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#region functions
## makes all monsters to move one step left and if necessary attack the wall
func attack() -> void:
	# remove selection
	$monsterArea.delete_selection()
	
	# conduct attack
	attackRow(1)
	attackRow(2)
	attackRow(3)
	attackRow(4)
	
## attacks in row y
func attackRow(y:int) -> void:
	#first, move all monsters in the monster area and get the value that attacks the wall
	var damage:int = $monsterArea.attackRow(y)
	
	#if the attackvalue>1, handle the wall attack
	$wall.takeDamage(y,damage)

#endregion
