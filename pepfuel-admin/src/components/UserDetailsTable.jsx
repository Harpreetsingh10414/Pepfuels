import React, { useState, useEffect } from 'react';

const UserDetailsTable = ({ token, filterText, setFilterText }) => {
  const [userData, setUserData] = useState([]); // State for user data
  const [loading, setLoading] = useState(true); // State for loading
  const [error, setError] = useState(null); // State for error

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch('http://148.66.156.22:5001/api/users', {
          headers: {
            'Authorization': `Bearer ${token}`, // Pass the token in the Authorization header
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch user data');
        }

        const data = await response.json();
        setUserData(data); // Set the fetched data to state
      } catch (err) {
        setError(err.message); // Set the error message
      } finally {
        setLoading(false); // Set loading to false
      }
    };

    fetchData();
  }, [token]); // Fetch data when token changes

  const handleFilterChange = (e) => {
    setFilterText(e.target.value.toLowerCase()); // Update filter text
  };

  // Filter data based on the name
  const filteredData = userData.filter(
    (user) => user.name.toLowerCase().includes(filterText.toLowerCase())
  );

  if (loading) return <p>Loading user data...</p>; // Display loading message
  if (error) return <p>Error: {error}</p>; // Display error message

  return (
    <div>
      <input
        type="text"
        placeholder="Filter by Name..."
        value={filterText}
        onChange={handleFilterChange} // Handle filter change
      />

      <table className="table">
        <thead>
          <tr>
            <th>User ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Company Name</th>
            <th>Logged In</th>
            <th>Created At</th>
          </tr>
        </thead>
        <tbody>
          {filteredData.map((user) => (
            <tr key={user._id}>
              <td>{user.userId}</td>
              <td>{user.name}</td>
              <td>{user.email}</td>
              <td>{user.companyName}</td>
              <td>{user.isLoggedIn ? 'Yes' : 'No'}</td>
              <td>{new Date(user.createdAt).toLocaleDateString()}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default UserDetailsTable;
