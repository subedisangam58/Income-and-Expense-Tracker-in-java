<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Income & Expense Tracker</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <header>
        <jsp:include page="navbar.jsp" />
    </header>
    <div>
        <header class="hero">
            <h1>Income & Expense Tracker</h1>
            <p>Take control of your finances with ease. Track your income and expenses in one place.</p>
        </header>

        <section class="features">
            <h2>Features</h2>
            <div class="cards">
                <div class="card">
                    <h3>Track Your Income</h3>
                    <p>Effortlessly log your income from various sources and see a detailed summary.</p>
                </div>
                <div class="card">
                    <h3>Track Expenses</h3>
                    <p>Monitor and categorize your expenses to better understand where your money goes.</p>
                </div>
                <div class="card">
                    <h3>Generate Reports</h3>
                    <p>Generate monthly or yearly reports for better financial decision-making.</p>
                </div>
            </div>
        </section>

        <section class="call-to-action">
            <h2>Start Tracking Today!</h2>
            <p>Sign up now and start organizing your finances with just a few clicks.</p>
            <div class="cta-buttons">
                <a href="register.jsp" class="btn">Sign Up Now</a>
                <a href="login.jsp" class="btn">Login</a>
            </div>
        </section>
        <footer>
            <p>© 2025 Income & Expense Tracker | <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>
        </footer>
    </div>
</body>
</html>