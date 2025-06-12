<%@ page import="java.util.*, utils.CategoryDAO" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.html");
        return;
    }

    Map<Integer, String> incomeCategories = CategoryDAO.getCategories("Income");
    Map<Integer, String> expenseCategories = CategoryDAO.getCategories("Expense");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Transaction</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/add_transaction.css">
</head>
<body>
    <jsp:include page="sidebar.jsp" />
    <div class="container">
        <h2>Add New Transaction</h2>
        <form action="AddTransactionServlet" method="post">
            <label>Amount:</label>
            <input type="number" name="amount" step="0.01" required />

            <label>Type:</label>
            <select name="type">
                <option value="Income">Income</option>
                <option value="Expense">Expense</option>
            </select>

            <label>Category:</label>
            <select name="category_id">
                <optgroup label="Income">
                    <% for (Map.Entry<Integer, String> entry : incomeCategories.entrySet()) { %>
                        <option value="<%= entry.getKey() %>"><%= entry.getValue() %></option>
                    <% } %>
                </optgroup>
                <optgroup label="Expense">
                    <% for (Map.Entry<Integer, String> entry : expenseCategories.entrySet()) { %>
                        <option value="<%= entry.getKey() %>"><%= entry.getValue() %></option>
                    <% } %>
                </optgroup>
            </select>

            <label>Date:</label>
            <input type="date" name="date" required />

            <label>Note:</label>
            <textarea name="note" placeholder="Optional..."></textarea>

            <button type="submit">Add Transaction</button>
        </form>
    </div>

</body>
</html>