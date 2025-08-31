extends AudioStreamPlayer

func _ready():
	stream = AudioStreamPolyphonic.new()
	stream.polyphony = 4

func play_polyphonic(sound: String):
	if !playing: self.play()
	
	var polyphonic_playback := self.get_stream_playback()
	polyphonic_playback.play_stream(load(sound))
