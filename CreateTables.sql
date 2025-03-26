-- 1. Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Customer', 'Staff', 'Manager', 'Admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tables Table
CREATE TABLE Tables (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    table_number INT NOT NULL UNIQUE,
    capacity INT NOT NULL CHECK(capacity > 0),
    status ENUM('Available', 'Occupied', 'Reserved') NOT NULL
);

-- 3. Reservations Table
CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    table_id INT NOT NULL,
    reservation_time TIMESTAMP NOT NULL,
    status ENUM('Pending', 'Confirmed', 'Cancelled') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES Tables(table_id) ON DELETE CASCADE
);

-- 4. Menu Categories Table
CREATE TABLE Menu_Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 5. Menu Items Table
CREATE TABLE Menu_Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK(price >= 0),
    availability ENUM('Available', 'Out of Stock') NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Menu_Categories(category_id) ON DELETE CASCADE
);

-- 6. Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    table_id INT,
    order_status ENUM('Pending', 'In Progress', 'Completed', 'Cancelled') NOT NULL,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 2) NOT NULL CHECK(total_price >= 0),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES Tables(table_id) ON DELETE SET NULL
);

-- 7. Order Items Table
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK(quantity > 0),
    subtotal_price DECIMAL(10, 2) NOT NULL CHECK(subtotal_price >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Menu_Items(item_id) ON DELETE CASCADE
);

-- 8. Online Orders & Delivery Table
CREATE TABLE Online_Orders_And_Delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    delivery_address TEXT NOT NULL,
    delivery_status ENUM('Pending', 'Out for Delivery', 'Delivered') NOT NULL,
    assigned_driver_id INT NOT NULL,
    estimated_delivery_time TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_driver_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

-- 9. Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method ENUM('Cash', 'Credit Card', 'PayPal') NOT NULL,
    payment_status ENUM('Paid', 'Pending', 'Failed') NOT NULL,
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- 10. Staff Table
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    position ENUM('Waiter', 'Chef', 'Manager', 'Delivery') NOT NULL,
    salary DECIMAL(10, 2) NOT NULL CHECK(salary >= 0),
    hire_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 11. Inventory Management Table
CREATE TABLE Inventory_Management (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL CHECK(stock_quantity >= 0),
    supplier_id INT NOT NULL,
    last_restock_date TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE
);

-- 12. Suppliers Table
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(100),
    address TEXT
);

-- 13. Reviews & Feedback Table
CREATE TABLE Reviews_And_Feedback (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_id INT,
    rating INT CHECK(rating BETWEEN 1 AND 5),
    comments TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);
