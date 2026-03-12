<%-- 
    Document   : USER_ANS2
    Created on : 13 Nov, 2024, 11:34:19 AM
    Author     : Admin1
--%>

<%@ page import="java.sql.*, java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
    String aadharNo = (String) session.getAttribute("aadhar_no"); 

    if (aadharNo == null) {
        response.sendRedirect("login.jsp"); 
        return;
    }

    ArrayList<String[]> questionsSet2 = new ArrayList<>();
    boolean isSet2Correct = true;

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver"); 
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip", "root", "admin"); 

        // Only generate new random questions if not already stored in session
        if (session.getAttribute("questionsSet2") == null) {
            stmt = conn.prepareStatement("SELECT ques_id, question, answer FROM security_questions WHERE aadhar_no = ? ORDER BY RAND() LIMIT 5");
            stmt.setString(1, aadharNo);
            rs = stmt.executeQuery();

            while (rs.next()) {
                String[] questionData = {rs.getString("ques_id"), rs.getString("question"), rs.getString("answer")};
                questionsSet2.add(questionData);
            }

            session.setAttribute("questionsSet2", questionsSet2);
        } else {
            questionsSet2 = (ArrayList<String[]>) session.getAttribute("questionsSet2");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Process answers if submitted
    if (request.getParameter("submitSet2") != null) {
        questionsSet2 = (ArrayList<String[]>) session.getAttribute("questionsSet2");

        for (int i = 0; i < questionsSet2.size(); i++) {
            String userAnswer = request.getParameter("answer2_" + i);
            String correctAnswer = questionsSet2.get(i)[2];

            if (userAnswer == null || !userAnswer.equalsIgnoreCase(correctAnswer)) {
                isSet2Correct = false;
                break;
            }
        }

        // Clear session after check
        session.removeAttribute("questionsSet2");

        if (isSet2Correct) {
            response.sendRedirect("USER_HOME.jsp");
            return;
        } else {
            response.sendRedirect("BLOCK.jsp");
            return;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Security Check</title>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/form.css">
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

    <h2 class="header-title">Answer the Security Questions</h2>
    <div class="formbold-main-wrapper">
        <div class="formbold-form-wrapper">
            <form method="post" action="USER_ANS2.jsp">
                <div class="formbold-mb-3">
                    <div>
                        <%
                            for (int i = 0; i < questionsSet2.size(); i++) {
                                String question = questionsSet2.get(i)[1];
                        %>
                        <label class="formbold-form-label"><%= question %></label>
                        <input type="text" name="answer2_<%= i %>" class="formbold-form-input" required />
                        <% } %>
                    </div>
                </div>
                <input type="submit" value="Submit Set 2" class="formbold-btn" name="submitSet2">
            </form>
        </div>
    </div>
</body>
</html>
