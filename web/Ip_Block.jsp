<%@ page import="java.io.*, java.net.*, java.sql.*, org.json.JSONObject" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>IP Block Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #007bff;
        }
        .details {
            margin: 20px 0;
        }
        .details p {
            font-size: 18px;
        }
        .details p span {
            font-weight: bold;
            color: #007bff;
        }
    </style>
</head>
<body>

<%
    // Step 1: Capture the user's IP address
    String ipAddress = request.getRemoteAddr();

    // Step 2: Get the geolocation data using IP (you can use any geolocation API like ipinfo.io)
    String city = "";
    String latitude = "";
    
    // Your API key for the geolocation service (replace with your actual key)
    String apiKey = "a4db02a0eb7905";
    String apiUrl = "https://ipinfo.io/" + ipAddress + "/json?token=" + apiKey;
    
    try {
        // Make a request to the geolocation API
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        
        StringBuilder responseContent = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            responseContent.append(line);
        }
        reader.close();
        
        // Parse the JSON response
        JSONObject jsonResponse = new JSONObject(responseContent.toString());
        city = jsonResponse.getString("city");
        String loc = jsonResponse.getString("loc");  // loc is "latitude,longitude"
        String[] locArray = loc.split(",");
        latitude = locArray[0]; // Get the latitude part
    } catch (IOException e) {
        e.printStackTrace();
    }

   

    // Step 4: Insert into the database
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Establish database connection
        String dbUrl = "jdbc:mysql://localhost:3306/ip"; // Replace with actual DB URL
        String dbUser = "root"; // Replace with actual DB username
        String dbPassword = "admin"; // Replace with actual DB password
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // Prepare SQL query to insert into 'block' table
        String sql = "INSERT INTO block (ip, city, latitude) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);

        // Set parameters for the query
        pstmt.setString(1, ipAddress);
        pstmt.setString(2, city);
        pstmt.setString(3, latitude);

        // Execute the query
        pstmt.executeUpdate();

    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

    <div class="container">
        <h1>IP Block Details</h1>
        
        <div class="details">
            <p><span>IP Address:</span> <%= ipAddress %></p>
            <p><span>City:</span> <%= city %></p>
            <p><span>Latitude:</span> <%= latitude %></p>
        </div>
    </div>

</body>
</html>
