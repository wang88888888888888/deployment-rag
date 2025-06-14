# Approach

Please outline your approach to completing the project. Include as few or as many details as you'd like to communicate what you've done.

# 1 Base Componet:
I need to create the database for the RAG, and therefore, I need to do the three steps:
    1.1 Extract information from the PowerPoint reports from Alberta Perspectives (extract all the pdfs information from the folder named samples)
    1.2 Store the extracted informatoin in vector database for efficient retrieval
    1.3 Storing data and embeddings in Supabase
# 2 Middle Component - the API that connects the database with the frontend chat interface
    2.1 I need to utilize one of the LLM API key (I will select the OpenAI API key) so that given user's input in the frontend user-friendly chat interface, I can use the API key to create context-aware responses

# 3 Top Component - frontend user-friendly chat interface to collet user query input and transfer it to LLM  
    3.1 Build the interface with a chat option to collect the user query input
    3.2 Connect the user query input with the LLM via API key 
    3.3 Show the LLM's answer based on the personalized database to the user



# Verification steps
# 1 I need to build the database first and see if I can retrieve information. Once, after checking that information can be retrieved in the terminal, I will go ahead build the connection with the API key
    1.1 testing to be done in Supabase SQL Editor: after python -m app.database.process_documents, all the data from the pdfs are stored in supabase as embeddings
    1.2 After making sure that data are stored in the supabase, I will go ahead to perform the below # 2 step, the most important is that I have a chat entry to record the user's input so that I can pass it back to the API key and LLM can take that input and generate a context-aware/tailored answer based on the data in supabase


# 2 Once the base component and middle component, build a very simple frontend user interface to see if context-aware answers can be generated based on user's input
    2.1 Build a fucnctiong chat entry and test the frontend with npm to make sure that the interface is successfully set up
    2.2 Use flask or flask api to connect the entry in the frontend to LLM
    2.3 backend is able to be running, so does front end - INFO:     127.0.0.1:51367 - "POST /chat HTTP/1.1" 500 Internal Server Error -> solved as you can see in screenshot

    credt: cursor/ my framework to solve the problem/ structural thinking in troubleshooting with AI help

    https://github.com/wang88888888888888/tech-interview-genai-engineer/tree/jane-feng-submission


Frontend: http://localhost:3000/
- command line: npm start
Backend: http://127.0.0.1:8001/docs
- command line: uvicorn api.index:app --reload --port 8001

