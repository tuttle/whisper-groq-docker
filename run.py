from email.mime import audio
import os
import sys
from groq import Groq


# Using Whisper Groq Speech To Text service. Reference: https://console.groq.com/docs/speech-to-text


def print_transcript(audio_file_path) -> str:
    client = Groq(
        api_key=os.environ.get("GROQ_API_KEY")
    )

    groq_model = os.environ.get("GROQ_MODEL", "whisper-large-v3-turbo")

    groq_prompt = os.environ.get("GROQ_PROMPT", "")

    groq_language_code = os.environ.get("GROQ_LANGUAGE_CODE", "en")

    groq_temperature = float(
        os.environ.get("GROQ_TEMPERATURE", "0")
    )

    with open(audio_file_path, "rb") as file:
        transcription = client.audio.transcriptions.create(
            file=(os.path.basename(p=audio_file_path), file.read()),
            model=groq_model,
            prompt=groq_prompt,
            language=groq_language_code,
            temperature=groq_temperature,
            response_format="text",
        )

    print(
        transcription.strip()
    )


if __name__ == "__main__":
    try:
        audio_file_path = sys.argv[1]
    except IndexError:
        print("Usage: python run.py <audio_file_path>")
        sys.exit(1)

    print_transcript(audio_file_path)
