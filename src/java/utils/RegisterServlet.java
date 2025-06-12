package utils;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        try (Connection conn = DBConnection.getConnection()) {
            // Check if username already exists
            PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Username already taken
                response.sendRedirect("register.jsp?error=1");
            } else {
                // Register new user
                PreparedStatement insertStmt = conn.prepareStatement(
                    "INSERT INTO users (username, password, email, phone) VALUES (?, ?, ?, ?)");
                insertStmt.setString(1, username);
                insertStmt.setString(2, password); // Hashing recommended
                insertStmt.setString(3, email);
                insertStmt.setString(4, phone);
                insertStmt.executeUpdate();
                response.sendRedirect("register.jsp?success=1");
            }
                } catch (Exception e) {
            e.printStackTrace(); // This prints to Tomcat logs
            response.sendRedirect("register.jsp?error=server");
        }
    }
}
