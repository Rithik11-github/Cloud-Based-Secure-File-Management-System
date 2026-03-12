import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

@WebServlet(urlPatterns = {"/Request_Mail"})
public class Request_Mail extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/ip";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "admin";

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_FROM = "triosjavateam@gmail.com";
    private static final String SMTP_PASSWORD = "qxmascdsgyguogcr";

    // Method to send email
    private void sendEmail(String recipient, String subject, String messageBody) {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_FROM, SMTP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_FROM));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
            message.setSubject(subject);
            message.setText("Your Message is: " + messageBody);

            Transport.send(message);
            System.out.println("Email sent to: " + recipient);
        } catch (MessagingException e) {
            e.printStackTrace();
            System.out.println("Error sending email: " + e.getMessage());
        }
    }

    // Method to handle the request
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);

        try {
            String fromEmail = "", toEmail = "", subject = "", message = "", Aadhar_No = "", current_date = "";
            String fileName = null;

            // Parse the request using Apache Commons FileUpload
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> items = upload.parseRequest(request);

            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString();

                    switch (fieldName) {
                        case "from_mail":
                            fromEmail = fieldValue;
                            break;
                        case "To":
                            toEmail = fieldValue;
                            break;
                        case "subject":
                            subject = fieldValue;
                            break;
                        case "Message":
                            message = fieldValue;
                            break;
                        case "Aadhar":
                            Aadhar_No = fieldValue;
                            break;
                        case "current_date":
                            current_date = fieldValue;
                            break;
                    }
                } else {
                    fileName = item.getName();
                    // File handling can be added if required
                }
            }

            // Check if the email should be sent based on the count and date
            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                // Check for an existing record with the same From_Mail and current_date
                String checkSql = "SELECT Count, `current_date` FROM Mail WHERE From_Mail = ?";
                PreparedStatement checkStmt = con.prepareStatement(checkSql);
                checkStmt.setString(1, fromEmail);

                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt("Count");
                    String dbCurrentDate = rs.getString("current_date");

                    // Check the conditions based on Count and current_date
                    if ((count == 1 && dbCurrentDate.equals(current_date)) || (count == 0 && dbCurrentDate.equals(current_date))) {
                        // If Count is 1 or 0 and current_date matches, do not send email or store
                        System.out.println("Email not sent or stored because the conditions are not met.");
                    } else if (count == 1 && !dbCurrentDate.equals(current_date)) {
                        // If Count is 1 and current_date does not match, update the current_date and send email
                        sendEmail(toEmail, subject, message);

                        String updateSql = "UPDATE Mail SET `current_date` = ?, Count = 1 , Subject = ?, Message = ?  WHERE From_Mail = ?";
                        PreparedStatement updateStmt = con.prepareStatement(updateSql);
                        updateStmt.setString(1, current_date);
                        updateStmt.setString(2, subject);
                        updateStmt.setString(3, message);
                        updateStmt.setString(4, fromEmail);

                        int rowsUpdated = updateStmt.executeUpdate();
                        if (rowsUpdated > 0) {
                            System.out.println("Record updated with new current_date.");
                        }
                    }
                } else {
                    // No record found, insert new record and send the email
                    sendEmail(toEmail, subject, message);

                    String insertSql = "INSERT INTO Mail (From_Mail, `To`, Subject, Message, Count, aadhar_no, `current_date`) VALUES (?, ?, ?, ?, '1', ?, ?)";
                    PreparedStatement insertStmt = con.prepareStatement(insertSql);
                    insertStmt.setString(1, fromEmail);
                    insertStmt.setString(2, toEmail);
                    insertStmt.setString(3, subject);
                    insertStmt.setString(4, message);
                    insertStmt.setString(5, Aadhar_No);
                    insertStmt.setString(6, current_date);

                    int rowsInserted = insertStmt.executeUpdate();
                    if (rowsInserted > 0) {
                        System.out.println("New email record inserted into the database.");
                    }
                }
            }

            // Redirect or respond to the user
            session.setAttribute("msg", "Email successfully sent.");
            response.sendRedirect("MAIL.jsp");

        } catch (FileUploadException | SQLException e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to handle email requests and send emails.";
    }
}
