from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from utils.rag_pipeline import answer_query
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

# Allow CORS for local frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ChatRequest(BaseModel):
    question: str


class ChatResponse(BaseModel):
    answer: str


@app.post("/chat", response_model=ChatResponse)
def chat_endpoint(request: ChatRequest):
    answer = answer_query(request.question)
    return ChatResponse(answer=answer)

try:
    from vercel_fastapi import VercelFastAPI
    app = VercelFastAPI(app)
except ImportError:
    pass  # Running locally, so just use FastAPI