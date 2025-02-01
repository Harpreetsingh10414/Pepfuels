import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom'; // Import useNavigate
import './LoginForm.css'; // Reusing the same CSS as LoginForm
import '@fortawesome/fontawesome-free/css/all.min.css';
import logo from '../assets/images/logo.png'; // Assuming the same logo is used

const RegisterForm = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
  });
  const [loading, setLoading] = useState(false); // Loading state
  const [error, setError] = useState(null); // Error state
  const navigate = useNavigate(); // Use navigate for redirection

  // Handle input change
  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  // Handle form submission
  const handleSubmit = async (e) => {
    e.preventDefault(); // Prevent default form submission
    setLoading(true);
    setError(null);

    try {
      const response = await fetch('http://148.66.156.22:5001/api/auth/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      if (!response.ok) {
        throw new Error('Registration failed');
      }

      const data = await response.json();
      console.log('Registration successful:', data);

      // Redirect to login page upon successful registration
      navigate('/');
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-container"> {/* Reusing login-container */}
      <img src={logo} alt="Logo" style={{ marginBottom: '2%' }} />
      <div className="login-box">
        <div className="login-icon">
          <i className="fas fa-user-plus"></i> {/* Changed to a "user-plus" icon for registration */}
        </div>
        <h1>Register Here </h1>
        <form onSubmit={handleSubmit}>
          {/* Name input */}
          <div className="input-container">
            <input
              type="text"
              name="name"
              placeholder="Name"
              value={formData.name}
              onChange={handleChange}
              required
            />
          </div>

          {/* Email input */}
          <div className="input-container">
            <input
              type="email"
              name="email"
              placeholder="Email"
              value={formData.email}
              onChange={handleChange}
              required
            />
          </div>

          {/* Password input */}
          <div className="input-container">
            <input
              type="password"
              name="password"
              placeholder="Password"
              value={formData.password}
              onChange={handleChange}
              required
            />
          </div>

          {/* Submit button */}
          <button type="submit" className="login-button" disabled={loading}  style={{ marginBottom: '4%' }}>
            {loading ? 'Registering...' : 'Register'}
          </button>
          <a href="/" style={{ textDecoration: 'underline' }} > Admin Can Loginn </a>

          {/* Error message */}
          {error && <p className="error">{error}</p>}
        </form>
      </div>
    </div>
  );
};

export default RegisterForm;
