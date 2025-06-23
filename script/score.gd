extends Node

var scoreboard = []
const MAX_SCOREBOARD_LENGTH = 5
const SAVE_PATH = "user://scoreboard.json"
const SCOREBOARD_PATH = "Camera/UI/ScoreBoard"

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
	renderScoreBoard()
	

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
	renderScoreBoard()

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

# Brute forcing for now will think about ways to use get_children to make this easier
func renderScoreBoard():
	var count = 0
	var placementNames = ["First", "Second", "Third", "Fourth", "Fifth"]
	for entry in scoreboard:
		get_tree().current_scene.get_node(SCOREBOARD_PATH + "/" + placementNames[count] + "PlaceName").text = entry.name
		get_tree().current_scene.get_node(SCOREBOARD_PATH + "/" + placementNames[count] + "PlaceScore").text = "%d" % entry.score
		count = count + 1
	return
