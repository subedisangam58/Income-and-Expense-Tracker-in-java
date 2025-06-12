<%@ page import="java.sql.*, utils.DBConnection" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int selectedMonth = request.getParameter("month") != null ? Integer.parseInt(request.getParameter("month")) : java.time.LocalDate.now().getMonthValue();
    int selectedYear = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : java.time.LocalDate.now().getYear();

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    double totalIncome = 0;
    double totalExpense = 0;
    boolean salaryExists = false;

    try {
        conn = DBConnection.getConnection();

        // Check if salary exists for this month
        PreparedStatement salaryStmt = conn.prepareStatement(
            "SELECT COUNT(*) FROM transactions " +
            "WHERE user_id = ? AND type = 'Income' AND category_id IN " +
            "(SELECT id FROM categories WHERE name = 'Salary') " +
            "AND MONTH(date) = ? AND YEAR(date) = ?"
        );
        salaryStmt.setInt(1, userId);
        salaryStmt.setInt(2, selectedMonth);
        salaryStmt.setInt(3, selectedYear);
        ResultSet salaryRs = salaryStmt.executeQuery();
        if (salaryRs.next() && salaryRs.getInt(1) > 0) {
            salaryExists = true;
        }
        salaryRs.close();
        salaryStmt.close();

        stmt = conn.prepareStatement(
            "SELECT t.id, t.amount, t.date, c.name AS category, t.type, t.note " +
            "FROM transactions t JOIN categories c ON t.category_id = c.id " +
            "WHERE t.user_id = ? AND MONTH(t.date) = ? AND YEAR(t.date) = ? ORDER BY t.date DESC"
        );
        stmt.setInt(1, userId);
        stmt.setInt(2, selectedMonth);
        stmt.setInt(3, selectedYear);
        rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>
<jsp:include page="sidebar.jsp" />

<div class="main-content" style="margin-left:240px; padding:20px;">
    
    <!-- Filter Form -->
    <div class="filter-form" style="text-align:center; margin-bottom:20px;">
        <form method="get" action="dashboard.jsp" style="display: inline-block;">
            <label>Month:</label>
            <select name="month">
                <% for (int m = 1; m <= 12; m++) { %>
                    <option value="<%= m %>" <%= m == selectedMonth ? "selected" : "" %>><%= java.time.Month.of(m) %></option>
                <% } %>
            </select>
            <label>Year:</label>
            <input type="number" name="year" value="<%= selectedYear %>" required style="width:80px;" />
            <button type="submit">View</button>
        </form>

        <!-- Download CSV Button -->
        <a href="download-csv?month=<%= selectedMonth %>&year=<%= selectedYear %>" 
           style="margin-left: 20px; padding: 8px 12px; background-color: #3498db; color: white; border-radius: 4px; text-decoration: none;">
           Download CSV
        </a>
    </div>

    <h2 style="text-align:center;">Your Transactions - <%= java.time.Month.of(selectedMonth) %> <%= selectedYear %></h2>

    <!-- Transactions Table -->
    <table>
        <thead>
            <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Category</th>
                <th>Amount</th>
                <th>Note</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                while (rs.next()) {
                    String type = rs.getString("type");
                    double amount = rs.getDouble("amount");
                    if ("Income".equalsIgnoreCase(type)) {
                        totalIncome += amount;
                    } else {
                        totalExpense += amount;
                    }
            %>
            <tr>
                <td><%= rs.getDate("date") %></td>
                <td><%= type %></td>
                <td><%= rs.getString("category") %></td>
                <td><%= amount %></td>
                <td><%= rs.getString("note") %></td>
                <td>
                    <form action="DeleteTransactionServlet" method="post" onsubmit="return confirm('Are you sure?');">
                        <input type="hidden" name="transaction_id" value="<%= rs.getInt("id") %>" />
                        <button type="submit">Remove</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
        <tfoot>
            <tr><td colspan="3">Total Income</td><td colspan="3" style="color: green;"><%= totalIncome %></td></tr>
            <tr><td colspan="3">Total Expense</td><td colspan="3" style="color: red;"><%= totalExpense %></td></tr>
            <tr>
                <td colspan="3">Net Balance</td>
                <td colspan="3" style="color: <%= (totalIncome - totalExpense) >= 0 ? "green" : "red" %>;"><%= totalIncome - totalExpense %></td>
            </tr>
        </tfoot>
    </table>

    <!-- Modal to Add Income -->
    <div id="incomeModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal()">&times;</span>
            <h3 style="text-align:center;">Add Income</h3>
            <form action="AddTransactionServlet" method="post">
                <input type="hidden" name="type" value="Income" />
                <label>Amount:</label>
                <input type="number" name="amount" step="0.01" required />
                <label>Category:</label>
                <select name="category_id" required>
                    <%
                        PreparedStatement catStmt = conn.prepareStatement("SELECT id, name FROM categories WHERE type = 'Income'");
                        ResultSet catRs = catStmt.executeQuery();
                        while (catRs.next()) {
                    %>
                    <option value="<%= catRs.getInt("id") %>"><%= catRs.getString("name") %></option>
                    <%
                        }
                        catRs.close();
                        catStmt.close();
                    %>
                </select>
                <label>Date:</label>
                <input type="date" name="date" required />
                <label>Note (optional):</label>
                <textarea name="note" rows="3"></textarea>
                <button type="submit">Add Income</button>
            </form>
        </div>
    </div>
</div>

<% if (!salaryExists) { %>
<script>window.onload = function () { openModal(); }</script>
<% } %>

<script>
    function openModal() {
        document.getElementById('incomeModal').style.display = 'block';
    }
    function closeModal() {
        document.getElementById('incomeModal').style.display = 'none';
    }
    window.onclick = function(event) {
        const modal = document.getElementById('incomeModal');
        if (event.target === modal) {
            closeModal();
        }
    }
</script>
</body>
</html>
<%
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error loading transactions.</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>