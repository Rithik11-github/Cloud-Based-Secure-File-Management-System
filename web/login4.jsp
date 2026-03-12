<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>Login Processing</title>
</head>
<body>
<%
    String aadhar_no = request.getParameter("aadhar_no").trim();
    String Password = request.getParameter("Password").trim();
    String ip = request.getParameter("ip");
    String city = request.getParameter("city");
    String lat = request.getParameter("lat");
    String lan = request.getParameter("lan");

    Connection con = null;
    Statement st;
    try {
        // Establish database connection
        DbConnection db = new DbConnection();
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip", "root", "admin");

        // Admin Login Check
        if (aadhar_no.equalsIgnoreCase("admin") && Password.equalsIgnoreCase("admin")) {
            session.setAttribute("username", aadhar_no);
            response.sendRedirect("adminreg.jsp");
        } else {
            // User Login Check
            String qry = "SELECT * FROM user_reg WHERE aadhar_no = ? AND Password = ?";
            PreparedStatement pstUser = con.prepareStatement(qry);
            pstUser.setString(1, aadhar_no);
            pstUser.setString(2, Password);
            ResultSet rs = pstUser.executeQuery();

            if (rs.next()) {
                // Login Successful
                session.setAttribute("username", aadhar_no);
                response.sendRedirect("USER_ANS.jsp?id=" + aadhar_no);
            } else {
                // Log Failed Login Attempt
                String insertFake = "INSERT INTO block (ip, city, lat, lan) VALUES (?, ?, ?, ?)";
                PreparedStatement pstFake = con.prepareStatement(insertFake);
                pstFake.setString(1, ip);
                pstFake.setString(2, city);
                pstFake.setString(3, lat);
                pstFake.setString(4, lan);
                pstFake.executeUpdate();

                // Redirect to Error Page
                session.setAttribute("msg", "Invalid Aadhaar or Password. Attempt logged.");
                response.sendRedirect("index.jsp");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("msg", "An error occurred during login processing.");
        response.sendRedirect("fhgdufhg.jsp");
    } finally {
        // Close Connection
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<%
    // Display Session Message if Available
    String msg = (String) session.getAttribute("msg");
    if (msg != null) {
        %>
        <script>
            var ss = '<%=msg%>';
            alert(ss);
        </script>
        <%
                session.removeAttribute("msg");
            }
        %>
        
        
</table> 
</BODY>
</html>
