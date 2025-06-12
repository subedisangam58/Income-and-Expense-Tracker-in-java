<!DOCTYPE html>
<html>
<head>
    <title>Login Form</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/login.css">
</head>
<body style="text-align: center; padding-top: 100px;">
    <jsp:include page="navbar.jsp" />
    <div>
        <h2>Login</h2>
        <form action="LoginServlet" method="post">
            <input type="text" name="username" placeholder="Username" required /><br/><br/>
            <input type="password" name="password" placeholder="Password" required /><br/><br/>
            <button type="submit">Login</button>
        </form>
        <% if (request.getParameter("error") != null) { %>
            <p style="color: red;">Invalid username or password</p>
        <% } %>
    </div>
</body>
</html>
