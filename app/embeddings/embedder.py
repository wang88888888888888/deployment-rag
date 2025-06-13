from typing import List, Dict, Any
from langchain_openai import OpenAIEmbeddings
from langchain.schema import Document
import os


class EmbeddingGenerator:
    def __init__(self):
        self.embeddings = OpenAIEmbeddings(
            model="text-embedding-ada-002",
            openai_api_key=os.getenv("OPENAI_API_KEY")
        )
    
    def generate_embeddings(self, chunks: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Generate embeddings for document chunks."""
        documents = [
            Document(
                page_content=chunk["content"],
                metadata=chunk["metadata"]
            )
            for chunk in chunks
        ]
        
        # Generate embeddings
        embeddings = self.embeddings.embed_documents([doc.page_content for doc in documents])
        
        # Combine chunks with their embeddings
        return [
            {
                "content": chunk["content"],
                "metadata": chunk["metadata"],
                "embedding": embedding
            }
            for chunk, embedding in zip(chunks, embeddings)
        ] 