import Connection.DbConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/**
 *
 * @author Admin1
 */
@WebServlet(urlPatterns = {"/USER_LOG2"})
public class USER_LOG2 extends HttpServlet {
  
      protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);

    
    String usrid = request.getParameter("userid").trim();
    String passwd = request.getParameter("password").trim();
    Statement st;
    int timeLimit = 60;  // Initial time limit in seconds

    try {
        DbConnection db = new DbConnection();
        if (usrid.equalsIgnoreCase("admin") && passwd.equalsIgnoreCase("admin")) {
            session.setAttribute("username", usrid);
            response.sendRedirect("adminreg.jsp");
        } else {
            String qry = "select * from user where id='" + usrid + "' and pass='" + passwd + "'";
            ResultSet rs = db.Select(qry);
            
            if (rs.next()) {
                if (rs.getInt("status") == 0) {
                    response.sendRedirect("index.jsp?msg=" + "User Blocked");
                } else {
                    session.setAttribute("username", usrid);
                    response.sendRedirect("Search_Check.jsp?id=" + usrid);
                }
            } else {
                // Retrieve the hit counter and time limit from the session
                Integer hitsCount = (Integer) session.getAttribute("hitCounter");
                if (hitsCount == null) {
                    hitsCount = 0;
                } else {
                    hitsCount += 1;
                }
                
                // Set the time limit based on the number of failed attempts
                if (hitsCount == 0) {
                    timeLimit = 60;
                } else if (hitsCount == 2) {
                    timeLimit = 40;
                } else if (hitsCount >= 3) {
                    timeLimit = 25;
                }
                
                // Store updated count and time limit in session
                session.setAttribute("hitCounter", hitsCount);
                session.setAttribute("timeLimit", timeLimit);
                
                // Redirect based on the number of attempts
                response.sendRedirect("index_1.jsp?msg=" + "Incorrect ID or Password&timeLimit=" + timeLimit);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
      }
}