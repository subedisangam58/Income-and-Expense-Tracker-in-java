<%@ page import="java.sql.*, utils.DBConnection" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String currentUsername = "";
    String currentEmail = "";
    String currentPhone = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        stmt = conn.prepareStatement("SELECT username, email, phone FROM users WHERE id = ?");
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            currentUsername = rs.getString("username");
            currentEmail = rs.getString("email");
            currentPhone = rs.getString("phone");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Profile</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/profile.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f8;
            display: flex;
        }
        .main-content {
            margin-left: 240px;
            padding: 40px;
            width: 100%;
        }
        .form-card {
            background-color: #fff;
            max-width: 500px;
            margin: auto;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }
        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            color: #555;
        }
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1rem;
        }
        button {
            margin-top: 20px;
            width: 48%;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .button-group {
            display: flex;
            justify-content: space-between;
        }
        #password-section {
            display: none;
        }
    </style>
    <script>
        function enableEdit() {
            document.getElementById('username').disabled = false;
            document.getElementById('email').disabled = false;
            document.getElementById('phone').disabled = false;
            document.getElementById('password-section').style.display = 'block';
            document.getElementById('saveButton').style.display = 'inline-block';
        }

        function cancelEdit() {
            location.reload();
        }

        function validatePasswords() {
            const pwd = document.getElementById('password').value;
            const confirmPwd = document.getElementById('confirmPassword').value;
            if (pwd !== confirmPwd) {
                alert('Passwords do not match.');
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <jsp:include page="sidebar.jsp" />

    <div class="main-content">
        <div class="form-card">
            <h2>Update Profile</h2>
            <form action="UpdateProfileServlet" method="post" onsubmit="return validatePasswords()">
                <label>Username:</label>
                <input type="text" id="username" name="username" value="<%= currentUsername %>" disabled required />

                <label>Email:</label>
                <input type="email" id="email" name="email" value="<%= currentEmail %>" disabled required />

                <label>Phone:</label>
                <input type="text" id="phone" name="phone" value="<%= currentPhone %>" disabled required />

                <div id="password-section">
                    <label>New Password (optional):</label>
                    <input type="password" id="password" name="password" />

                    <label>Confirm Password:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" />
                </div>

                <div class="button-group">
                    <button type="button" onclick="enableEdit()">Update Profile</button>
                    <button type="button" onclick="cancelEdit()">Cancel</button>
                </div>

                <button type="submit" style="margin-top: 15px; display: none;" id="saveButton">Save Changes</button>
            </form>
        </div>
    </div>

</body>
</html>