import java.io.*;
import java.security.*;
import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import Connection.DbConnection;
import java.sql.PreparedStatement;
import java.util.Base64;
import javax.servlet.annotation.WebServlet;

@WebServlet("/Upload_File")
@MultipartConfig  // Handles file uploads
public class Upload_File extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();  // Retrieve session object
        Part filePart = request.getPart("Docmnt");   // Retrieves the file part
        String aadhar_no = request.getParameter("aadhar_no");
        String email = request.getParameter("email");

        // Retrieve file name and size
        String fileName = filePart.getSubmittedFileName(); // Get the original file name
        long fileSize = filePart.getSize(); // Get the file size

        // Read file content
        InputStream fileContent = filePart.getInputStream();
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] data = new byte[1024];
        int bytesRead;
        while ((bytesRead = fileContent.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, bytesRead);
        }
        byte[] fileBytes = buffer.toByteArray();

        // Generate AES key
        KeyGenerator keyGen;
        SecretKey secretKey;
        try {
            keyGen = KeyGenerator.getInstance("AES");
            keyGen.init(128); // 128-bit AES
            secretKey = keyGen.generateKey();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error generating encryption key: " + e.getMessage());
            response.sendRedirect("UPLOAD_DOCUMENT.jsp");
            return;
        }

        // Encrypt the file
        byte[] encryptedFileBytes;
        try {
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            encryptedFileBytes = cipher.doFinal(fileBytes);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Error encrypting file: " + e.getMessage());
            response.sendRedirect("UPLOAD_DOCUMENT.jsp");
            return;
        }

        // Convert encryption key to a string for saving or future reference
        String encodedKey = Base64.getEncoder().encodeToString(secretKey.getEncoded());

        // Save encrypted file, encryption key, file name, and file size in the database
        DbConnection db = new DbConnection();
        try {
            String insertQuery = "INSERT INTO documents (aadhar_no, email, file_data, encryption_key, file_name, file_size) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = db.con.prepareStatement(insertQuery);
            stmt.setString(1, aadhar_no);
            stmt.setString(2, email);
            stmt.setBlob(3, new ByteArrayInputStream(encryptedFileBytes)); // Save encrypted file as BLOB
            stmt.setString(4, encodedKey); // Save the encryption key for future decryption
            stmt.setString(5, fileName); // Save the file name
            stmt.setLong(6, fileSize); // Save the file size
            int result = stmt.executeUpdate();

            if (result > 0) {
                session.setAttribute("msg", "File uploaded and encrypted successfully.");
            } else {
                session.setAttribute("msg", "Error in uploading file.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Database error: " + e.getMessage());
        }

        // Redirect to the upload page
        response.sendRedirect("UPLOAD_DOCUMENT.jsp");
    }
}
