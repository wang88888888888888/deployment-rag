import os
from typing import List, Dict, Any
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

class SupabaseClient:
    def __init__(self):
        self.supabase: Client = create_client(
            os.getenv("SUPABASE_URL"),
            os.getenv("SUPABASE_KEY")
        )

    def store_document(self, title: str, file_path: str, metadata: Dict[str, Any] = None) -> str:
        """Store document metadata and return document ID."""
        result = self.supabase.table("documents").insert({
            "title": title,
            "file_path": file_path,
            "metadata": metadata or {}
        }).execute()
        return result.data[0]["id"]

    def store_chunks(self, document_id: str, chunks: List[Dict[str, Any]]):
        """Store document chunks with their embeddings."""
        for chunk in chunks:
            self.supabase.table("chunks").insert({
                "document_id": document_id,
                "content": chunk["content"],
                "embedding": chunk["embedding"],
                "metadata": chunk.get("metadata", {})
            }).execute()

    def search_similar_chunks(self, query_embedding: List[float], limit: int = 5) -> List[Dict[str, Any]]:
        """Search for similar chunks using vector similarity."""
        result = self.supabase.table("chunks").select(
            "id, content, metadata, documents(title, file_path)"
        ).order(
            "embedding <=> :query_embedding"
        ).limit(limit).execute({
            "query_embedding": query_embedding
        })
        return result.data 