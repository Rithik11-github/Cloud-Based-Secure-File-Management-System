<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.sql.*, java.io.*" %>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="Connection.DbConnection"%>
<%@page import="java.net.Inet4Address"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="java.util.Enumeration"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - User Login</title>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/form.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <%
        String userIP = "Unknown";
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces.hasMoreElements()) {
                NetworkInterface iface = interfaces.nextElement();
                Enumeration<InetAddress> addresses = iface.getInetAddresses();
                while (addresses.hasMoreElements()) {
                    InetAddress addr = addresses.nextElement();
                    if (!addr.isLoopbackAddress() && addr instanceof Inet4Address) {
                        userIP = addr.getHostAddress(); break;
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        DbConnection dbd = new DbConnection(); int count = 0;
        try {
            String query = "SELECT COUNT(*) AS ip FROM block WHERE ip = ?";
            PreparedStatement ps = dbd.con.prepareStatement(query);
            ps.setString(1, userIP);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt("ip");
            rs.close(); ps.close();
        } catch (SQLException e) { e.printStackTrace(); }
        if (count >= 1) response.sendRedirect("Error.jsp");
    %>
</head>
<body>

<%
    String msg = (String) session.getAttribute("msg");
    if (msg != null && !msg.isEmpty()) {
%>
<script>
    window.addEventListener('DOMContentLoaded', function(){
        showToast('<%=msg%>', 'success');
    });
</script>
<%
    session.removeAttribute("msg");
    }
%>

<nav>
    <ul>
        <li><a href="index.jsp">HOME</a></li>
        <li><a href="user.jsp">USER REGISTER</a></li>
        <li><a href="USER_LOGIN.jsp">USER LOGIN</a></li>
        <li><a href="ADMIN_LOGIN.jsp">ADMIN LOGIN</a></li>
        <li><a href="MAIL.jsp">MAIL</a></li>
    </ul>
</nav>

<!-- Hero Slideshow -->
<div class="slideshow-container">
    <img class="slides" src="images/home1.jpg" alt="Tracking Concept 1">
    <img class="slides" src="images/home2.jpg" alt="Tracking Concept 2">
   
    <div class="centered">
        <h1>Welcome Back</h1>
        <p>Log in to access your TrackSafe dashboard and real-time monitoring tools.</p>
    </div>
</div>

<div class="dot-container">
    <span class="dot" onclick="currentSlide(1)"></span>
    <span class="dot" onclick="currentSlide(2)"></span>
   
</div>

<h2 class="header-title">User Login</h2>

<div class="formbold-main-wrapper">
    <div class="formbold-form-wrapper">

        <!-- Icon Header -->
        <div style="text-align:center;margin-bottom:28px;">
            <div style="width:64px;height:64px;background:linear-gradient(135deg,#1a6bbd,#0f4a8a);border-radius:16px;display:inline-flex;align-items:center;justify-content:center;box-shadow:0 8px 24px rgba(26,107,189,0.3);">
                <i class="fas fa-user-shield" style="color:#fff;font-size:1.6rem;"></i>
            </div>
            <p style="color:#6a84a0;font-size:0.9rem;margin-top:12px;">Secure user authentication</p>
        </div>

        <form id="loginForm" action="USER_LOG" method="post" onsubmit="return validateAll(true);">

            <div class="formbold-mb-3">
                <label for="aadhar_no" class="formbold-form-label">
                    <i class="fas fa-id-card" style="color:#1a6bbd;margin-right:6px;"></i> Aadhaar No
                </label>
                <input type="text" name="aadhar_no" id="aadhar_no"
                       placeholder="Enter your 12-digit Aadhaar Number"
                       class="formbold-form-input" required />
            </div>

            <div class="formbold-mb-3">
                <label for="Password" class="formbold-form-label">
                    <i class="fas fa-lock" style="color:#1a6bbd;margin-right:6px;"></i> Password
                </label>
                <div style="position:relative;">
                    <input type="password" name="Password" id="Password"
                           placeholder="Enter your Password"
                           class="formbold-form-input" required
                           style="padding-right:48px;" />
                    <button type="button" onclick="togglePwd('Password')"
                            style="position:absolute;right:14px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:#6a84a0;font-size:1rem;padding:0;">
                        <i class="fas fa-eye" id="pwd-icon"></i>
                    </button>
                </div>
            </div>

            <div style="text-align:right;margin-top:-12px;margin-bottom:20px;">
                <a href="forget_password.jsp" style="color:#1a6bbd;font-size:0.85rem;font-weight:600;text-decoration:none;">
                    <i class="fas fa-key" style="margin-right:4px;"></i> Forgot Password?
                </a>
            </div>

            <button class="formbold-btn" type="submit">
                <i class="fas fa-sign-in-alt" style="margin-right:8px;"></i> Login Now
            </button>
        </form>

        <br>
        <div class="signup-text">Don't have an account? <a href="user.jsp">Register here</a></div>
    </div>
</div>

<!-- Footer -->

<section id="contact">
    <div class="container">
        <div class="contact-info">
            <div class="social-media">
                <h3>Follow Us</h3>
                <ul>
                    <li><a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i> Facebook</a></li>
                    <li><a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i> Twitter</a></li>
                    <li><a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i> Instagram</a></li>
                    <li><a href="https://linkedin.com" target="_blank"><i class="fab fa-linkedin"></i> LinkedIn</a></li>
                </ul>
            </div>
            <div class="useful-links">
                <h3>Useful Links</h3>
                <ul>
                    <li><a href="/about-us">About Us</a></li>
                    <li><a href="/faq">FAQ</a></li>
                    <li><a href="/terms">Terms &amp; Conditions</a></li>
                    <li><a href="/privacy-policy">Privacy Policy</a></li>
                </ul>
            </div>
            <div class="services">
                <h3>Our Services</h3>
                <ul>
                    <li><a href="/services/tracking">Live Tracking</a></li>
                    <li><a href="/services/alerts">Emergency Alerts</a></li>
                    <li><a href="/services/reports">Incident Reports</a></li>
                    <li><a href="/services/support">24/7 Support</a></li>
                </ul>
            </div>
        </div>
       
    </div>
</section>

<script src="js/main.js"></script>
<script>
function togglePwd(id) {
    var f = document.getElementById(id);
    var icon = document.getElementById('pwd-icon');
    if (f.type === 'password') {
        f.type = 'text';
        icon.className = 'fas fa-eye-slash';
    } else {
        f.type = 'password';
        icon.className = 'fas fa-eye';
    }
}
</script>
</body>
</html>
