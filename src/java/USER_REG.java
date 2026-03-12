import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
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

@WebServlet(urlPatterns = {"/USER_REG"})
public class USER_REG extends HttpServlet {

    // Method to send reset email
    private void sendResetEmail(String recipient, String question) {
        String host = "smtp.gmail.com";
        final String from = "triosjavateam@gmail.com";
        final String password = "qxmascdsgyguogcr";

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
            message.setSubject("ADD YOUR QUESTIONS AND ANSWERS");
            message.setText("To add your questions, click the link: http://localhost:8084/IP/QUESTION.jsp?question=" + question);

            Transport.send(message);
        } catch (MessagingException e) {
            System.out.println("Error sending email: " + e.getMessage());
        }
    }

    // Main registration process
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, FileUploadException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);

        try {
            String aadhar_no = "", username = "", password = "", confirm_password = "", address = "", mobile = "", email = "", dob = "", ipaddress = "";
            String saveFile = "";

            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(4012);

            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> items = upload.parseRequest(request);
            byte[] data = null;
            String fileName = null;

            for (FileItem item : items) {
                if (item.isFormField()) {
                    String name = item.getFieldName();
                    String value = item.getString();

                    if (name.equalsIgnoreCase("aadhar_no")) {
                        aadhar_no = value;
                    } else if (name.equalsIgnoreCase("username")) {
                        username = value;
                    } else if (name.equalsIgnoreCase("password")) {
                        password = value;
                    } else if (name.equalsIgnoreCase("confirm_password")) {
                        confirm_password = value;
                    } else if (name.equalsIgnoreCase("address")) {
                        address = value;
                    } else if (name.equalsIgnoreCase("mobile")) {
                        mobile = value;
                    } else if (name.equalsIgnoreCase("email")) {
                        email = value;
                    } else if (name.equalsIgnoreCase("dob")) {
                        dob = value;
                    } else if (name.equalsIgnoreCase("ipaddress")) {
                        ipaddress = value;
                    }
                } else {
                    data = item.get();
                    fileName = item.getName();
                }
            }

            saveFile = fileName;
            String path1 = request.getSession().getServletContext().getRealPath("/");
            String strPath1 = path1 + "\\" + saveFile;
            File file = new File(strPath1);
            try (FileOutputStream fileOut = new FileOutputStream(file)) {
                fileOut.write(data, 0, data.length);
            }

            try (FileInputStream fis = new FileInputStream(file)) {
                  Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip", "root", "admin");

                String query = "Select * from user_reg where aadhar_no=? or email=?";
                PreparedStatement st = con.prepareStatement(query);
                st.setString(1, aadhar_no);
                st.setString(2, email);
                ResultSet rs = st.executeQuery();

                if (rs.next()) {
                    session.setAttribute("msg", "Already exists. Please use a different Aadhar or email.");
                    response.sendRedirect("user.jsp");
                } else {
                    PreparedStatement st7 = con.prepareStatement("INSERT INTO user_reg VALUES (?,?,?,?,?,?,?,?,?,?,?,'INACTIVE')");
                    st7.setInt(1, 0);
                    st7.setString(2, aadhar_no);
                    st7.setString(3, username);
                    st7.setString(4, password);
                    st7.setString(5, confirm_password);
                    st7.setString(6, address);
                    st7.setString(7, mobile);
                    st7.setString(8, email);
                    st7.setString(9, dob);
                    if (fileName != "") {
                        st7.setBinaryStream(10, fis, (int) (file.length()));
                    } else {
                        st7.setBinaryStream(10, null);
                    }
                    st7.setString(11, ipaddress);

                    int i = st7.executeUpdate();

                    // Generate reset token
                    String question = java.util.UUID.randomUUID().toString();
                    // Send reset email
                    sendResetEmail(email, question);

                    session.setAttribute("msg", "Successfully registered. Check your email for reset instructions.");
                    response.sendRedirect("QUESTION.jsp");
                }
            }
        } catch (Exception e) {
            out.println(e);
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (FileUploadException | SQLException ex) {
            Logger.getLogger(USER_REG.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (FileUploadException | SQLException ex) {
            Logger.getLogger(USER_REG.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "User Registration Servlet with Email Functionality";
    }
}
