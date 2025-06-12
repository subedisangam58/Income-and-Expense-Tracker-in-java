<%@ page import="java.sql.*, java.util.*, utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String[] monthNames = new java.text.DateFormatSymbols().getMonths();
    List<String> labels = new ArrayList<>();
    List<Double> incomeList = new ArrayList<>();
    List<Double> expenseList = new ArrayList<>();

    try {
        conn = DBConnection.getConnection();
        stmt = conn.prepareStatement(
            "SELECT MONTH(date) AS month, type, SUM(amount) AS total " +
            "FROM transactions WHERE user_id = ? AND YEAR(date) = YEAR(CURDATE()) " +
            "GROUP BY MONTH(date), type ORDER BY month"
        );
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();

        Map<Integer, Double> incomeMap = new HashMap<>();
        Map<Integer, Double> expenseMap = new HashMap<>();

        while (rs.next()) {
            int month = rs.getInt("month");
            String type = rs.getString("type");
            double total = rs.getDouble("total");

            if ("Income".equalsIgnoreCase(type)) {
                incomeMap.put(month, total);
            } else {
                expenseMap.put(month, total);
            }
        }

        for (int i = 1; i <= 12; i++) {
            labels.add(monthNames[i - 1]);
            incomeList.add(incomeMap.getOrDefault(i, 0.0));
            expenseList.add(expenseMap.getOrDefault(i, 0.0));
        }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Analytics</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f4f8;
            display: flex;
        }

        .main-content {
            margin-left: 240px;
            padding: 30px;
            width: 100%;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .chart-card {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        canvas {
            width: 100% !important;
            height: auto !important;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="sidebar.jsp" />

    <div class="main-content">
        <h2>📊 Monthly Income vs Expense (Current Year)</h2>
        <div class="chart-card">
            <canvas id="barChart"></canvas>
        </div>

        <script>
            const labels = <%= labels.toString().replace("[", "[\"").replace("]", "\"]").replace(", ", "\", \"") %>;
            const incomeData = <%= incomeList.toString().replace("[", "[").replace("]", "]") %>;
            const expenseData = <%= expenseList.toString().replace("[", "[").replace("]", "]") %>;

            new Chart(document.getElementById('barChart'), {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Income',
                            data: incomeData,
                            backgroundColor: 'rgba(75, 192, 192, 0.7)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Expense',
                            data: expenseData,
                            backgroundColor: 'rgba(255, 99, 132, 0.7)',
                            borderColor: 'rgba(255, 99, 132, 1)',
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return `${context.dataset.label}: ₹${context.formattedValue}`;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return 'Rs.' + value;
                                }
                            }
                        }
                    }
                }
            });
        </script>
    </div>
</body>
</html>

<%
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error loading analytics.</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>