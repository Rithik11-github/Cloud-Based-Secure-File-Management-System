import java.io.IOException;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Connection.DbConnection;
import java.sql.*;
import java.util.Properties;

@WebServlet("/mail")
public class mail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String id = request.getParameter("id");

        if (email == null || id == null) {
            request.getSession().setAttribute("msg", "Invalid request.");
            response.sendRedirect("DOWNLOAD.jsp");
            return;
        }

        String encryptionKey = getEncryptionKeyFromDatabase(id);

        if (encryptionKey != null && sendEncryptionKeyEmail(email, encryptionKey)) {
            request.getSession().setAttribute("msg",
                    "Encryption key has been sent to " + email);
        } else {
            request.getSession().setAttribute("msg",
                    "Failed to send the encryption key. Please try again.");
        }

        response.sendRedirect("DOWNLOAD.jsp");
    }

    private String getEncryptionKeyFromDatabase(String id) {

        String encryptionKey = null;
        String query = "SELECT encryption_key FROM documents WHERE id=?";

        try {
            DbConnection db = new DbConnection();
            PreparedStatement stmt = db.con.prepareStatement(query);

            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                encryptionKey = rs.getString("encryption_key");
            }

            rs.close();
            stmt.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return encryptionKey;
    }

    private boolean sendEncryptionKeyEmail(String recipientEmail, String encryptionKey) {

        final String from = "javatrios07@gmail.com";
        final String password = "ncwbjzphrjztfupn";  // Gmail App Password

        Properties props = new Properties();

        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {

            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        // Enable debugging (shows SMTP errors in console)
        session.setDebug(true);

        try {

            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(from));

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(recipientEmail)
            );

            message.setSubject("Document Encryption Key");

            message.setText(
                    "Dear User,\n\n"
                    + "Your encryption key is:\n\n"
                    + encryptionKey
                    + "\n\nUse this key to download your document.\n\n"
                    + "Thank You."
            );

            Transport.send(message);

            System.out.println("Email Sent Successfully");

            return true;

        } catch (Exception e) {

            e.printStackTrace();
            return false;
        }
    }
}