import React, { useState, useEffect } from "react";
import API_CONFIG from "../components/config"; // Import global API config

const BulkOrderTable = ({ token, filterText, setFilterText }) => {
  const [bulkOrders, setBulkOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(`${API_CONFIG.BASE_URL}/bulkorders`, {
          headers: {
            Authorization: `Bearer ${token}`, // Pass the token in the Authorization header
          },
        });

        if (!response.ok) {
          throw new Error("Failed to fetch bulk orders");
        }

        const data = await response.json();
        setBulkOrders(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [token]);

  const handleFilterChange = (e) => {
    setFilterText(e.target.value.toLowerCase()); // Update filter text
  };

  const filteredOrders = bulkOrders.filter(
    (order) =>
      order.orderID.toLowerCase().includes(filterText) ||
      order.name.toLowerCase().includes(filterText)
  );

  if (loading) return <p>Loading bulk orders...</p>;
  if (error) return <p>{error}</p>;

  return (
    <div>
      <input
        type="text"
        placeholder="Filter by Order ID or Name..."
        value={filterText}
        onChange={handleFilterChange} // Handle filter change
      />

      <table className="table">
        <thead>
          <tr>
            <th>
              <input type="checkbox" />
            </th>
            <th>Order ID</th>
            {/* <th>User ID</th> */}
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
              <td>
                <input type="checkbox" />
              </td>
              <td>{order.orderID}</td>
              {/* <td>{order.userID}</td> */}
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
    </div>
  );
};

export default BulkOrderTable;
