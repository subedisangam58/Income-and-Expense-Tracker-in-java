package utils;

import java.sql.*;
import java.util.*;

public class CategoryDAO {
    public static Map<Integer, String> getCategories(String type) {
        Map<Integer, String> categories = new HashMap<>();
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT id, name FROM categories WHERE type=?");
            stmt.setString(1, type);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                categories.put(rs.getInt("id"), rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }
}
