<%-- 
    Document   : USER_LOGIN2
    Created on : 12 Nov, 2024, 2:59:42 PM
    Author     : Admin1
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
        
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
        
        
        <h1>Hello World!</h1>
    </body>
</html>
