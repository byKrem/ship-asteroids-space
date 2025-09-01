extends AudioStreamPlayer

var _streams_ids : Array[int]

func play_polyphonic(sound: String):
	if !playing: self.play()
	
	_check_streams()
	
	var polyphonic_playback := self.get_stream_playback()
	var stream_id = polyphonic_playback.play_stream(load(sound))
	_streams_ids.append(stream_id)

func _check_streams():
	var polyphonic_playback := self.get_stream_playback()
	for n in _streams_ids:
		if polyphonic_playback.is_stream_playing(n):
			polyphonic_playback.stop_stream(n)
