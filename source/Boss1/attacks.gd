class_name Attack

var function: Callable # Function to be called
var parameters: Array # Argument to be passed

func _init(function_name: Callable, params: Array) -> void:
  function = function_name
  parameters = params
