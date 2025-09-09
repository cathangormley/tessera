extends Resource
class_name Job

@export var name: String
## How much the unit's base stats grow per level in this job
@export var attribute_growths: AttributeArray

## The amount of hp per level this job grants
@export var hp: int
