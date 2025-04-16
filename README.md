Speech To Text (STT) with Whisper Groq
======================================

1. Set env vars in your .bashrc: See stt script for examples.

2. Run::

        docker build -t whisper-groq-docker .

    to build the image.


3. Run::

        stt

    to capture audio using arecord (press Ctrl+C to interrupt recording), convert it to text using Whisper Groq, and print the transcription.

The audio files and transcriptions are saved to `/tmp/whisper-groq-audios` by default.
