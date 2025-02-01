import React, { useState, useEffect } from "react";
import { useNavigate } from 'react-router-dom';
import "./Dashboard.css";
import '@fortawesome/fontawesome-free/css/all.min.css';
import logo from '../assets/images/logo.png';
import JeeryCanTable from './JeeryCanTable';
import BulkOrderTable from './BulkOrderTable';
import OrderTrackingTable from './OrderTrackingTable';
import UserDetailsTable from './UserDetailsTable';
import CitiesPage from './Cities'; // Import the CitiesPage component

const Dashboard = () => {
  const [activeMenu, setActiveMenu] = useState("User Details"); // Default menu item
  const [filterText, setFilterText] = useState("");
  const navigate = useNavigate();
  const [token, setToken] = useState(null);

  useEffect(() => {
    const storedToken = localStorage.getItem('token');
    if (!storedToken) {
      console.log('No token found, redirecting to login');
      navigate('/');
    } else {
      setToken(storedToken);
      console.log('Token retrieved:', storedToken);
    }
  }, [navigate]);

  const handleLogout = async () => {
    try {
      const response = await fetch('http://148.66.156.22:5001/api/auth/logout', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
        }
      });

      if (!response.ok) {
        throw new Error('Logout failed');
      }

      localStorage.removeItem('token');
      setToken(null);
      navigate('/');
    } catch (err) {
      console.error("Logout Error:", err.message);
    }
  };

  const handleMenuClick = (menu) => {
    setActiveMenu(menu);
    setFilterText("");
  };

  const handleFilterChange = (e) => {
    setFilterText(e.target.value.toLowerCase());
  };

  const jeeryCanData = [
    // Sample data
  ];

  const bulkOrderData = [
    // Sample data
  ];

  const orderTrackingData = [
    // Sample data
  ];

  const userDetailsData = [
    // Sample data
  ];

  return (
    <div className="dashboard-container">
      <nav className="sidebar">
        <div className="sidebar-logo">
          <img src={logo} style={{ width: "100%" }} alt="Logo" />
        </div>
        <ul className="sidebar-menu">
          <li className={`menu-item ${activeMenu === "User Details" ? "active" : ""}`} onClick={() => handleMenuClick("User Details")}>
            User Details
          </li>
          <li className={`menu-item ${activeMenu === "Jeery Can" ? "active" : ""}`} onClick={() => handleMenuClick("Jeery Can")}>
            Jeery Can
          </li>
          <li className={`menu-item ${activeMenu === "Bulk Order" ? "active" : ""}`} onClick={() => handleMenuClick("Bulk Order")}>
            Bulk Order
          </li>
          <li className={`menu-item ${activeMenu === "Order Tracking" ? "active" : ""}`} onClick={() => handleMenuClick("Order Tracking")}>
            Order Tracking
          </li>
          <li className={`menu-item ${activeMenu === "Cities" ? "active" : ""}`} onClick={() => handleMenuClick("Cities")}>
            Cities
          </li>
        </ul>
      </nav>
      <main className="main-content">
        <header className="header">
          <h2 className="page-title">{activeMenu} Table</h2>
          <button className="logout-button"  style={{backgroundColor:"#892d7c", padding:'16px 40px', color:'white', border:'none', borderRadius:'8px'}} onClick={handleLogout}>
            Logout
          </button>
        </header>
      
        <div className="table-container">
          {activeMenu === "Jeery Can" ? (
            <JeeryCanTable
              token={token}
              filterText={filterText}
              setFilterText={setFilterText}
            />
          ) : activeMenu === "Bulk Order" ? (
            <BulkOrderTable data={bulkOrderData} filterText={filterText} setFilterText={setFilterText} />
          ) : activeMenu === "Order Tracking" ? (
            <OrderTrackingTable data={orderTrackingData} filterText={filterText} setFilterText={setFilterText} />
          ) : activeMenu === "User Details" ? (
            <UserDetailsTable data={userDetailsData} filterText={filterText} setFilterText={setFilterText} />
          ) : activeMenu === "Cities" ? (
            <CitiesPage />
          ) : null}
        </div>
      </main>
    </div>
  );
};

export default Dashboard;
