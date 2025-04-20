extends RefCounted

var queue = []
var current_writer_pos = 0
var max_size = 0

func init(size: int) -> void:
	queue.resize(size)
	max_size = size

func add_item(item) -> void:
	assert(max_size != 0)
	queue[current_writer_pos] = item
	current_writer_pos = (current_writer_pos + 1) % max_size

func pop():
	var last_position = current_writer_pos - 1
	if last_position == -1:
		last_position = max_size - 1
	
	var value = queue.get(last_position)
	current_writer_pos = last_position
	queue[current_writer_pos] = null
	return value

func _to_string() -> String:
	var message = "{current_writter_pos: %d, max_size: %d, queue: %s}" % [current_writer_pos, max_size, queue]
	print("Queue size is: %d" % queue.size())
	
	return message
