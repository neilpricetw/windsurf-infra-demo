import React, { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';

function App() {
  const [view, setView] = useState('form'); // 'form' or 'list'
  const [feedbacks, setFeedbacks] = useState([]);
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({ name: '', email: '', message: '' });
  const [submitMsg, setSubmitMsg] = useState('');

  useEffect(() => {
    if (view === 'list') {
      fetchFeedbacks();
    }
    // eslint-disable-next-line
  }, [view]);

  async function fetchFeedbacks() {
    setLoading(true);
    const { data, error } = await supabase
      .from('feedback')
      .select('*')
      .order('created_at', { ascending: false });
    if (error) {
      setSubmitMsg('Error fetching feedback.');
      setFeedbacks([]);
    } else {
      setFeedbacks(data);
      setSubmitMsg('');
    }
    setLoading(false);
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setLoading(true);
    setSubmitMsg('');
    const { name, email, message } = form;
    if (!name || !email || !message) {
      setSubmitMsg('Please fill out all fields.');
      setLoading(false);
      return;
    }
    const { error } = await supabase
      .from('feedback')
      .insert([{ name, email, message }]);
    if (error) {
      setSubmitMsg('Error submitting feedback.');
    } else {
      setSubmitMsg('Thank you for your feedback!');
      setForm({ name: '', email: '', message: '' });
    }
    setLoading(false);
  }

  return (
    <div style={{ maxWidth: 500, margin: '40px auto', fontFamily: 'sans-serif' }}>
      <h1 style={{ textAlign: 'center' }}>Travel Site Feedback</h1>
      <div style={{ display: 'flex', justifyContent: 'center', gap: 20, marginBottom: 30 }}>
        <button onClick={() => setView('form')} disabled={view === 'form'}>
          Leave Feedback
        </button>
        <button onClick={() => setView('list')} disabled={view === 'list'}>
          View Feedback
        </button>
      </div>
      {view === 'form' && (
        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 15 }}>
          <input
            type="text"
            placeholder="Your Name"
            value={form.name}
            onChange={e => setForm({ ...form, name: e.target.value })}
            required
          />
          <input
            type="email"
            placeholder="Your Email"
            value={form.email}
            onChange={e => setForm({ ...form, email: e.target.value })}
            required
          />
          <textarea
            placeholder="Your Feedback"
            value={form.message}
            onChange={e => setForm({ ...form, message: e.target.value })}
            rows={5}
            required
          />
          <button type="submit" disabled={loading}>
            {loading ? 'Submitting...' : 'Submit Feedback'}
          </button>
          {submitMsg && <div style={{ color: submitMsg.startsWith('Thank') ? 'green' : 'red' }}>{submitMsg}</div>}
        </form>
      )}
      {view === 'list' && (
        <div>
          {loading ? (
            <div>Loading feedback...</div>
          ) : feedbacks.length === 0 ? (
            <div>No feedback yet.</div>
          ) : (
            <ul style={{ listStyle: 'none', padding: 0 }}>
              {feedbacks.map(fb => (
                <li key={fb.id} style={{ border: '1px solid #ccc', borderRadius: 8, padding: 16, marginBottom: 12 }}>
                  <div style={{ fontWeight: 'bold' }}>{fb.name} <span style={{ color: '#888', fontWeight: 'normal', fontSize: 12 }}>({fb.email})</span></div>
                  <div style={{ margin: '8px 0' }}>{fb.message}</div>
                  <div style={{ fontSize: 11, color: '#888' }}>{new Date(fb.created_at).toLocaleString()}</div>
                </li>
              ))}
            </ul>
          )}
        </div>
      )}
    </div>
  );
}

export default App;
