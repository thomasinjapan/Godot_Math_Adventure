class_name allFields
extends Node2D


var selectedSum:int:    # sum of all values in the selection
	get:
		return selectedSum
	set(newValue):
		selectedSum = newValue
		valueUpdated.emit(selectedSum)

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
			SingleSingleField.selected.connect(_on_singleField_selected)
#endregion

#region Signals
signal valueUpdated(int)    #triggers when the value of the selection was updated
#endregion

#region Interrnal Functions
## initialize the fieldArray
## since it is 2-dimensional it must be initialized manually
func createFieldArray():
	for x:int in range(0,4):
		for y:int in range(0,4):
			# prepare new line for next x
			var newNeighborField:NeighborMap = NeighborMap.new(
					getFieldByCoordinate(x+1  ,y+1),
					getFieldByCoordinate(x+1  ,y+1-1),
					getFieldByCoordinate(x+1  ,y+1+1),
					getFieldByCoordinate(x+1-1,y+1),
					getFieldByCoordinate(x+1+1,y+1)
			)
			fieldArray.append(newNeighborField)
			#if self is null, replace it with null
			if newNeighborField.me==null:
				fieldArray.append(null)
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

## triggers if a field is touched and checks if it
## - creates a new selection
## - adds to an existing selection
## - starts a new selection
## - removes from a selection <-- not sure if I will implemented
func _on_singleField_touched(singleField:SingleField):
	print("touched:" + singleField.name)
	if selection == []:
		print("no selection so far")
		# TODO: find out correct borders
		print(SingleField.SELECTION_ALL)
		singleField.select(SingleField.SELECTION_ALL)
		
		selection.append(singleField)

	elif selection.has(singleField):
		print("field is already part of selection")
		# do nothing
	elif isNeighborToSelection(singleField):
		# add to selection
		# TODO: find out correct borders
		singleField.select(SingleField.enumSelectionDirection.SELECTION_ALL)
		
		selection.append(singleField)
	else: #new selection starts
		# delesect all fields
		# TODO:check if deselection is correct
		for deselectField:SingleField in selection:
			deselectField.deselect()
		
		selection=[singleField]
	
	prints(selection)

## triggers if a field is selected
func _on_singleField_selected(singleField:SingleField):

	# add value to overall sum
	selectedSum += singleField.value
	
	# emit info to game that sum was updated
#endregion

## checks for a field if it is a neighbor of the existing selection 
func isNeighborToSelection(singleField:SingleField) -> bool:
	var result:bool = false
	for indexField:SingleField in selection:
		#find field in fieldArray
		for arrayField:NeighborMap in fieldArray:
			if arrayField.me == indexField:
				# field found, now look around
				#look around and if not null and found, return true
				if arrayField.top != null && arrayField.top == singleField: return true
				if arrayField.bottom != null && arrayField.bottom == singleField: return true
				if arrayField.left != null && arrayField.left == singleField: return true
				if arrayField.right != null && arrayField.right == singleField: return true
	return false
