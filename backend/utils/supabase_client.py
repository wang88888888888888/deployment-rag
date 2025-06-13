from dotenv import load_dotenv
load_dotenv()
import os
from supabase import create_client, Client

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def match_chunks(query_embedding, match_count=5):
    # Calls the match_chunks function you created in Supabase SQL
    response = supabase.rpc(
        "match_chunks",
        {
            "query_embedding": query_embedding,
            "match_count": match_count
        }
    ).execute()
    return response.data 