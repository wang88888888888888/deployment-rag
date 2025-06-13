import React from 'react';
import './ChatInput.css';

const ChatInput = ({ value, onChange, onSubmit }) => {
  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      onSubmit();
    }
  };

  return (
    <div className="chat-input-container">
      <span className="search-icon">🔍</span>
      <input
        className="chat-input"
        type="text"
        placeholder="Ask me anything about Alberta's business landscape..."
        value={value}
        onChange={e => onChange(e.target.value)}
        onKeyDown={handleKeyDown}
      />
      <button className="chat-submit" onClick={onSubmit}>Ask</button>
    </div>
  );
};

export default ChatInput; 