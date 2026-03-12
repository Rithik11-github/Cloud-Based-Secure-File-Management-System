import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import java.net.URLEncoder;
import Connection.DbConnection;
import javax.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = {"/Send_Link"})
public class Send_Link extends HttpServlet {
  

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from the URL
        String mId = request.getParameter("M_Id");
        String fromMail = request.getParameter("FromMail");
        String Aadhar_No = request.getParameter("aadhar_no");
        
        if (mId == null || fromMail == null || Aadhar_No == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        // Set up mail properties
        String host = "smtp.gmail.com"; // SMTP server
        String from = "triosjavateam@gmail.com"; // Your email address
        String password = "qxmascdsgyguogcr"; // Your email password
        
        // Setup mail session
        Properties properties = System.getProperties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", "465");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.socketFactory.port", "465");
        properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        Session session = Session.getInstance(properties, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            // Compose the message
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(fromMail));
            message.setSubject("Response Link for Your Request");

            // URL-encode the Aadhar number to handle special characters
            String encodedAadharNo = URLEncoder.encode(Aadhar_No, "UTF-8");
            String link = "http://localhost:8084/IP/View_Quetion.jsp?Aadhar=" + encodedAadharNo;

            message.setText("Click the following link to proceed with your request: " + link);

            // Send message
            Transport.send(message);
            System.out.println("Sent message successfully....");

        } catch (MessagingException mex) {
            mex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error sending email");
        }
        
        // Redirect back to the previous page or show a success message
        response.sendRedirect("View_Request.jsp");
    }
}
