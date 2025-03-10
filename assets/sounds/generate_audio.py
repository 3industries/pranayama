from pydub import AudioSegment
from pydub.generators import Sine

def generate_tone(filename, frequency, duration_ms, volume=-20.0):
    # Genera un'onda sinusoidale
    tone = Sine(frequency).to_audio_segment(duration=duration_ms).apply_gain(volume)
    # Esporta il file in formato MP3
    tone.export(filename, format="mp3")

if __name__ == "__main__":
    # Genera un suono per "inhale" (ad esempio, 440 Hz per 3 secondi)
    generate_tone("inhale.mp3", frequency=440, duration_ms=3000)
    # Genera un suono per "hold" (ad esempio, 220 Hz per 3 secondi)
    generate_tone("hold.mp3", frequency=220, duration_ms=3000)
    # Genera un suono per "exhale" (ad esempio, 330 Hz per 3 secondi)
    generate_tone("exhale.mp3", frequency=330, duration_ms=3000)