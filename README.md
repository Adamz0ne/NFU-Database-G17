# 餐廳管理系統(RMS)
提供一個平台處理各項餐廳管理，如訂位、點餐、會員、倉儲管理等...。

## 應用情境
  現代社會的人們更重視服務的效率與便利性，而我們為了提升顧客整體用餐體驗，同時簡化繁瑣的內部營運流程，決定製作一套全方位餐廳管理系統。這是一個完整的餐廳管理系統，適用於中小型餐廳或連鎖餐飲業者，整合了顧客管理、訂位訂餐、庫存管理、員工排班與財務記錄等功能。系統將幫助餐廳實現數位化轉型，提升營運效率與顧客服務品質。

## 使用案例
  - 顧客
    - 註冊與登入
    - 線上預約座位
    - 瀏覽菜單並點餐
    - 線上訂單與外送
    - 付款與結帳
  - 員工
    - 登入系統與身份辨識
    - 查看訂位與訂單資訊
    - 接收廚房點餐通知  
    - 打卡上下班與出勤記錄
  - 管理員
    - 使用者與員工管理
    - 庫存與進貨管理
    - 查看營運報表
    
## 系統需求說明
  - 庫存預警:即時監控庫存數量，當庫存低於安全存量時自動觸發預警
  - 今日訂單總覽:即時顯示當日所有訂單狀態的綜合儀表
  - 菜單總覽:顯示所有菜單
  - 熱門菜單項目:分析並顯示最受歡迎的餐點項目
  - 每月銷售報表:完整呈現月度銷售績效的綜合報表
  - 待處理訂位:集中管理所有訂位請求
  - 員工月出勤時數:計算並分析員工每月工作時數
  - 待處理訂單:廚房與外場協同作業的訂單處理中心

