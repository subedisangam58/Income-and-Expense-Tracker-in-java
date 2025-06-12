package utils;


import utils.DBConnection;
import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddTransactionServlet")
public class AddTransactionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("user_id");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String type = request.getParameter("type");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String date = request.getParameter("date");
        String note = request.getParameter("note");

        try (Connection conn = (Connection) DBConnection.getConnection()) {
            PreparedStatement stmt = (PreparedStatement) conn.prepareStatement(
                "INSERT INTO transactions (user_id, amount, type, category_id, date, note) VALUES (?, ?, ?, ?, ?, ?)");
            stmt.setInt(1, userId);
            stmt.setDouble(2, amount);
            stmt.setString(3, type);
            stmt.setInt(4, categoryId);
            stmt.setString(5, date);
            stmt.setString(6, note);

            stmt.executeUpdate();
            response.sendRedirect("dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
