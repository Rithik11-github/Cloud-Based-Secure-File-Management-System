<%-- 
    Document   : login2
    Created on : 12 Nov, 2024, 11:59:39 AM
    Author     : Admin1
--%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.sql.*" %> 
<html>
<HEAD>
</HEAD>
<BODY>
<br><br><br><br><br>
<table width="250px" align="center" bgcolor="#CDFFFF" border=0 style="border:1px solid;">
<%
    String aadhar_no = request.getParameter("aadhar_no").trim();
    String Password = request.getParameter("Password").trim();
    Statement st;
    int timeLimit = 60;  // Initial time limit in seconds

    try {
        DbConnection db = new DbConnection();
        if (aadhar_no.equalsIgnoreCase("admin") && Password.equalsIgnoreCase("admin")) {
            session.setAttribute("username", aadhar_no);
            response.sendRedirect("adminreg.jsp");
        } else {
            String qry = "select * from user_reg where aadhar_no='" + aadhar_no + "' and Password='" + Password + "'";
            ResultSet rs = db.Select(qry);
            
            if (rs.next()) {
               
                    session.setAttribute("username", aadhar_no);
                    response.sendRedirect("USER_ANS.jsp?id=" + aadhar_no);
            } else {
            
              
                session.setAttribute("timeLimit", timeLimit);
                
                // Redirect based on the number of attempts
                response.sendRedirect("index_3.jsp?msg=" + "Incorrect ID or Password&timeLimit=" + timeLimit);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>




   <%
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
