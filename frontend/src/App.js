import React, { useState } from 'react';
import './App.css';
import ChatInput from './components/ChatInput';

function App() {
  const [question, setQuestion] = useState('');
  const [submittedQuestion, setSubmittedQuestion] = useState('');
  const [answer, setAnswer] = useState('');
  const [loading, setLoading] = useState(false);

  const handleInputChange = (value) => {
    setQuestion(value);
  };

  const handleSubmit = async () => {
    if (question.trim() !== '') {
      setSubmittedQuestion(question);
      setLoading(true);
      setAnswer('');
      // Call backend API
      try {
        const apiUrl = process.env.REACT_APP_API_URL || 'http://localhost:8001';
        const response = await fetch(`${apiUrl}/chat`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ question }),
        });
        const data = await response.json();
        setAnswer(data.answer);
      } catch (err) {
        setAnswer('Error connecting to backend.');
      }
      setLoading(false);
      setQuestion('');
    }
  };

  return (
    <div className="App" style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center', background: '#f8fafc' }}>
      <h1 style={{ fontWeight: 700, fontSize: '2.5rem', marginBottom: 0 }}>Your voice for <span style={{ color: '#1766b3' }}>business growth</span></h1>
      <p style={{ color: '#555', fontSize: '1.2rem', marginTop: 8, marginBottom: 32 }}>AI-powered insights that shape Alberta's business policies and help remove barriers to growth</p>
      <div style={{ width: '100%', maxWidth: 600 }}>
        <ChatInput value={question} onChange={handleInputChange} onSubmit={handleSubmit} />
      </div>
      {submittedQuestion && (
        <div style={{ marginTop: 32, background: '#fff', borderRadius: 8, boxShadow: '0 2px 8px rgba(0,0,0,0.05)', padding: 24, minWidth: 320 }}>
          <strong>Your question:</strong>
          <div style={{ marginTop: 8 }}>{submittedQuestion}</div>
          {loading && <div style={{ marginTop: 16 }}>Loading...</div>}
          {answer && <div style={{ marginTop: 16 }}><strong>Answer:</strong> {answer}</div>}
        </div>
      )}
    </div>
  );
}

export default App;