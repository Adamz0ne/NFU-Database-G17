# Human Resource Management System

Handling human resources within company.Including but not limited to 

`Employees`,`Departments`,`Positions`,`Salaries`,`Attendence`,`Leave Requests`,

`Payroll`,`Performance Reviews`,`User Accounts`,`Training and Certifications` and so on.

## 1. Employees

- `employee_id` (PK)
- `first_name`, `last_name`
- `date_of_birth`, `gender`
- `email`, `phone_number`
- `address`
- `hire_date`, `termination_date`
- `department_id` (FK)
- `position_id` (FK)
- `salary_id` (FK)

## 2. Departments

- `department_id` (PK)
- `department_name`
- `manager_id` (FK → Employees)

## 3. Positions

- `position_id` (PK)
- `position_title`
- `description`

## 4. Salaries

- `salary_id` (PK)
- `employee_id` (FK)
- `basic_salary`
- `bonuses`
- `deductions`
- `net_salary`

## 5. Attendance

- `attendance_id` (PK)
- `employee_id` (FK)
- `date`
- `clock_in_time`, `clock_out_time`

## 6. Leave Requests

- `leave_id` (PK)
- `employee_id` (FK)
- `leave_type`
- `start_date`, `end_date`
- `status` (Pending, Approved, Rejected)

## 7. Payroll

- `payroll_id` (PK)
- `employee_id` (FK)
- `pay_date`
- `gross_salary`, `taxes`, `net_pay`

## 8. Performance Reviews

- `review_id` (PK)
- `employee_id` (FK)
- `review_date`
- `rating`
- `comments`

## 9. User Accounts

- `user_id` (PK)
- `employee_id` (FK)
- `username`, `password_hash`
- `role` (Admin, HR, Employee)

## 10. Training and Certifications

- `training_id` (PK)
- `employee_id` (FK)
- `training_name`
- `completion_date`

