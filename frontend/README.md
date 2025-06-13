# Alberta Perspectives Chatbot Frontend

This is a React-based frontend for the Alberta Perspectives RAG chatbot system.

## Features
- Clean, modern UI inspired by AlbertaPerspectives.ca
- Central input for user questions
- Display area for AI answers
- Example questions as clickable suggestions
- Ready to connect to a backend API (Flask/FastAPI)

## Getting Started

1. Install dependencies:
   ```bash
   npm install
   ```
2. Start the development server:
   ```bash
   npm start
   ```

The app will run at [http://localhost:3000](http://localhost:3000).

## Structure
- `src/components/ChatInput.js` — User input box
- `src/components/ChatResponse.js` — AI answer display
- `src/components/ExampleQuestions.js` — Example question suggestions

## Next Steps
- Connect to your backend API for context-aware answers. 