extends Node

const SAMPLERATE_HZ = 22050.0

onready var player = $AudioStreamPlayer
onready var playback: AudioStreamPlayback = null

func note2freq(n: float):
	return pow(2.0, (n - 69) / 12) * 440

class Voice:
	var pulse_hz = 440
	var beep_dur = 0
	var phase = 0
	var global_vol = 1

	var env_vol = 1
	var env_vol_step = 0.0001

	var queue = []

	var declick = false
	
	func fill(buffer: Array):
		var increment = pulse_hz / SAMPLERATE_HZ

		for i in buffer.size():
			if not declick and beep_dur <= 0 and queue.size() > 0:
				pulse_hz = queue[0][0]
				increment = pulse_hz / SAMPLERATE_HZ
				beep_dur = queue[0][1] * SAMPLERATE_HZ
				env_vol = queue[0][2] * global_vol
				queue.remove(0)
				
			var sample = Vector2.ZERO
			if declick or beep_dur > 0:
				var s = sin(phase * TAU)
				sample = Vector2.ONE * pow(s, 2)* env_vol
				if declick and abs(s) < 0.01:
					declick = false
				
				phase = fmod(phase + increment, 1.0)
				beep_dur -= 1
				env_vol = max(0, env_vol - env_vol_step)
				
				if beep_dur == 0:
					declick = true
				
			buffer[i] += sample

var voices = [Voice.new(), Voice.new()]

func fill_play_buffer():
	var nframes = playback.get_frames_available()
	var buffer = Array()
	buffer.resize(nframes)
	buffer.fill(Vector2.ZERO)
	for v in voices:
		v.fill(buffer)
	
	playback.push_buffer(PoolVector2Array(buffer))
	
func noteq(voice, note, duration, vol = 1):
	voices[voice].queue.append([note2freq(note), duration, vol])

func beepq(voice, freq, duration):
	voices[voice].queue.append([freq, duration])

#func beep(freq, duration_s):
#	pulse_hz = freq
#	beep_dur = duration_s * SAMPLERATE_HZ

func _ready():
	player.stream.mix_rate = SAMPLERATE_HZ
	playback = player.get_stream_playback()
	fill_play_buffer()
	player.play()

func _process(delta):
	fill_play_buffer()
	
