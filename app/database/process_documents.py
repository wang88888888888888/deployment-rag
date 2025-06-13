import os
from pathlib import Path
from typing import List, Dict, Any
from .supabase_client import SupabaseClient
from ..document_processor.processor import DocumentProcessor as DocProcessor
from ..embeddings.embedder import EmbeddingGenerator


class DocumentProcessor:
    def __init__(self):
        self.supabase = SupabaseClient()
        self.doc_processor = DocProcessor()
        self.embedder = EmbeddingGenerator()
    
    def process_directory(self, directory_path: str):
        """Process all documents in a directory."""
        directory = Path(directory_path)
        
        # Process each file in the directory
        for file_path in directory.glob("*"):
            if file_path.suffix.lower() in ['.pdf', '.pptx', '.ppt']:
                try:
                    # Process document
                    chunks = self.doc_processor.process_document(str(file_path))
                    
                    # Generate embeddings
                    chunks_with_embeddings = self.embedder.generate_embeddings(chunks)
                    
                    # Store document metadata
                    doc_id = self.supabase.store_document(
                        title=file_path.stem,
                        file_path=str(file_path),
                        metadata={
                            "file_type": file_path.suffix.lower(),
                            "file_size": file_path.stat().st_size
                        }
                    )
                    
                    # Store chunks with embeddings
                    self.supabase.store_chunks(doc_id, chunks_with_embeddings)
                    
                    print(f"Successfully processed {file_path.name}")
                    
                except Exception as e:
                    print(f"Error processing {file_path.name}: {str(e)}")


if __name__ == "__main__":
    # Process documents in the samples directory
    processor = DocumentProcessor()
    processor.process_directory("samples") 