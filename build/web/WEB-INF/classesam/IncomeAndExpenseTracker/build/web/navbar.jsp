<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .navbar {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                height: 60px;
                background-color: #2c3e50;
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 999;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            }

            .navbar-content {
                width: 100%;
                max-width: 1200px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 20px;
                color: #ecf0f1;
            }

            .logo {
                font-weight: bold;
                font-size: 1.2rem;
                color: #ecf0f1;
            }

            .nav-links a {
                color: #ecf0f1;
                text-decoration: none;
                margin-left: 20px;
                font-size: 0.95rem;
            }

            .nav-links a:hover {
                text-decoration: underline;
            }

            /* Push down page content to avoid overlap */
            body {
                padding-top: 60px;
            }
            </style>
    </head>
    <body>
        <!-- navbar.jsp -->
        <div class="navbar">
            <div class="navbar-content">
                <span class="logo">Income & Expense Tracker</span>
                <div class="nav-links">
                    <a href="index.jsp">Home</a>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Register</a>
                </div>
            </div>
        </div>
    </body>
</html>
