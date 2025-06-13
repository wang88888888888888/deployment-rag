# AlbertaPerspectives RAG Chatbot

A Retrieval-Augmented Generation (RAG) system for querying economic research data from AlbertaPerspectives.ca.

## Features

- Document processing for PDF reports
- Semantic search using vector embeddings
- Context-aware chat interface
- Efficient data storage with Supabase
- Modern web interface

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Set up environment variables:
   - Copy `.env.template` to `.env`
   - Fill in your OpenAI API key and Supabase credentials

4. Start the backend:
   ```bash
   uvicorn app.main:app --reload
   ```

5. Start the frontend:
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

## Project Structure

```
.
├── app/
│   ├── main.py              # FastAPI application
│   ├── document_processor/  # Document processing logic
│   ├── embeddings/         # Vector embedding generation
│   ├── rag/               # RAG pipeline implementation
│   └── database/          # Database operations
├── frontend/              # React frontend
├── samples/              # Sample documents
└── requirements.txt      # Python dependencies
```

## Usage

1. Access the web interface at `http://localhost:3000`
2. Upload documents through the interface
3. Start chatting with the AI about Alberta economic data

## Technical Details

- Uses LangChain for RAG implementation
- OpenAI for embeddings and LLM
- Supabase for vector storage
- FastAPI backend
- React frontend

## Limitations

- Currently supports PDF documents only
- Limited to English language
- Requires OpenAI API key
