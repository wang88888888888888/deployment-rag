from .openai_client import get_embedding, get_llm_answer
from .supabase_client import match_chunks

def answer_query(question: str) -> str:
    # 1. Generate embedding for the query
    query_embedding = get_embedding(question)

    # 2. Search Supabase for similar chunks
    matches = match_chunks(query_embedding, match_count=5)
    if not matches:
        return "Sorry, I couldn't find relevant information in the database."

    # 3. Assemble context from the most relevant chunks
    context = "\n\n".join([m['content'] for m in matches])

    # 4. Create a prompt for the LLM
    prompt = (
        f"Use the following context to answer the user's question.\n\n"
        f"Context:\n{context}\n\n"
        f"Question: {question}\n"
        f"Answer:"
    )

    # 5. Get answer from LLM
    answer = get_llm_answer(prompt)
    return answer 