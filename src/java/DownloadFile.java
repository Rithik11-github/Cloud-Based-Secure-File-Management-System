import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Connection.DbConnection;
import java.util.Base64;
import javax.servlet.annotation.WebServlet;

@WebServlet("/DownloadFile")
public class DownloadFile extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String encryptionKey = request.getParameter("encryption_key");

        if (encryptionKey == null || encryptionKey.isEmpty()) {
            response.getWriter().println("Error: Encryption key is required.");
            return;
        }

        DbConnection db = new DbConnection();
        Connection conn = db.con;

        try {
            // Query to retrieve the file data and encryption key from the database
            String query = "SELECT file_data, encryption_key FROM documents WHERE encryption_key = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, encryptionKey);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                byte[] encryptedData = rs.getBytes("file_data");
                String storedKey = rs.getString("encryption_key");

                // Validate the encryption key
                if (!storedKey.equals(encryptionKey)) {
                     request.getSession().setAttribute("msg","Invalid encryption key.");
                  response.sendRedirect("USER_LOGIN.jsp");
                  
                    return;
                }

                // Decrypt the file
                byte[] decryptedData = decryptFile(encryptedData, encryptionKey);

                // Generate a new encryption key
                String newEncryptionKey = generateNewEncryptionKey();

                // Re-encrypt the file with the new encryption key
                byte[] reEncryptedData = encryptFile(decryptedData, newEncryptionKey);

                // Update the database with the new encryption key and file data
                String updateQuery = "UPDATE documents SET file_data = ?, encryption_key = ? WHERE encryption_key = ?";
                PreparedStatement updatePs = conn.prepareStatement(updateQuery);
                updatePs.setBytes(1, reEncryptedData);
                updatePs.setString(2, newEncryptionKey);
                updatePs.setString(3, encryptionKey);

                int updateCount = updatePs.executeUpdate();

                if (updateCount > 0) {
                    // Set response headers for the file download
                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-Disposition", "attachment; filename=\"decrypted_file\"");

                    // Write decrypted data to the response output stream for download
                    OutputStream os = response.getOutputStream();
                    os.write(decryptedData);
                    os.flush();
                    os.close();

                    // Provide message to the user in a separate response context
                    request.getSession().setAttribute("msg", "Encryption key updated successfully. Use the new key for future downloads.");
                    response.sendRedirect("DOWNLOAD.jsp");  // Redirect to another page to show the success message
                } else {
                    request.getSession().setAttribute("msg","Unable to update encryption key.");
                  response.sendRedirect("DOWNLOAD.jsp");
                }
            } else {
                 request.getSession().setAttribute("msg","File not found for the provided encryption key.");
                  response.sendRedirect("DOWNLOAD.jsp");
            }
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private byte[] decryptFile(byte[] encryptedData, String encryptionKey) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(encryptionKey);

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKey);

        return cipher.doFinal(encryptedData);
    }

    private byte[] encryptFile(byte[] data, String encryptionKey) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(encryptionKey);

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);

        return cipher.doFinal(data);
    }

    private String generateNewEncryptionKey() throws Exception {
        // Generate a new AES key
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(128); // AES supports 128, 192, or 256-bit keys
        SecretKey secretKey = keyGen.generateKey();

        // Encode the key as a Base64 string
        return Base64.getEncoder().encodeToString(secretKey.getEncoded());
    }
}
