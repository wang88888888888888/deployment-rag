-- 1. First clean up existing tables and extensions
DROP TABLE IF EXISTS public.chunks CASCADE;
DROP TABLE IF EXISTS public.documents CASCADE;
DROP EXTENSION IF EXISTS vector CASCADE;

-- 2. Create and setup vector extension in extensions schema
CREATE SCHEMA IF NOT EXISTS extensions;
CREATE EXTENSION IF NOT EXISTS vector SCHEMA extensions;

-- 3. Create the documents table
CREATE TABLE public.documents (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title text,
    file_path text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- 4. Create the chunks table with proper vector type
CREATE TABLE public.chunks (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    document_id uuid REFERENCES public.documents(id),
    content text,
    metadata jsonb DEFAULT '{}'::jsonb,
    embedding extensions.vector(1536),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- 5. Create necessary indexes
CREATE INDEX chunks_document_id_idx ON public.chunks(document_id);
CREATE INDEX chunks_embedding_idx ON public.chunks 
USING ivfflat (embedding extensions.vector_cosine_ops)
WITH (lists = 100);

-- 6. Enable RLS for both tables
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chunks ENABLE ROW LEVEL SECURITY;

-- 7. Create security policies that allow inserts from the anon key
-- For documents table
DROP POLICY IF EXISTS "Enable read for all users" ON public.documents;
DROP POLICY IF EXISTS "Enable write for authenticated users" ON public.documents;
DROP POLICY IF EXISTS "Enable write for all users" ON public.documents;

CREATE POLICY "Enable read for all users" 
ON public.documents FOR SELECT 
TO authenticated, anon
USING (true);

CREATE POLICY "Enable write for all users" 
ON public.documents FOR INSERT
TO authenticated, anon
WITH CHECK (true);

-- For chunks table
DROP POLICY IF EXISTS "Enable read for all users" ON public.chunks;
DROP POLICY IF EXISTS "Enable write for authenticated users" ON public.chunks;
DROP POLICY IF EXISTS "Enable write for all users" ON public.chunks;

CREATE POLICY "Enable read for all users" 
ON public.chunks FOR SELECT 
TO authenticated, anon
USING (true);

CREATE POLICY "Enable write for all users" 
ON public.chunks FOR INSERT
TO authenticated, anon
WITH CHECK (true);

-- 8. Create vector similarity search function with improved matching
CREATE OR REPLACE FUNCTION public.match_chunks(
    query_embedding extensions.vector(1536),
    match_count int DEFAULT 5,
    similarity_threshold float DEFAULT 0.5
)
RETURNS TABLE (
    id uuid,
    content text,
    metadata jsonb,
    similarity float,
    document_title text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.content,
        c.metadata,
        1 - (c.embedding <=> query_embedding) as similarity,
        d.title as document_title
    FROM public.chunks c
    JOIN public.documents d ON c.document_id = d.id
    WHERE c.embedding IS NOT NULL
    AND 1 - (c.embedding <=> query_embedding) > similarity_threshold
    ORDER BY c.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- 9. Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated, anon;
GRANT USAGE ON SCHEMA extensions TO authenticated, anon;
GRANT ALL ON public.documents TO authenticated, anon;
GRANT ALL ON public.chunks TO authenticated, anon;
GRANT EXECUTE ON FUNCTION public.match_chunks(extensions.vector(1536), int, float) TO authenticated, anon; 