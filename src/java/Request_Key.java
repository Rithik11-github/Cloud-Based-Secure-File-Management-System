import java.io.IOException;
import java.sql.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Connection.DbConnection;
import java.util.Properties;

@WebServlet("/Request_Key")
public class Request_Key extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String id = request.getParameter("id");

        // Fetch the encryption key from the database using DbConnection
        String encryptionKey = getEncryptionKey(id);

        if (encryptionKey != null) {
            // Send the encryption key to the user's email
            sendEncryptionKeyEmail(email, encryptionKey);
            response.getWriter().write("Encryption key sent to " + email);
        } else {
            response.getWriter().write("No encryption key found for the provided file.");
        }
    }

    private String getEncryptionKey(String fileId) {
        String encryptionKey = null;
        DbConnection dbConnection = new DbConnection(); // Instantiate DbConnection

        // Query to fetch the encryption key based on file ID
        String query = "SELECT encryption_key FROM encrypted_documents WHERE id = ?";

        ResultSet rs = null;
        try {
            // Using the existing Select method with parameterized query
            rs = dbConnection.Select(query, fileId);
            if (rs != null && rs.next()) {
                encryptionKey = rs.getString("encryption_key");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close the ResultSet
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return encryptionKey;
    }

    private void sendEncryptionKeyEmail(String recipientEmail, String encryptionKey) {
        String host = "smtp.gmail.com"; // Use your email service SMTP host
        final String from = "triosjavateam@gmail.com";
        final String password = "qxmascdsgyguogcr";

        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Your Encryption Key");
            message.setText("Dear user,\n\nHere is your encryption key: " + encryptionKey);

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
