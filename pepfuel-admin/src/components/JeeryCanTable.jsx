import React, { useState, useEffect } from "react";
import "./JeeryCanTable.css"; // Import CSS file for styling
import API_CONFIG from "../components/config"; // Import API config

const JeeryCanTable = ({ token, filterText, setFilterText }) => {
  const [jeeryCanOrders, setJeeryCanOrders] = useState([]); // State for orders
  const [loading, setLoading] = useState(true); // Loading state
  const [error, setError] = useState(null); // Error state

  useEffect(() => {
    const fetchData = async () => {
      if (!token) {
        setError("Token is missing");
        setLoading(false);
        return;
      }

      try {
        const response = await fetch(`${API_CONFIG.BASE_URL}/jerrycanorders`, {
          headers: {
            Authorization: `Bearer ${token}`, // Pass token in headers
          },
        });

        if (!response.ok) {
          throw new Error("Failed to fetch JerryCan orders");
        }

        const data = await response.json();
        setJeeryCanOrders(Array.isArray(data) ? data : []); // Ensure data is an array
      } catch (err) {
        console.error("Error fetching JerryCan orders:", err);
        setError(`Error: ${err.message}`);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [token]); // Fetch when token changes

  // Handle filter text change
  const handleFilterChange = (e) => {
    setFilterText(e.target.value.toLowerCase());
  };

  // Filter orders based on orderID or name
  const filteredOrders = jeeryCanOrders.filter(
    (order) =>
      order?.orderID?.toLowerCase().includes(filterText) ||
      order?.name?.toLowerCase().includes(filterText)
  );

  if (loading) return <p>Loading JerryCan orders...</p>;
  if (error) return <p>{error}</p>;

  return (
    <div>
      <input
        type="text"
        placeholder="Filter by Order ID or Name..."
        value={filterText}
        onChange={handleFilterChange}
      />

      {filteredOrders.length === 0 ? (
        <p>No matching JerryCan orders found.</p>
      ) : (
        <table className="table">
          <thead>
            <tr>
              <th><input type="checkbox" /></th>
              <th>Order ID</th>
              <th>Name</th>
              <th>Address</th>
              <th>Phone No</th>
              <th>Email ID</th>
              <th>Fuel Type</th>
              <th>Quantity</th>
              <th>Total Amount</th>
            </tr>
          </thead>
          <tbody>
            {filteredOrders.map((order) => (
              <tr key={order._id}>
                <td><input type="checkbox" /></td>
                <td>{order.orderID}</td>
                <td>{order.name}</td>
                <td>{order.deliveryAddress}</td>
                <td>{order.mobile}</td>
                <td>{order.email}</td>
                <td>{order.fuelType}</td>
                <td>{order.quantity}</td>
                <td>{order.totalAmount}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default JeeryCanTable;
