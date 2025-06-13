import openai
import os
from dotenv import load_dotenv

load_dotenv()
client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def get_embedding(text: str, model: str = "text-embedding-ada-002") -> list:
    response = client.embeddings.create(
        input=text,
        model=model
    )
    return response.data[0].embedding

def get_llm_answer(prompt: str, model: str = "gpt-3.5-turbo", max_tokens: int = 256) -> str:
    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        max_tokens=max_tokens,
        temperature=0.2,
    )
    return response.choices[0].message.content.strip() 