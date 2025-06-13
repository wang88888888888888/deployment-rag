import openai
import os
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from .env

client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

try:
    response = client.embeddings.create(
        input="hello world",
        model="text-embedding-ada-002"
    )
    print("API key is working! Response:")
    print(response)
except Exception as e:
    print("API key test failed. Error:")
    print(e) 