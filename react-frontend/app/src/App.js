import React, { useState, useEffect, useRef } from 'react';
import { supabase } from './supabaseClient';

const TRAVEL_IMAGES = [
  'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1465156799763-2c087c332922?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1454023492550-5696f8ff10e1?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
  'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=1200&q=80',
];

function App() {
  const [view, setView] = useState('form'); // 'form' or 'list'
  const [feedbacks, setFeedbacks] = useState([]);
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({ name: '', email: '', message: '' });
  const [errors, setErrors] = useState({});
  const [submitMsg, setSubmitMsg] = useState('');

  useEffect(() => {
    if (view === 'list') {
      fetchFeedbacks();
    }
    // eslint-disable-next-line
  }, [view]);

  function validate() {
    const errs = {};
    if (!form.name.trim()) errs.name = 'Name is required.';
    if (!form.email.trim()) {
      errs.email = 'Email is required.';
    } else if (!/^\S+@\S+\.\S+$/.test(form.email)) {
      errs.email = 'Invalid email address.';
    }
    if (!form.message.trim()) {
      errs.message = 'Feedback is required.';
    } else if (form.message.length < 10) {
      errs.message = 'Feedback must be at least 10 characters.';
    }
    return errs;
  }

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
    setErrors({});
    setSubmitMsg('');
    const validationErrors = validate();
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      return;
    }
    setLoading(true);
    const { name, email, message } = form;
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
    <div className="container py-4" style={{ maxWidth: 600, background: '#f8fafc', borderRadius: 16, boxShadow: '0 4px 24px #0001', marginTop: 40 }}>
      <div className="text-center mb-4">
        <DynamicTravelImage />
        <h1 className="display-5 fw-bold" style={{ color: '#0069d9' }}>Travel Site Feedback</h1>
        <p className="lead">Share your experience or browse what other travelers have said!</p>
        <div className="btn-group mt-2">
          <button className={`btn btn-primary${view === 'form' ? ' active' : ''}`} onClick={() => setView('form')} disabled={view === 'form'}>
            Leave Feedback
          </button>
          <button className={`btn btn-outline-primary${view === 'list' ? ' active' : ''}`} onClick={() => setView('list')} disabled={view === 'list'}>
            View Feedback
          </button>
        </div>
      </div>
      {view === 'form' && (
        <form onSubmit={handleSubmit} className="bg-white p-4 rounded shadow-sm border">
          <div className="mb-3">
            <label className="form-label">Name</label>
            <input
              type="text"
              className={`form-control${errors.name ? ' is-invalid' : ''}`}
              placeholder="Your Name"
              value={form.name}
              onChange={e => setForm({ ...form, name: e.target.value })}
              disabled={loading}
            />
            {errors.name && <div className="invalid-feedback">{errors.name}</div>}
          </div>
          <div className="mb-3">
            <label className="form-label">Email</label>
            <input
              type="email"
              className={`form-control${errors.email ? ' is-invalid' : ''}`}
              placeholder="Your Email"
              value={form.email}
              onChange={e => setForm({ ...form, email: e.target.value })}
              disabled={loading}
            />
            {errors.email && <div className="invalid-feedback">{errors.email}</div>}
          </div>
          <div className="mb-3">
            <label className="form-label">Feedback</label>
            <textarea
              className={`form-control${errors.message ? ' is-invalid' : ''}`}
              placeholder="Your Feedback"
              value={form.message}
              onChange={e => setForm({ ...form, message: e.target.value })}
              rows={5}
              disabled={loading}
            />
            {errors.message && <div className="invalid-feedback">{errors.message}</div>}
          </div>
          <button type="submit" className="btn btn-success w-100" disabled={loading}>
            {loading ? 'Submitting...' : 'Submit Feedback'}
          </button>
          {submitMsg && <div className={`mt-3 fw-bold ${submitMsg.startsWith('Thank') ? 'text-success' : 'text-danger'}`}>{submitMsg}</div>}
        </form>
      )}
      {view === 'list' && (
        <div className="mt-3">
          {loading ? (
            <div className="text-center py-4"><div className="spinner-border text-primary" role="status"><span className="visually-hidden">Loading...</span></div></div>
          ) : feedbacks.length === 0 ? (
            <div className="alert alert-info text-center">No feedback yet.</div>
          ) : (
            <div className="row g-3">
              {feedbacks.map(fb => (
                <div key={fb.id} className="col-12">
                  <div className="card shadow-sm border-primary">
                    <div className="card-body">
                      <div className="d-flex justify-content-between align-items-center mb-2">
                        <div className="fw-bold text-primary">{fb.name}</div>
                        <div className="text-muted small">{fb.email}</div>
                      </div>
                      <div className="mb-2">{fb.message}</div>
                      <div className="text-end text-secondary" style={{ fontSize: 12 }}>{new Date(fb.created_at).toLocaleString()}</div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

// Dynamic travel image component
function DynamicTravelImage() {
  const [idx, setIdx] = useState(0);
  const intervalRef = useRef();

  useEffect(() => {
    intervalRef.current = setInterval(() => {
      setIdx((i) => (i + 1) % TRAVEL_IMAGES.length);
    }, 5000);
    return () => clearInterval(intervalRef.current);
  }, []);

  return (
    <img
      src={TRAVEL_IMAGES[idx]}
      alt="Travel"
      className="img-fluid rounded mb-3"
      style={{
        width: '100%',
        maxHeight: 340,
        minHeight: 160,
        objectFit: 'cover',
        boxShadow: '0 4px 24px #0003',
        transition: 'opacity 0.8s',
      }}
    />
  );
}

export default App;
