<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="css/register.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div>
        <h2>Create an Account</h2>

        <form action="RegisterServlet" method="post">
            <input type="text" name="username" placeholder="Username" required /><br/><br/>
            <input type="password" name="password" placeholder="Password" required /><br/><br/>
            <input type="email" name="email" placeholder="Email" required /><br/><br/>
            <input type="text" name="phone" placeholder="Phone Number" required /><br/><br/>
            <button type="submit">Register</button>
        </form>

        <div class="message">
            <% 
                String error = request.getParameter("error");
                String success = request.getParameter("success");

                if ("1".equals(error)) {
            %>
                <p class="error">Username already exists. Try another.</p>
            <% 
                } else if ("server".equals(error)) { 
            %>
                <p class="error">Something went wrong. Please try again later.</p>
            <% 
                } else if (success != null) { 
            %>
                <p class="success">Registration successful! <a href="login.jsp">Login now</a></p>
            <% 
                } 
            %>
        </div>
    </div>
</body>
</html>
