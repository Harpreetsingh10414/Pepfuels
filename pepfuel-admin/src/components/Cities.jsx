import React, { useState, useEffect } from 'react';
import { Table, Button, Form, Input, notification } from 'antd';
import 'antd/dist/reset.css'; // Import Ant Design styles

const CitiesPage = () => {
  const [cityName, setCityName] = useState('');
  const [dieselPrice, setDieselPrice] = useState('');
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(null);
  const [token, setToken] = useState(null);
  const [cities, setCities] = useState([]);
  const [editCity, setEditCity] = useState(null);
  const [form] = Form.useForm();

  useEffect(() => {
    // Retrieve the token from localStorage
    const storedToken = localStorage.getItem('token');
    if (storedToken) {
      setToken(storedToken);
      fetchCities(storedToken);
    } else {
      setError('No token found. Please log in.');
    }
  }, []);

  const fetchCities = async (token) => {
    try {
      const response = await fetch('http://148.66.156.22:5001/api/cities', {
        headers: {
          'Authorization': `Bearer ${token}`, // Include the token in the request headers
        },
      });

      if (!response.ok) {
        throw new Error('Failed to fetch cities');
      }

      const data = await response.json();
      setCities(data);
    } catch (err) {
      setError(`Error: ${err.message}`);
    }
  };

  const handleSubmit = async (values) => {
    const url = editCity ? `http://148.66.156.22:5001/api/cities/${editCity._id}` : 'http://148.66.156.22:5001/api/cities';
    const method = editCity ? 'PUT' : 'POST';

    try {
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`, // Include the token in the request headers
        },
        body: JSON.stringify({
          name: values.cityName,
          dieselPrice: parseFloat(values.dieselPrice),
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to submit city');
      }

      const data = await response.json();
      setSuccess(editCity ? 'City updated successfully!' : 'City submitted successfully!');
      setCityName('');
      setDieselPrice('');
      setEditCity(null);
      form.resetFields();
      fetchCities(token);
    } catch (err) {
      setError(`Error: ${err.message}`);
    }
  };

  const handleEdit = (city) => {
    form.setFieldsValue({
      cityName: city.name,
      dieselPrice: city.dieselPrice,
    });
    setEditCity(city);
  };

  const handleDelete = async (cityId) => {
    if (!token) {
      setError('Token is missing');
      return;
    }

    try {
      const response = await fetch(`http://148.66.156.22:5001/api/cities/${cityId}`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`,
        },
      });

      if (!response.ok) {
        throw new Error('Failed to delete city');
      }

      setSuccess('City deleted successfully!');
      fetchCities(token);
    } catch (err) {
      setError(`Error: ${err.message}`);
    }
  };

  const columns = [
    {
      title: 'City Name',
      dataIndex: 'name',
      key: 'name',
    },
    {
      title: 'Diesel Price',
      dataIndex: 'dieselPrice',
      key: 'dieselPrice',
    },
    {
      title: 'Actions',
      key: 'actions',
      render: (text, record) => (
        <>
          <Button type="link" onClick={() => handleEdit(record)}>Edit</Button>
          {/* <Button type="link" danger onClick={() => handleDelete(record._id)}>Delete</Button> */}
        </>
      ),
    },
  ];

  return (
    <div className="cities-page">
      <h2>{editCity ? 'Edit City' : 'Submit City'}</h2>
      <Form
        form={form}
        layout="vertical"
        onFinish={handleSubmit}
        initialValues={editCity ? { cityName: editCity.name, dieselPrice: editCity.dieselPrice } : {}}
      >
        <Form.Item
          name="cityName"
          label="City Name"
          rules={[{ required: true, message: 'Please input the city name!' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="dieselPrice"
          label="Diesel Price"
          rules={[{ required: true, message: 'Please input the diesel price!' }]}
        >
          <Input type="number" step="0.01" />
        </Form.Item>
        <Form.Item>
          <Button type="primary" htmlType="submit">
            {editCity ? 'Update' : 'Submit'}
          </Button>
        </Form.Item>
      </Form>
      {error && <p className="error">{error}</p>}
      {success && <p className="success">{success}</p>}

      <h2>Cities List</h2>
      <Table dataSource={cities} columns={columns} rowKey="_id" />
    </div>
  );
};

export default CitiesPage;
