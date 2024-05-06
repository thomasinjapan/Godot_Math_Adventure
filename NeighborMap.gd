class_name NeighborMap

var me:SingleField = null     ## field itself
var top:SingleField = null    ## field to the top if it exists, else null
var bottom:SingleField = null ## field to the bottom if it exists, else null
var left:SingleField = null   ## field to the left if it exists, else null
var right:SingleField = null  ## field to the righ if it exists, else null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

## initialize all fields 
func _init(_me:SingleField,_top:SingleField,_bottom:SingleField,_left:SingleField,_right:SingleField):
	me=_me
	top=_top
	bottom=_bottom
	left=_left
	right=_right
