<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Income & Expense Prediction</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
        }

        .form-container {
            max-width: 600px;
            margin: 60px auto;
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
        }

        h2, h3 {
            color: #333;
            margin-bottom: 20px;
        }

        input[type="file"] {
            border: 2px dashed #ccc;
            padding: 20px;
            width: 80%;
            border-radius: 8px;
            background-color: #fafafa;
            cursor: pointer;
            margin-bottom: 20px;
        }

        input[type="file"]:hover {
            border-color: #007BFF;
            background-color: #f1f9ff;
        }

        button {
            background-color: #007BFF;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }

        ul {
            list-style-type: none;
            padding: 0;
            text-align: left;
            margin-left: 15%;
        }

        ul li {
            background: #e9ecef;
            margin: 5px 0;
            padding: 8px 12px;
            border-radius: 6px;
        }

        .results {
            margin-top: 30px;
        }

        .results p {
            font-size: 16px;
            color: #555;
        }

        .results strong {
            color: #007BFF;
        }

    </style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

<div class="form-container">
    <h2>Upload CSV Files to Predict Income & Expense</h2>

    <form action="UploadCSVServlet" method="post" enctype="multipart/form-data">
        <input type="file" name="file" multiple accept=".csv" required />
        <br><br>
        <button type="submit">Upload & Predict</button>
    </form>

    <div class="results">
        <%
            String predictedIncome = (String) request.getAttribute("predictedIncome");
            String predictedExpense = (String) request.getAttribute("predictedExpense");
            String predictedSavings = (String) request.getAttribute("predictedSavings");
            List<String> fileNames = (List<String>) request.getAttribute("fileNames");

            if (predictedIncome != null && predictedExpense != null && fileNames != null) {
        %>
            <h3>Uploaded Files:</h3>
            <ul>
                <% for(String f : fileNames) { %>
                    <li><%= f %></li>
                <% } %>
            </ul>

            <h3>Predicted Results:</h3>
            <p><strong>Predicted Income:</strong> Rs. <%= predictedIncome %></p>
            <p><strong>Predicted Expense:</strong> Rs. <%= predictedExpense %></p>
            <p><strong>Predicted Savings:</strong> Rs. <%= predictedSavings %></p>
        <%
            }
        %>
    </div>

</div>

</body>
</html>