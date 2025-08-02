package utils;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Server-side confirm password check
        if (password != null && !password.isEmpty()) {
            if (confirmPassword == null || !password.equals(confirmPassword)) {
                response.sendRedirect("profile.jsp?error=Passwords+do+not+match");
                return;
            }
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = utils.DBConnection.getConnection();

            if (password != null && !password.trim().isEmpty()) {
                stmt = conn.prepareStatement("UPDATE users SET username=?, email=?, phone=?, password=? WHERE id=?");
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, phone);
                stmt.setString(4, password); // 🔐 Tip: Use password hashing in production
                stmt.setInt(5, userId);
            } else {
                stmt = conn.prepareStatement("UPDATE users SET username=?, email=?, phone=? WHERE id=?");
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, phone);
                stmt.setInt(4, userId);
            }

            stmt.executeUpdate();
            response.sendRedirect("profile.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=Update+failed");
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}