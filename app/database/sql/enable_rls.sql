-- Create the documents table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.documents (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title text,
    file_path text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Create the chunks table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.chunks (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    document_id uuid REFERENCES public.documents(id),
    content text,
    metadata jsonb DEFAULT '{}'::jsonb,
    embedding vector(1536),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Create index for the foreign key and embedding
CREATE INDEX IF NOT EXISTS chunks_document_id_idx ON public.chunks(document_id);

-- Enable RLS for both tables
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chunks ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Enable read for all users" ON public.documents;
DROP POLICY IF EXISTS "Enable write for authenticated users" ON public.documents;
DROP POLICY IF EXISTS "Enable read for all users" ON public.chunks;
DROP POLICY IF EXISTS "Enable write for authenticated users" ON public.chunks;

-- Create separate read and write policies for documents
CREATE POLICY "Enable read for all users" 
ON public.documents FOR SELECT 
TO authenticated, anon
USING (true);

CREATE POLICY "Enable write for authenticated users" 
ON public.documents FOR ALL 
TO authenticated
USING (true)
WITH CHECK (true);

-- Create separate read and write policies for chunks
CREATE POLICY "Enable read for all users" 
ON public.chunks FOR SELECT 
TO authenticated, anon
USING (true);

CREATE POLICY "Enable write for authenticated users" 
ON public.chunks FOR ALL 
TO authenticated
USING (true)
WITH CHECK (true);

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated, anon;
GRANT SELECT ON public.documents TO authenticated, anon;
GRANT SELECT ON public.chunks TO authenticated, anon;
GRANT ALL ON public.documents TO authenticated;
GRANT ALL ON public.chunks TO authenticated; 