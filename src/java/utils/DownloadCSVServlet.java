package utils;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import utils.DBConnection;

@WebServlet("/download-csv")
public class DownloadCSVServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int month = Integer.parseInt(request.getParameter("month"));
        int year = Integer.parseInt(request.getParameter("year"));

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=transactions_" + month + "_" + year + ".csv");

        PrintWriter out = response.getWriter();
        out.println("Date,Type,Category,Amount,Note");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT t.date, t.type, c.name AS category, t.amount, t.note " +
                             "FROM transactions t JOIN categories c ON t.category_id = c.id " +
                             "WHERE t.user_id = ? AND MONTH(t.date) = ? AND YEAR(t.date) = ? ORDER BY t.date DESC"
             )) {
            stmt.setInt(1, userId);
            stmt.setInt(2, month);
            stmt.setInt(3, year);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                out.printf("\"%s\",\"%s\",\"%s\",\"%.2f\",\"%s\"%n",
                        rs.getDate("date"),
                        rs.getString("type"),
                        rs.getString("category"),
                        rs.getDouble("amount"),
                        rs.getString("note").replace("\"", "\"\""));
            }

        } catch (Exception e) {
            out.println("Error generating CSV file");
            e.printStackTrace();
        }
    }
}