## ER圖
  ![image](https://github.com/user-attachments/assets/2993b695-3f8d-4c39-80b6-0c6e55dff029)

## Schema
  ### Users
      CREATE TABLE Users (
         user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
         name VARCHAR(100) NOT NULL,
         email VARCHAR(100) UNIQUE,
         phone_number VARCHAR(10) NOT NULL CHECK (phone_number LIKE '09________'),
         role ENUM('Customer', 'Staff ', 'Admin') NOT NULL,
         created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
         PRIMARY KEY (user_id)
      );
    
  ### Accounts
      CREATE TABLE Accounts (
        account_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        user_id INT UNSIGNED NOT NULL,
        username VARCHAR(100) NOT NULL UNIQUE,
        password VARCHAR(64) NOT NULL,
        PRIMARY KEY (account_id),
        FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
    );
    
  ### Tables
      CREATE TABLE Tables (
        table_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        table_number INT UNSIGNED NOT NULL CHECK (table_number > 0 AND table_number <= 100),
        capacity INT UNSIGNED NOT NULL CHECK (capacity > 0 AND capacity <= 100),
        status ENUM('Available', 'Occupied', 'Reserved') NOT NULL,
        PRIMARY KEY (table_id)
      );

  ### Reservations
      CREATE TABLE Reservations (
        reservation_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        user_id INT UNSIGNED NOT NULL,
        table_id INT UNSIGNED NOT NULL,
        reservation_time DATETIME NOT NULL,
        status ENUM('Pending', 'Confirmed', 'Cancelled') NOT NULL,
        PRIMARY KEY (reservation_id),
        FOREIGN KEY (user_id) REFERENCES Users(user_id),
        FOREIGN KEY (table_id) REFERENCES Tables(table_id)
      );

  ### Menu_Categories
      CREATE TABLE Menu_Categories (
        category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        category_name VARCHAR(100) NOT NULL,
        PRIMARY KEY (category_id)
      );

  ### Menu_Items
      CREATE TABLE Menu_Items (
        item_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        category_id INT UNSIGNED NOT NULL,
        item_name VARCHAR(20) NOT NULL,
        description VARCHAR(100),
        price INT UNSIGNED NOT NULL CHECK (price > 0),
        availability ENUM('Available', 'Out of Stock') NOT NULL,
        PRIMARY KEY (item_id),
        FOREIGN KEY (category_id) REFERENCES Menu_Categories(category_id)
      );

  ### Orders
      CREATE TABLE Orders (
        order_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        user_id INT UNSIGNED NOT NULL,
        table_id INT UNSIGNED NOT NULL,
        order_status ENUM('Pending', 'In Progress', 'Completed', 'Cancelled') NOT NULL,
        order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        total_price INT UNSIGNED NOT NULL CHECK (total_price >= 0),
        PRIMARY KEY (order_id),
        FOREIGN KEY (user_id) REFERENCES Users(user_id),
        FOREIGN KEY (table_id) REFERENCES Tables(table_id)
      );

  ### Order_Items
      CREATE TABLE Order_Items (
        order_item_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        order_id INT UNSIGNED NOT NULL,
        item_id INT UNSIGNED NOT NULL,
        quantity INT UNSIGNED NOT NULL CHECK (quantity > 0),
        PRIMARY KEY (order_item_id),
        FOREIGN KEY (order_id) REFERENCES Orders(order_id),
        FOREIGN KEY (item_id) REFERENCES Menu_Items(item_id)
      );

  ### Payments
      CREATE TABLE Payments (
        payment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        order_id INT UNSIGNED NOT NULL,
        payment_method ENUM('Cash', 'Credit Card', 'online payment') NOT NULL,
        payment_status ENUM('Paid', 'Pending', 'Failed') NOT NULL,
        payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (payment_id),
        FOREIGN KEY (order_id) REFERENCES Orders(order_id)
      );

  ### Staff
      CREATE TABLE Staff (
        staff_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        user_id INT UNSIGNED NOT NULL,
        position ENUM('Waiter', 'Chef', 'Manager') NOT NULL,
        salary INT NOT NULL CHECK (salary > 0),
        hire_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (staff_id),
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
      );

  ### Attendance
      CREATE TABLE Attendance (
        attendance_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        staff_id INT UNSIGNED NOT NULL,
        check_in_time TIMESTAMP NOT NULL,
        check_out_time TIMESTAMP NOT NULL,
        PRIMARY KEY (attendance_id),
        FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
      );

  ### Supliers
      CREATE TABLE Suppliers (
        supplier_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        supplier_name VARCHAR(100) NOT NULL,
        contact_info VARCHAR(100),
        address VARCHAR(100),
        PRIMARY KEY (supplier_id)
      );

  ### Inventoriy
      CREATE TABLE Inventory (
        inventory_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        item_name VARCHAR(100) NOT NULL,
        stock_quantity INT UNSIGNED NOT NULL CHECK (stock_quantity >= 0),
        supplier_id INT UNSIGNED NOT NULL,
        last_check_time TIMESTAMP,
        last_checker INT UNSIGNED,
        PRIMARY KEY (inventory_id),
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
        FOREIGN KEY (last_checker_staff_id) REFERENCES Staff(staff_id)
      );

## 完整性限制
### Users (使用者)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| user_id         | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| name            | VARCHAR(100)                | NOT NULL   | 最多 100 字元，超過無法儲存                                              |
| email           | VARCHAR(100)                | NOT NULL   | 最多 100 字元，唯一，需含 @，超過無法儲存                                |
| phone_number    | VARCHAR(10)                 | NOT NULL   | 10 字元，前兩位為 '09'，後八位為 00000000 至 99999999，例：0912345678    |
| role            | ENUM('Customer', 'Staff', 'Admin') | NOT NULL   | 限定為 Customer、Staff、Admin                                             |
| created_time    | TIMESTAMP                   | NOT NULL   | 預設為系統目前時間（CURRENT_TIMESTAMP）                                    |

### Accounts (帳號)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| account_id      | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| user_id         | INT UNSIGNED                | NOT NULL   | 參照 Users(user_id)，刪除時級聯刪除                                       |
| username        | VARCHAR(100)                | NOT NULL   | 唯一，最多 100 字元，系統強制檢查                                         |
| password        | VARCHAR(64)                 | NOT NULL   | SHA-256 加密，255 字元英數組合，避免明文儲存                              |

### Reservations (訂位)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| reservation_id  | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| user_id         | INT UNSIGNED                | NOT NULL   | 參照 Users(user_id)                                                       |
| table_id        | INT UNSIGNED                | NOT NULL   | 參照 Tables(table_id)                                                     |
| reservation_time| DATETIME                    | NOT NULL   | 格式 YYYY-MM-DD HH:MM:SS                                                  |

### Menu_Categories (菜單類別)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| category_id     | ENUM('Pending', 'Confirmed', 'Cancelled') | NOT NULL   | 限定為 Pending、Confirmed、Cancelled                                      |
| category_name   | VARCHAR(100)                | NOT NULL   | 最多 100 字元，超過無法儲存                                              |

### Menu_Items (菜單品項)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| item_id         | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| category_id     | INT UNSIGNED                | NOT NULL   | 參照 Menu_Categories(category_id)                                         |
| item_name       | VARCHAR(20)                 | NOT NULL   | 最多 20 字元，超過無法儲存                                               |
| description     | VARCHAR(100)                | YES        | 最多 100 字元，超過無法儲存                                              |
| price           | INT UNSIGNED                | NOT NULL   | 必須大於 0                                                               |
| availability    | ENUM('Available', 'Out of Stock') | NOT NULL   | 限定為 Available、Out of Stock                                            |

### Orders (訂單)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| order_id        | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| user_id         | INT UNSIGNED                | NOT NULL   | 參照 Users(user_id)                                                       |
| table_id        | INT UNSIGNED                | NOT NULL   | 參照 Tables(table_id)                                                     |
| order_status    | ENUM('Pending', 'InProgress', 'Completed', 'Cancelled') | NOT NULL   | 限定為 Pending、InProgress、Completed、Cancelled                          |
| order_time      | TIMESTAMP                   | NOT NULL   | 預設為系統目前時間（CURRENT_TIMESTAMP）                                    |
| total_price     | INT UNSIGNED                | NOT NULL   | 不得為負                                                                 |

### Order_Items (訂單品項)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| order_item_id   | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| order_id        | INT UNSIGNED                | NOT NULL   | 參照 Orders(order_id)                                                     |
| item_id         | INT UNSIGNED                | NOT NULL   | 參照 Menu_Items(item_id)                                                  |
| quantity        | INT UNSIGNED                | NOT NULL   | 必須大於 0                                                               |

### Payments (付款方式)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| payment_id      | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| order_id        | INT UNSIGNED                | NOT NULL   | 參照 Orders(order_id)                                                     |
| payment_method  | ENUM('Cash', 'Credit Card', 'online payment') | NOT NULL   | 限定為 Cash、Credit Card、online payment                                  |
| payment_status  | ENUM('Paid', 'Pending', 'Failed') | NOT NULL   | 限定為 Paid、Pending、Failed                                              |
| payment_time    | TIMESTAMP                   | NOT NULL   | 預設為系統目前時間（CURRENT_TIMESTAMP）                                    |

### Staff (員工)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| staff_id        | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| user_id         | INT UNSIGNED                | NOT NULL   | 參照 Users(user_id)                                                       |
| position        | ENUM('Waiter', 'Chef', 'Manager') | NOT NULL   | 限定為 Waiter、Chef、Manager                                              |
| salary          | INT UNSIGNED                | NOT NULL   | 必須大於 0                                                               |
| hire_date       | TIMESTAMP                   | NOT NULL   | 預設為系統目前時間（CURRENT_TIMESTAMP）                                    |

### Attendance (出席)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| attendance_id   | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| staff_id        | INT UNSIGNED                | NOT NULL   | 參照 Staff(staff_id)                                                      |
| check_in_time   | TIMESTAMP                   | NOT NULL   | 格式 YYYY-MM-DD HH:MM:SS                                                  |
| check_out_time  | TIMESTAMP                   | NOT NULL   | 格式 YYYY-MM-DD HH:MM:SS                                                  |

### Suppliers (供應者)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| supplier_id     | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| supplier_name   | VARCHAR(100)                | NOT NULL   | 最多 100 字元，超過無法儲存                                              |
| contact_info    | VARCHAR(100)                | YES        | 最多 100 字元，超過無法儲存                                              |
| address         | VARCHAR(100)                | YES        | 最多 100 字元，超過無法儲存                                              |

### Inventory (庫存)
| 欄位名稱        | 資料型態                     | 是否為null | 完整性限制                                                                 |
|-----------------|-----------------------------|------------|---------------------------------------------------------------------------|
| inventory_id    | INT UNSIGNED                | NOT NULL   | 範圍 1 到 4,294,967,295，自動遞增                                         |
| item_name       | VARCHAR(100)                | NOT NULL   | 最多 100 字元，超過無法儲存                                              |
| stock_quantity  | INT UNSIGNED                | NOT NULL   | 不得為負                                                                 |
| supplier_id     | INT UNSIGNED                | NOT NULL   | 參照 Suppliers(supplier_id)                                               |
| last_checker    | INT UNSIGNED                | NOT NULL   | 參照 Staff(staff_id)                                                      |
| last_check_time | TIMESTAMP                   | NOT NULL   | 格式 YYYY-MM-DD HH:MM:SS                                                  |

## Views
  ### 庫存預警
    CREATE VIEW  Low_Stock_Alert AS
    SELECT 
        i.item_name AS 物品名稱,
        i.stock_quantity AS 當前庫存,
        s.supplier_name AS 供應商,
        s.contact_info AS 聯絡方式,
        s.address AS 供應商地址,
    CASE 
        WHEN i.stock_quantity < 10 THEN '緊急補貨'
        WHEN i.stock_quantity < 20 THEN '需要補貨'
        ELSE '庫存充足'
    END AS 庫存狀態
    FROM 
        Inventory i
    JOIN 
        Suppliers s ON i.supplier_id = s.supplier_id
    WHERE 
        i.stock_quantity < 20
    ORDER BY 
        i.stock_quantity ASC;

  ### 今日訂單總覽
    CREATE VIEW Today_Orders_Summary AS
    SELECT 
        o.order_id AS 訂單編號,
        t.table_number AS 桌號,
        o.total_price AS 總金額,
        o.order_time AS 下單時間
    FROM 
        Orders o
    JOIN 
        Tables t ON o.table_id = t.table_id
    WHERE 
        DATE(o.order_time) = CURDATE()
    GROUP BY 
        o.order_id
    ORDER BY 
        o.order_id ASC;

 ### 菜單總覽
    CREATE VIEW Menu AS
    SELECT
      mi.item_name,
      mi.description,
      mi.price,
      mc.category_name
    FROM
      Menu_Items mi
    JOIN
      Menu_Categories mc ON mi.category_id =              
      mc.category_id
    WHERE
      mi.availability = 'Available';

  ### 每月銷售報表
    CREATE VIEW Monthly_Sales_Report AS
    SELECT
      DATE_FORMAT(o.order_time, '%Y-%m') AS 月份,
      COUNT(o.order_id) AS 訂單總數,
      (SELECT COUNT(*) FROM Orders WHERE order_status = 'Cancelled'
      AND DATE_FORMAT(order_time, '%Y-%m') = DATE_FORMAT(o.order_time, '%Y-%m')) AS 取消訂單數,
      (SELECT SUM(total_price) FROM Orders WHERE order_status = 'Completed'
      AND DATE_FORMAT(order_time, '%Y-%m') = DATE_FORMAT(o.order_time, '%Y-%m')) AS 完成訂單總額,
      (
        SELECT p.payment_method
        FROM Payments p
        JOIN Orders o2 ON p.order_id = o2.order_id
        WHERE DATE_FORMAT(o2.order_time, '%Y-%m') = DATE_FORMAT(o.order_time, '%Y-%m')
        GROUP BY p.payment_method
        ORDER BY COUNT(p.payment_id) DESC
        LIMIT 1
      ) AS 最常用支付方式
    FROM
      Orders o
    GROUP BY
      DATE_FORMAT(o.order_time, '%Y-%m')
    ORDER BY
      月份 DESC;

  ### 待處裡訂位
    CREATE VIEW Pending_Reservations_View AS
    SELECT 
        r.reservation_id AS 預訂編號,
        u.name AS 客戶姓名,
        u.phone_number AS 客戶電話,
        t.table_number AS 桌號,
        t.capacity AS 座位數,
        r.reservation_time AS 預訂時間,
        r.status AS 預訂狀態
    FROM 
        Reservations r
    JOIN 
        Users u ON r.user_id = u.user_id
    JOIN 
        Tables t ON r.table_id = t.table_id
    WHERE 
        r.status = 'Pending'
    ORDER BY 
        r.reservation_time ASC;
        
  ### 員工月出勤時數
    CREATE OR REPLACE VIEW Staff_Monthly_Hours AS
    SELECT 
        s.staff_id AS 員工編號,
        u.name AS 員工姓名,
        s.position AS 職位,
        SUM(TIMESTAMPDIFF(HOUR, a.check_in_time, a.check_out_time)) AS 當月總工作時數
    FROM 
        Staff s
    JOIN 
        Users u ON s.user_id = u.user_id
    JOIN 
        Attendance a ON s.staff_id = a.staff_id
    WHERE 
        YEAR(a.check_in_time) = YEAR(CURRENT_DATE) AND MONTH(a.check_in_time) = MONTH(CURRENT_DATE)
    GROUP BY 
        s.staff_id, u.name, s.position
    ORDER BY 
        s.staff_id;

  ### 待處理訂單
    CREATE VIEW Pending_Orders_View AS
    SELECT 
        o.order_id AS 訂單編號,
        t.table_number AS 桌號,
        o.order_time AS 下單時間,
        o.total_price AS 總金額,
        GROUP_CONCAT(mi.item_name SEPARATOR ', ') AS 餐點項目,
        o.order_status AS 訂單狀態
    FROM 
        Orders o
    JOIN 
        Tables t ON o.table_id = t.table_id
    JOIN 
        Order_Items oi ON o.order_id = oi.order_id
    JOIN 
        Menu_Items mi ON oi.item_id = mi.item_id
    WHERE 
        o.order_status IN ('Pending', 'In Progress')
    GROUP BY 
        o.order_id
    ORDER BY 
        o.order_time;
## 工作分配
### 胡晉嘉
  - Schema設計-25%
  - ER-Diagram繪製-25%
  - View建置-25%
  - 資料輸入-25%
  - PPT製作-100%
### 張鈞凱
  - 系統安裝-25%
  - 資料庫建置-50%
  - Schema設計-25%
  - ER-Diagram繪製-50%
  - View建置-75%
### 楊政愷
  - 系統安裝-75%
  - 資料庫建置-25%
  - Schema設計-25%
  - 資料輸入-25%
  - Word製作-25%
### 林震宇
  - 資料庫建置-25%
  - Schema設計-25%
  - ER-Diagram繪製-25%
  - 資料輸入-50%
  - Word製作-75%
