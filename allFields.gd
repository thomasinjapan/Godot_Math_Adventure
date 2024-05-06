class_name allFields
extends Node2D

# TODO: implement selection of area

#region Variables
var selection:Array = []    # list of all currently selected fields must be of type SingfleField / arrays can't be strongly typed
var fieldArray:Array= []    # list of all fields incl. neighbors must be of type SingfleField / arrays can't be strongly typed
#endregion

#region System Functions
# Called when the node enters the scene tree for the first time.
func _ready():
	createFieldArray()
	# subscribe to all touch events of all singlefields
	for SingleSingleField in self.get_children():
		if SingleSingleField is SingleField:
			SingleSingleField.touched.connect(_on_singleField_touched)
#endregion

#region Interrnal Functions
## initialize the fieldArray
## since it is 2-dimensional it must be initialized manually
func createFieldArray():
	for x:int in range(0,5):
		fieldArray.append([])     # make the array 4-dimensional
		for y:int in range(0,5):
			# prepare new line for next x
			var newNeighborField:NeighborMap = NeighborMap.new(
					getFieldByCoordinate(x,y),
					getFieldByCoordinate(x,y-1),
					getFieldByCoordinate(x,y+1),
					getFieldByCoordinate(x-1,y),
					getFieldByCoordinate(x+1,y)
			)
			fieldArray[x].append(newNeighborField)
			#if self is null, replace it with null
			if newNeighborField.me==null:
				fieldArray[x][y]=null
			prints(newNeighborField)
	prints(fieldArray)

## retruns a field from all fields that match x and y coordinate; else null
func getFieldByCoordinate(x:int,y:int) -> SingleField:
	for SingleSingleField in self.get_children():
		if SingleSingleField is SingleField:
			if SingleSingleField.x == x && SingleSingleField.y == y:
				return SingleSingleField
	return null
#endregion

#region Signal Subscriptions

func _on_singleField_touched(singleField:SingleField):
	print("touched:" + singleField.name)
	
#endregion
