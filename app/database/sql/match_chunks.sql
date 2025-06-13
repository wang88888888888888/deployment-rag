-- Enable the pgvector extension
create extension if not exists vector;

-- Function to match chunks based on vector similarity
create or replace function match_chunks(
    query_embedding vector(1536),
    match_count int
)
returns table (
    id uuid,
    content text,
    metadata jsonb,
    similarity float
)
language plpgsql
as $$
begin
    return query
    select
        chunks.id,
        chunks.content,
        chunks.metadata,
        1 - (chunks.embedding <=> query_embedding) as similarity
    from chunks
    order by chunks.embedding <=> query_embedding
    limit match_count;
end;
$$; 