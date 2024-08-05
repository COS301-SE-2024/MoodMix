import time
import sounddevice as sd
import numpy as np
from pydub import AudioSegment
from pydub.playback import play

import whisper
from pathlib import Path


SAMPLE_RATE = 44100  # Sample rate in Hertz
DURATION = 10  # Duration of each recording in seconds
INTERVAL = 30
    
def record_audio(duration, sample_rate):
    """Record audio for a given duration and sample rate."""
    print("Recording...")
    recording = sd.rec(int(duration * sample_rate), samplerate=sample_rate, channels=2, dtype='int16')
    sd.wait()  # Wait until recording is finished
    print("Recording complete.")
    return recording

def save_audio(data, filename, sample_rate):
    """Save recorded audio data to a file."""
    audio_segment = AudioSegment(
        data=data.tobytes(),
        sample_width=data.dtype.itemsize,
        frame_rate=sample_rate,
        channels=data.shape[1]
    )
    audio_segment.export(filename, format="mp3")  # Change format to "mp3" if needed
    print(f"Audio saved as {filename}")
    
def transcribe_audio(path):
    """Transcribe audio using whisper model."""
    model = whisper.load_model('tiny')
    result = model.transcribe(str(path), language='en', verbose=True)
    with open('transcript.txt', "w") as file:
        file.write(result['text'])
    print("Transcription saved to transcript.txt")
    
    
def main():
    try:
        while True:
            # Record audio
            audio_data = record_audio(DURATION, SAMPLE_RATE)
            
            # Save audio to file
            save_audio(audio_data, "Latest.mp3", SAMPLE_RATE)
            
            #transcribe the audio
            transcribe_audio(Path('Latest.mp3'))
            
            # Wait for the next recording
            time.sleep(INTERVAL)
    except KeyboardInterrupt:
        print("Script stopped by user.")

if __name__ == "__main__":
    main()