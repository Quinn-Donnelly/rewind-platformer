extends Node

var scoreboard = []
const MAX_SCOREBOARD_LENGTH = 10
const SAVE_PATH = "user://scoreboard.json"

class Ranking:
	var name: String
	var score: int
	
	func _init(n: String, s: int) -> void:
		name = n
		score = s
		
	func as_dict() -> Dictionary:
		return { "name": name, "score": score}
		
	static func from_dict(record: Dictionary) -> Ranking:
		return Ranking.new(record["name"], record["score"])

func _ready() -> void:
	loadScores()

func rankScore(score) -> int:
	var rank = len(scoreboard)
	while rank > 0:
		if score < scoreboard[rank-1].score:
			break
		rank = rank - 1
	
	if rank == 9:
		return -1

	return rank

func writeScores():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var writeData = []
	for entry in scoreboard:
		writeData.append(entry.as_dict())
	file.store_string(JSON.stringify(writeData))
	file.close()

func loadScores():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		print("%s" % JSON.stringify(content))
		var data = JSON.parse_string(content)
		for entry in data:
			scoreboard.append(Ranking.from_dict(entry))
		file.close()

func submitScore(score):
	print("scoring")
	var rank = rankScore(score)
	if rank == -1:
		return
	
	var scoreboard_entry = Ranking.new("Some Shit", score)
	
	scoreboard.insert(rank, scoreboard_entry)
	if len(scoreboard) > MAX_SCOREBOARD_LENGTH:
		scoreboard.resize(MAX_SCOREBOARD_LENGTH)
		
	print(scoreboard)
	writeScores()
