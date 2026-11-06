class_name BlockInteractor
extends Node
@onready var camera_3d: Camera3D = $"../Camera3D"

var voxel_tool: VoxelTool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var terrain := get_parent().get_parent().get_node_or_null("VoxelTerrain") as VoxelTerrain #das walross kann hier noch nicht predicten was das überhaupt ist das führt dazudas wir nur dieocmpletions von einer normalen node rkeigen würden also schieben wir ihm hier in den arsch das es VoxelTerrain GDScriptNativeClass ist
	if terrain:
		voxel_tool = terrain.get_voxel_tool()


func pick_block(): 
	var voxel_result: VoxelRaycastResult = voxel_tool.raycast(camera_3d.global_position, -camera_3d.global_transform.basis.z, 3) #hier packen wir ein voxel raycast result hin WEIL WIR HIER DEKLARIEREN DAS DARF NUR EINMAL HIN DAS HEIST NUR DU BIST VON DEM TYPE, damit der godot compiler weis was genau er autocompleten kann etc
	if voxel_result:
		print(voxel_result.position)
		return voxel_result

@rpc("reliable", "any_peer", "call_local") # call local muss darein weil Godot sonst eine Diva ist und wenn der server selber einen block removen will würde er sich sonst blocken weil er ja schon der empfänger ist
func delete_block(voxel_result_position: Vector3i):
	if multiplayer.is_server():
		if voxel_result_position != Vector3i.ZERO: #just preventing the game crashing when voxel_result2 is a null bc for example it didnt catch a block in its 3 blocks range
			voxel_tool.set_voxel(voxel_result_position, 0) #nicht die klassen einfach so reinschrieben godot kann keine gedanken elsen, eimnfach IMMER variablen nutzen er hat den context nicht aber wenn man eine var über ein GDScriptnative class object macht dann schon
			print("Block at: ", voxel_result_position, " was successfully removed")

@rpc("reliable", "any_peer", "call_local")
func request_delete_block():
	var voxel_result2 = pick_block()
	
	if voxel_result2:
		delete_block.rpc_id(1, voxel_result2.position)
	#hier nicht voxel_result.position weil i gueess die Vector3i ist eh schon die position und die gibt halt dieser raycast dann aus meine fresse woher soll ich das wissen ugh gott

# ==============================================================================
# LERN-NOTIZEN / WARUM DIESE FUNKTIONEN GENAU SO AUFGEBAUT SIND:
# ==============================================================================
#
# 1. SERVER-AUTORITÄT (Zylann Voxel):
#    - Der 'VoxelTerrainMultiplayerSynchronizer' repliziert Voxel-Änderungen NUR
#      vom Server nach unten an die Clients, NIEMALS umgekehrt!
#    - Ein Client darf 'voxel_tool.set_voxel()' nicht lokal aufrufen, sonst sieht
#      nur er die Änderung (Desync).
#    - Lösung: Der Client muss den Server per RPC bitten ("Request"), den Block
#      abzubauen. Der Server führt es aus, und der Synchronizer beamt es an alle.
#
# 2. WARUM ZWEI FUNKTIONEN (Client-Zielen vs. Server-Bauen)?
#    - 'pick_block()' nutzt die lokale Kamera (wo der Spieler hinschaut).
#      Auf dem Server schaut die Kamera ganz woanders hin!
#    - Job 1 (request_delete_block): Läuft lokal beim Klick. Führt den Raycast aus.
#    - Job 2 (delete_block): Läuft auf dem Server per RPC. Nimmt die fertige
#      Koordinate entgegen und setzt den Block auf 0 (Luft).
#
# 3. DER TYPEN-UNTERSCHIED: OBJEKT vs. POSITION:
#    - 'pick_block()' gibt ein ganzes 'VoxelRaycastResult'-Objekt zurück (weil ein
#      Raycast viele Infos hat: Trefferseite (.normal), Koordinate (.position), etc.).
#    - 'voxel_tool.set_voxel()' und der RPC wollen aber KEIN ganzes C++ Objekt,
#      sondern NUR die Koordinate ('Vector3i').
#    - WICHTIG: Beim Abschicken extrahieren wir '.position'. Die Variable, die
#      in 'delete_block(block_pos)' drüben ankommt, IST also schon die Position!
#      (Wer dort nochmal '.position' aufruft, crasht mit: "Invalid access on Vector3i").
#
# 4. DIE NULL-FALLE (Luftklicks):
#    - Klickt man in den Himmel, gibt der Raycast 'null' zurück.
#    - Greift man ohne Check auf 'result.position' zu, crasht das Spiel sofort
#      ("Invalid access on Nil"). Deshalb IMMER erst: 'if result != null:'!
#
# 5. WARUM '@rpc("call_local")'?
#    - Ohne 'call_local' schickt Godot RPCs nur über die Netzwerkkarte nach draußen.
#    - Da der Host gleichzeitig auch ein lokaler Spieler ist, würde er sich selbst
#      ignorieren. 'call_local' sorgt dafür, dass der Host den Code auch lokal ausführt.
#
# 6. DER 600-ERROR-DEBUGGER-BUG (Geister-Peers):
#    - Wenn ein Client disconnectet, muss sein Player-Node via 'queue_free()' gelöscht werden!
#    - Lässt man die Node im Baum, sucht der 'VoxelViewer' nach der toten Peer-ID und
#      wirft bei JEDEM Voxel-Update: "Attempt to call RPC with unknown peer ID".
# ==============================================================================

#btw Vector3 is the coordinate with 10 billion numbers after the comma, whereas Vector3i is an integer


func change_block():
	pass
