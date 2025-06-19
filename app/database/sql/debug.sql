-- 1. Check if documents exist
SELECT COUNT(*) as document_count, title 
FROM public.documents 
GROUP BY title;

-- 2. Check if chunks exist and have embeddings
SELECT 
    d.title,
    COUNT(*) as chunk_count,
    COUNT(*) FILTER (WHERE c.embedding IS NOT NULL) as chunks_with_embeddings
FROM public.chunks c
JOIN public.documents d ON c.document_id = d.id
GROUP BY d.title;

-- 3. Test vector search function directly
SELECT 
    c.content,
    d.title as source_document,
    similarity
FROM public.match_chunks(
    (SELECT embedding FROM public.chunks LIMIT 1), -- using an existing embedding as test
    5,
    0.0  -- Set threshold to 0 to see all results
) m
JOIN public.chunks c ON c.id = m.id
JOIN public.documents d ON c.document_id = d.id
LIMIT 5;

-- 4. Check a sample of actual content
SELECT 
    d.title,
    c.content,
    c.embedding IS NOT NULL as has_embedding
FROM public.chunks c
JOIN public.documents d ON c.document_id = d.id
LIMIT 5; 