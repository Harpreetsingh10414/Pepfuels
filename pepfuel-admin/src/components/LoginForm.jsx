import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import API_CONFIG from "../components/config"; // Import global API config
import "./LoginForm.css";
import "@fortawesome/fontawesome-free/css/all.min.css";
import logo from "../assets/images/logo.png";

const LoginForm = () => {
  const [formData, setFormData] = useState({
    email: "",
    password: "",
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      const response = await fetch(`${API_CONFIG.BASE_URL}/auth/login`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });

      if (!response.ok) {
        throw new Error("Invalid credentials");
      }

      const data = await response.json();
      localStorage.setItem("token", data.token);
      console.log("Token stored in localStorage:", localStorage.getItem("token"));
      navigate("/dashboard");
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-container">
      <img src={logo} style={{ marginBottom: "2%" }} alt="Logo" />
      <div className="login-box">
        <div className="login-icon">
          <i className="fas fa-user-circle"></i>
        </div>
        <h1>Login Here</h1>
        <form onSubmit={handleSubmit}>
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

          <button type="submit" className="login-button" disabled={loading} style={{ marginBottom: "4%" }}>
            {loading ? "Logging in..." : "Get Started"}
          </button>
          {/* <a href="/register" style={{ textDecoration: 'underline' }}> Admin Can Register </a> */}
          {error && <p className="error">{error}</p>}
        </form>
      </div>
    </div>
  );
};

export default LoginForm;
