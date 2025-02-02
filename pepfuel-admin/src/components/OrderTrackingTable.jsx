import React, { useState, useEffect } from 'react';
import { Table, Button, Modal, Form, Input, DatePicker, notification } from 'antd';
import moment from 'moment';

const { Column } = Table;
const { TextArea } = Input;

const OrderTrackingTable = () => {
    const [data, setData] = useState([]);
    const [isModalVisible, setIsModalVisible] = useState(false);
    const [isEditing, setIsEditing] = useState(false);
    const [currentOrder, setCurrentOrder] = useState(null);
    const [form] = Form.useForm();

    useEffect(() => {
        const fetchData = async () => {
            try {
                const token = localStorage.getItem('token');
                if (!token) throw new Error('Token is missing');

                const response = await fetch('http://148.66.156.22:5001/api/ordertracking/all', {
                    headers: {
                        'Authorization': `Bearer ${token}`,
                    },
                });

                if (!response.ok) {
                    throw new Error(`Failed to fetch data: ${response.statusText}`);
                }

                const result = await response.json();
                setData(result);
            } catch (err) {
                console.error('Failed to fetch data:', err);
                notification.error({ message: 'Fetch Error', description: err.message });
            }
        };

        fetchData();
    }, []);

    const handleAdd = () => {
        setIsEditing(false);
        setCurrentOrder(null);
        form.resetFields();
        setIsModalVisible(true);
    };

    const handleEdit = (record) => {
        setIsEditing(true);
        setCurrentOrder(record);
        form.setFieldsValue({
            ...record,
            deliveryDate: moment(record.deliveryDate),
        });
        setIsModalVisible(true);
    };

    const handleDelete = async (orderID) => {
        try {
            const token = localStorage.getItem('token');
            if (!token) throw new Error('Token is missing');

            const response = await fetch(`http://148.66.156.22:5001/api/ordertracking/${orderID}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${token}`,
                },
            });

            if (!response.ok) {
                throw new Error(`Failed to delete data: ${response.statusText}`);
            }

            setData(prevData => prevData.filter(order => order.orderID !== orderID));
            notification.success({ message: 'Order deleted successfully' });
        } catch (err) {
            console.error('Failed to delete data:', err);
            notification.error({ message: 'Delete Error', description: err.message });
        }
    };

    const handleSubmit = async (values) => {
        const url = isEditing
            ? `http://148.66.156.22:5001/api/ordertracking/${currentOrder.orderID}`
            : 'http://148.66.156.22:5001/api/ordertracking';
        const method = isEditing ? 'PUT' : 'POST';

        try {
            const token = localStorage.getItem('token');
            if (!token) throw new Error('Token is missing');

            const response = await fetch(url, {
                method,
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`,
                },
                body: JSON.stringify({
                    ...values,
                    deliveryDate: values.deliveryDate.toISOString(),
                }),
            });

            if (!response.ok) {
                throw new Error(`Failed to submit data: ${response.statusText}`);
            }

            const result = await response.json();
            if (isEditing) {
                setData(prevData => prevData.map(order =>
                    order.orderID === result.orderID ? result : order
                ));
            } else {
                setData(prevData => [...prevData, result]);
            }

            setIsModalVisible(false);
            notification.success({ message: `Order ${isEditing ? 'updated' : 'added'} successfully` });
        } catch (err) {
            console.error('Failed to submit data:', err);
            notification.error({ message: 'Submit Error', description: err.message });
        }
    };

    return (
        <div>
            <Button type="primary" onClick={handleAdd} style={{ marginBottom: 16 }}>
                Add New
            </Button>
            <Table dataSource={data} rowKey="orderID">
                <Column title="Order ID" dataIndex="orderID" key="orderID" />
                <Column title="Status" dataIndex="status" key="status" />
                <Column title="Estimated Delivery" dataIndex="deliveryDate" key="deliveryDate" render={date => new Date(date).toLocaleDateString()} />
                <Column title="Fuel Type" dataIndex="fuelType" key="fuelType" />
                <Column title="Quantity" dataIndex="quantity" key="quantity" />
                <Column title="Total Amount" dataIndex="totalAmount" key="totalAmount" />
                <Column title="Amount" dataIndex="amount" key="amount" />
                <Column title="tracking Details" dataIndex="trackingDetails" key="trackingDetails" />

                <Column
                    title="Actions"
                    key="actions"
                    render={(text, record) => (
                        <>
                            <Button type="link" onClick={() => handleEdit(record)}>Edit</Button>
                            {/* <Button type="link" danger onClick={() => handleDelete(record.orderID)}>Delete</Button> */}
                        </>
                    )}
                />
            </Table>

            <Modal
                title={isEditing ? 'Edit Order Tracking' : 'Add Order Tracking'}
                visible={isModalVisible}
                onCancel={() => setIsModalVisible(false)}
                footer={null}
            >
                <Form
                    form={form}
                    layout="vertical"
                    onFinish={handleSubmit}
                    initialValues={isEditing ? currentOrder : {}}
                >
                    <Form.Item
                        name="orderID"
                        label="Order ID"
                        rules={[{ required: true, message: 'Please input the order ID!' }]}
                    >
                        <Input disabled={isEditing} />
                    </Form.Item>
                    <Form.Item
                        name="userID"
                        label="User ID"
                        rules={[{ required: true, message: 'Please input the user ID!' }]}
                    >
                        <Input />
                    </Form.Item>
                    <Form.Item
                        name="status"
                        label="Status"
                        rules={[{ required: true, message: 'Please input the status!' }]}
                    >
                        <Input />
                    </Form.Item>
                    <Form.Item
                        name="deliveryDate"
                        label="Delivery Date"
                        rules={[{ required: true, message: 'Please select the delivery date!' }]}
                    >
                        <DatePicker showTime format="YYYY-MM-DD HH:mm:ss" />
                    </Form.Item>
                    <Form.Item
                        name="trackingDetails"
                        label="Tracking Details"
                    >
                        <TextArea rows={4} />
                    </Form.Item>
                    <Form.Item
                        name="deliveryAddress"
                        label="Delivery Address"
                    >
                        <Input />
                    </Form.Item>
                    <Form.Item
                        name="fuelType"
                        label="Fuel Type"
                    >
                        <Input />
                    </Form.Item>
                    <Form.Item
                        name="quantity"
                        label="Quantity"
                    // rules={[{ type: 'number',  message: 'Quantity must be a positive number!' }]}
                    >
                        <Input type="number" />
                    </Form.Item>
                    <Form.Item
                        name="totalAmount"
                        label="Total Amount"
                    // rules={[{ type: 'number',   message: 'Total Amount must be a positive number!' }]}
                    >
                        <Input type="number" />
                    </Form.Item>
                    <Form.Item
                        name="amount"
                        label="Amount"
                    // rules={[{ type: 'number',   message: 'Amount must be a positive number!' }]}
                    >
                        <Input type="number" />
                    </Form.Item>
                    <Form.Item>
                        <Button type="primary" htmlType="submit">
                            {isEditing ? 'Update' : 'Add'}
                        </Button>
                    </Form.Item>
                </Form>
            </Modal>
        </div>
    );
};

export default OrderTrackingTable;
