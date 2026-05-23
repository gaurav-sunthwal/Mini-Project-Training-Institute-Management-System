# Training Institute Management System

A dynamic, premium, full-featured **Training Institute Management System** built using Core Java, Advanced Java, Servlets, JSP, JDBC, and a gorgeous glassmorphic Dark Mode design system. The project showcases robust MVC (Model-View-Controller) architecture, ACID database transactions, and modern web application patterns.

---

## 🌟 Visuals & Aesthetic Features

* **Glassmorphic Dark Theme:** Tailored HSL color gradients, `backdrop-filter` blur frames, sleek typography (Poppins & Inter), glowing focus form elements, and smooth micro-animations.
* **Aggregated Analytics Dashboard:** Responsive cards detailing student registries, active course syllabus counts, total tuition revenues, and today's average attendance rate.
* **Simulated Outbound SMTP Console:** Visual dashboard logging automated Welcome registrations and payment receipt invoice dispatches in real-time.
* **Responsive Layout:** Sidebar navigation drawer tracking active highlights seamlessly in standard layout structures.

---

## 🛠️ Tech Stack & Dependencies

* **Frontend:** HTML5, CSS3 (Vanilla CSS variables), JavaScript (Vanilla ES6), JSP 2.2, Chart.js (Interactive Graph Canvas).
* **Backend:** Java 17, Servlet API 4.0, JSP API 2.3, JSTL 1.2.
* **Database connectivity:** JDBC, connection pooling, automatic DDL migrations on startup.
* **Active Database:** H2 Database (File-based, persistent, zero-configuration local launch).
* **Alternative Databases Supported:** SQLite and MySQL (Configurable via `db.properties`).
* **Document Compilation:** OpenPDF / iText (For programmatic PDF compiling and streaming).
* **JSON Serialization:** Google Gson (For AJAX search payload transfers).
* **Build tool:** Apache Maven.

---

## 📋 Functional Modules

1. **User Authentication:** Login session bounds with dynamic role checks (Admin, Faculty, Student) and quick evaluation shortcuts.
2. **Student Registry CRUD:** Complete student profiles sheet support with circular photo uploads and conflict-free renamed image allocations.
3. **Course Syllabus Director:** Course registries, program duration records, tuition fees, and assigned faculty advisor bindings.
4. **Attendance Board:** Dynamic rolls logs mapping Present/Absent statuses, check-and-upsert database logic, and dynamic attendance percentages per student.
5. **Fee Ledger:** Relational payment receipts database that logs collections and dynamically calculates outstanding balance sheets.

### Advanced Task Features Included:
* **Export Student Report to PDF:** programmatically compiles the roster list into a styled PDF attachment.
* **Email Notification after Registration:** Dispatches welcome and receipt logs cached instantly in the UI console.
* **Search using AJAX:** Dynamic debounced searching for courses and students directories without page reloads.
* **Dashboard with Charts:** Visual weekly attendance trends and course density doughnuts.
* **Upload Student Photo:** Multi-part file upload support linking avatar paths to profiles.

---

## 🚀 Installation & Local Launch

### Prerequisites
* **Java SDK 17+** (Ensure `java -version` is running in your terminal).
* **Maven** (Apache Maven build system).

### Step-by-Step Setup

1. **Compile and Package the application:**
   ```bash
   mvn clean package
   ```
2. **Start the Embedded Tomcat Local Server:**
   ```bash
   mvn tomcat7:run
   ```
3. **Access the application in your browser:**
   👉 **`http://localhost:8080/`**

---

## 🔑 Quick-Login Roster Credentials

For convenient evaluation, the login panel contains quick-login buttons to prefill and authenticate instantly:

| Role | Username (Email) | Password | Access Rights |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` | Full Access (All actions, financial entries, CRUD) |
| **Faculty** | `faculty` | `faculty123` | Medium Access (CRUD Students, Log Attendance) |
| **Student** | `student` | `student123` | Read-only Access (Dashboard Stats, Profile View) |

---

## 🗄️ Inspecting the Database (H2 Console)

You can explore, view, and run SQL queries against all database tables (STUDENTS, USERS, COURSES, ATTENDANCE, FEES) in your browser!

1. Open: **`http://localhost:8080/console`**
2. Configure the connection fields exactly as follows:
   * **Driver Class:** `org.h2.Driver`
   * **JDBC URL:** `jdbc:h2:/Users/gaurav-sunthwal/Desktop/college/tanishq/tanishq_institute`
   * **User Name:** `sa`
   * **Password:** *(leave blank)*
3. Click **Connect** to access the dashboard.
