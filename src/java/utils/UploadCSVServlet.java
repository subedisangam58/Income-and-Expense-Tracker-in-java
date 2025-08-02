import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UploadCSVServlet")
@MultipartConfig
public class UploadCSVServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Double> incomeList = new ArrayList<>();
        List<Double> expenseList = new ArrayList<>();
        List<String> uploadedFileNames = new ArrayList<>();

        Collection<Part> fileParts = request.getParts();

        for (Part filePart : fileParts) {
            String fileName = getFileName(filePart);
            if (fileName != null && fileName.endsWith(".csv")) {
                uploadedFileNames.add(fileName);

                try (BufferedReader reader = new BufferedReader(new InputStreamReader(filePart.getInputStream()))) {
                    String line;
                    reader.readLine(); // Skip header

                    while ((line = reader.readLine()) != null) {
                        String[] columns = line.split(",");
                        if (columns.length >= 4) {
                            String type = columns[1].trim().replace("\"", "");
                            String amountStr = columns[3].trim().replace("\"", "").replace(",", "");

                            try {
                                double amount = Double.parseDouble(amountStr);
                                if ("Income".equalsIgnoreCase(type)) {
                                    incomeList.add(amount);
                                } else if ("Expense".equalsIgnoreCase(type)) {
                                    expenseList.add(amount);
                                }
                            } catch (NumberFormatException ignored) {}
                        }
                    }
                }
            }
        }

        double predictedIncome = incomeList.stream().mapToDouble(Double::doubleValue).average().orElse(0);
        double predictedExpense = expenseList.stream().mapToDouble(Double::doubleValue).average().orElse(0);
        double predictedSavings = predictedIncome - predictedExpense;

        request.setAttribute("fileNames", uploadedFileNames);
        request.setAttribute("predictedIncome", String.format("%.2f", predictedIncome));
        request.setAttribute("predictedExpense", String.format("%.2f", predictedExpense));
        request.setAttribute("predictedSavings", String.format("%.2f", predictedSavings));

        request.getRequestDispatcher("predict.jsp").forward(request, response);
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String cd : contentDisposition.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}