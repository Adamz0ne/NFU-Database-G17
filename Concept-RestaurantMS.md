# Restaurant Management System

Managing restaurant operations efficiently, including but not limited to  

`Users`, `Tables`, `Reservations`, `Menu Categories`, `Menu Items`, `Orders`,  
`Order Items`, `Online Orders & Delivery`, `Payments`, `Staff`, `Inventory Management`,  
`Suppliers`, and `Reviews & Feedback`.

## 1. Users

- `user_id` (PK)
- `first_name`, `last_name`
- `email`, `phone_number`
- `password_hash`
- `role` (Customer, Staff, Manager, Admin)
- `created_at`

## 2. Tables

- `table_id` (PK)
- `table_number`
- `capacity`
- `status` (Available, Occupied, Reserved)

## 3. Reservations

- `reservation_id` (PK)
- `user_id` (FK → Users)
- `table_id` (FK → Tables)
- `reservation_time`
- `status` (Pending, Confirmed, Cancelled)

## 4. Menu Categories

- `category_id` (PK)
- `category_name`

## 5. Menu Items

- `item_id` (PK)
- `category_id` (FK → Menu Categories)
- `item_name`
- `description`
- `price`
- `availability` (Available, Out of Stock)

## 6. Orders

- `order_id` (PK)
- `user_id` (FK → Users)
- `table_id` (FK → Tables, nullable for online orders)
- `order_status` (Pending, In Progress, Completed, Cancelled)
- `order_time`
- `total_price`

## 7. Order Items

- `order_item_id` (PK)
- `order_id` (FK → Orders)
- `item_id` (FK → Menu Items)
- `quantity`
- `subtotal_price`

## 8. Online Orders & Delivery

- `delivery_id` (PK)
- `order_id` (FK → Orders)
- `delivery_address`
- `delivery_status` (Pending, Out for Delivery, Delivered)
- `assigned_driver_id` (FK → Staff)
- `estimated_delivery_time`

## 9. Payments

- `payment_id` (PK)
- `order_id` (FK → Orders)
- `payment_method` (Cash, Credit Card, PayPal, etc.)
- `payment_status` (Paid, Pending, Failed)
- `payment_time`

## 10. Staff

- `staff_id` (PK)
- `user_id` (FK → Users)
- `position` (Waiter, Chef, Manager, Delivery)
- `salary`
- `hire_date`

## 11. Inventory Management

- `inventory_id` (PK)
- `item_name`
- `stock_quantity`
- `supplier_id` (FK → Suppliers)
- `last_restock_date`

## 12. Suppliers

- `supplier_id` (PK)
- `supplier_name`
- `contact_info`
- `address`

## 13. Reviews & Feedback

- `review_id` (PK)
- `user_id` (FK → Users)
- `order_id` (FK → Orders, nullable)
- `rating` (1-5)
- `comments`
- `review_date`
