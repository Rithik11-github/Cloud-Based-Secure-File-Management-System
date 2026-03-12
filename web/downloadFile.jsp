<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*, java.sql.*, javax.crypto.*, javax.crypto.spec.SecretKeySpec, java.util.Base64, Connection.DbConnection" %>
<%@ page contentType="application/octet-stream" %>
<%@ page language="java" %>
<%
    // Get the encryption key from the form
    String encryptionKey = request.getParameter("encryption_key");

    // Validate that the key is provided
    if (encryptionKey == null || encryptionKey.isEmpty()) {
        session.setAttribute("msg", "Encryption key cannot be empty.");
        response.sendRedirect("DOWNLOAD.jsp");
        return;
    }

    // Retrieve the file from the database using the encryption key
    DbConnection dbConnection = new DbConnection();
    String query = "SELECT file_name, file_data FROM encrypted_documents WHERE encryption_key = ?";

    try (Connection con = dbConnection.con;
         PreparedStatement pstmt = con.prepareStatement(query)) {

        pstmt.setString(1, encryptionKey);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            String fileName = rs.getString("file_name");
            byte[] encryptedFileData = rs.getBytes("file_data");

            // Decrypt the file data
            byte[] decryptedFileData = decryptFile(encryptedFileData, encryptionKey);

            // Set response content type for file download
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength(decryptedFileData.length);

            // Write the decrypted file data to the response output stream
            try (OutputStream fileOutputStream = response.getOutputStream()) {
                fileOutputStream.write(decryptedFileData);
                fileOutputStream.flush();
            }

        } else {
            session.setAttribute("msg", "Invalid encryption key. File not found.");
            response.sendRedirect("DOWNLOAD.jsp");
        }

    } catch (SQLException e) {
        session.setAttribute("msg", "Error accessing the database: " + e.getMessage());
        response.sendRedirect("DOWNLOAD.jsp");
    }
%>

<%
    // Method to decrypt the file using AES
    public byte[] decryptFile(byte[] encryptedData, String encryptionKey) throws Exception {
        // Convert the encryption key to 16 bytes (AES key length)
        byte[] key = new byte[16];
        System.arraycopy(encryptionKey.getBytes(), 0, key, 0, Math.min(encryptionKey.length(), key.length));

        // Create AES key specification
        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");

        // Initialize the cipher for decryption
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);

        // Decrypt the file data
        return cipher.doFinal(encryptedData);
    }
%>
