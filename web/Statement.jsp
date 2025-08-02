<%@ page import="java.sql.*, utils.DBConnection" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String startDateParam = request.getParameter("start_date");
    String endDateParam = request.getParameter("end_date");

    java.sql.Date startDate = null;
    java.sql.Date endDate = null;

    try {
        startDate = (startDateParam != null && !startDateParam.isEmpty()) ? java.sql.Date.valueOf(startDateParam) : java.sql.Date.valueOf(java.time.LocalDate.now().withDayOfMonth(1));
        endDate = (endDateParam != null && !endDateParam.isEmpty()) ? java.sql.Date.valueOf(endDateParam) : java.sql.Date.valueOf(java.time.LocalDate.now());
    } catch (IllegalArgumentException e) {
        out.println("<p style='color:red;text-align:center;'>Invalid date format. Please select valid dates.</p>");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    double totalIncome = 0;
    double totalExpense = 0;
    double runningBalance = 0;

    try {
        conn = DBConnection.getConnection();

        stmt = conn.prepareStatement(
            "SELECT t.amount, t.date, c.name AS category, t.type, t.note " +
            "FROM transactions t JOIN categories c ON t.category_id = c.id " +
            "WHERE t.user_id = ? AND t.date BETWEEN ? AND ? ORDER BY t.date ASC"
        );
        stmt.setInt(1, userId);
        stmt.setDate(2, startDate);
        stmt.setDate(3, endDate);
        rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bank Statement</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 900px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        form {
            text-align: center;
            margin-bottom: 20px;
        }
        select, input[type="number"], input[type="date"], button {
            padding: 8px 12px;
            margin: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table th, table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        table thead {
            background: #007BFF;
            color: #fff;
        }
        table tbody tr:nth-child(even) {
            background: #f9f9f9;
        }
        .income { color: green; }
        .expense { color: red; }
    </style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

<div class="container">
    <h2>Statement from <%= startDate %> to <%= endDate %></h2>

    <form method="get" action="Statement.jsp">
        <label>Start Date:</label>
        <input type="date" name="start_date" value="<%= startDate %>" required />

        <label>End Date:</label>
        <input type="date" name="end_date" value="<%= endDate %>" required />

        <button type="submit">Filter</button>
    </form>

    <table>
        <thead>
            <tr>
                <th>Date</th>
                <th>Description</th>
                <th>Category</th>
                <th>Credit (Income)</th>
                <th>Debit (Expense)</th>
                <th>Balance</th>
            </tr>
        </thead>
        <tbody>
            <% if (!rs.isBeforeFirst()) { %>
                <tr><td colspan="6">No transactions found for the selected period.</td></tr>
            <% } else {
                while (rs.next()) {
                    String type = rs.getString("type");
                    double amount = rs.getDouble("amount");
                    String category = rs.getString("category");
                    String note = rs.getString("note");
                    Date date = rs.getDate("date");

                    if ("Income".equalsIgnoreCase(type)) {
                        totalIncome += amount;
                        runningBalance += amount;
                    } else {
                        totalExpense += amount;
                        runningBalance -= amount;
                    }
            %>
            <tr>
                <td><%= date %></td>
                <td><%= note != null ? note : "-" %></td>
                <td><%= category %></td>
                <td class="income"><%= "Income".equalsIgnoreCase(type) ? String.format("%.2f", amount) : "" %></td>
                <td class="expense"><%= "Expense".equalsIgnoreCase(type) ? String.format("%.2f", amount) : "" %></td>
                <td><%= String.format("%.2f", runningBalance) %></td>
            </tr>
            <% } } %>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="3"><strong>Total Income:</strong></td>
                <td colspan="3" style="color: green;"><%= String.format("%.2f", totalIncome) %></td>
            </tr>
            <tr>
                <td colspan="3"><strong>Total Expense:</strong></td>
                <td colspan="3" style="color: red;"><%= String.format("%.2f", totalExpense) %></td>
            </tr>
            <tr>
                <td colspan="3"><strong>Closing Balance:</strong></td>
                <td colspan="3"><%= String.format("%.2f", runningBalance) %></td>
            </tr>
        </tfoot>
    </table>
</div>

</body>
</html>
<%
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error loading bank statement.</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>