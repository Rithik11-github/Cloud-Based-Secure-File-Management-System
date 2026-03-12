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
<%@page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - Disaster Tracking System</title>
    <link rel="stylesheet" href="css/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.9.1/font/bootstrap-icons.min.css" rel="stylesheet">
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
    // Block IP address if found in the database
    String ip = InetAddress.getLocalHost().getHostAddress();
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip", "root", "admin");
        String qry = "SELECT * FROM block WHERE ip='" + ip + "'";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(qry);
        if (rs.next()) {
            response.sendRedirect("Error.jsp");
        }
        con.close();
    } catch (Exception e) {
        // log error silently
    }
%>

<!-- Navigation -->
<nav>
    <ul>
        <li><a href="index.jsp">HOME</a></li>
        <li><a href="user.jsp">USER REGISTER</a></li>
        <li><a href="USER_LOGIN.jsp">USER LOGIN</a></li>
        <li><a href="ADMIN_LOGIN.jsp">ADMIN LOGIN</a></li>
        <li><a href="MAIL.jsp">MAIL</a></li>
    </ul>
</nav>

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

<!-- Hero Slideshow -->
<div class="slideshow-container">
    <img class="slides" src="images/home1.jpg" alt="Tracking Concept 1">
    <img class="slides" src="images/home2.jpg" alt="Tracking Concept 2">
   
    <div class="centered">
        <h1>Welcome to TrackSafe</h1>
        <p>Real-time disaster tracking and emergency coordination — keeping communities safe when it matters most.</p>
    </div>
</div>

<div class="dot-container">
    <span class="dot" onclick="currentSlide(1)"></span>
    <span class="dot" onclick="currentSlide(2)"></span>
 
</div>

<!-- About Section -->
<section id="about" class="about section">
    <div class="container">
        <div class="container section-title">
            <h2>About Us</h2>
        </div>

        <div class="row">
            <div class="col-lg-6 order-1">
                <img src="images/home1.jpg" class="img-fluid" alt="About TrackSafe">
            </div>
            <div class="col-lg-6 order-2 content">
                <p>Our platform provides comprehensive disaster management with timely coordination and support — empowering communities and responders alike.</p>
                <h3>Why Trust Our Platform for Your Safety?</h3>
                <p class="fst-italic" style="color:#6a84a0;">Ensuring your safety through seamless emergency coordination and trusted services.</p>
                <ul>
                    <li><i class="bi bi-check-circle"></i>
                        <span>Real-Time Weather Monitoring and Data Analysis for informed and effective crisis management.</span></li>
                    <li><i class="bi bi-check-circle"></i>
                        <span>Comprehensive Disaster Relief through seamless integration of emergency services and resources.</span></li>
                    <li><i class="bi bi-check-circle"></i>
                        <span>Timely and coordinated response with dedicated emergency support teams for maximum efficiency.</span></li>
                </ul>
            </div>
        </div>
    </div>
</section>

<!-- Services Section -->
<section id="service" style="background:#f4f9ff; padding:80px 40px;">
    <div class="container">
        <div class="container section-title">
            <h2>Our Services</h2>
        </div>
        <div class="features">
            <div class="feature-box">
                <img src="images/serv1.webp" alt="Real-Time Tracking">
                <h3>Real-Time Tracking</h3>
                <p>Monitor activities and locations with live updates to ensure rapid response during emergencies.</p>
            </div>
            <div class="feature-box">
                <img src="images/serv2.webp" alt="Secure Access">
                <h3>Secure Access</h3>
                <p>Protect sensitive user data with advanced encryption methods and role-based access control.</p>
            </div>
            <div class="feature-box">
                <img src="images/serv3.webp" alt="Easy Integration">
                <h3>Easy Integration</h3>
                <p>Seamlessly integrate with your existing emergency management systems and workflows.</p>
            </div>
        </div>
    </div>
</section>

<!-- Stats Strip -->
<div style="background:linear-gradient(90deg,#0f4a8a,#1a6bbd,#1b8ca6);padding:40px;display:flex;justify-content:center;gap:60px;flex-wrap:wrap;">
    <div style="text-align:center;color:#fff;">
        <div style="font-family:'Rajdhani',sans-serif;font-size:2.8rem;font-weight:700;color:#00c9a7;">24/7</div>
        <div style="font-size:0.9rem;opacity:0.85;margin-top:4px;">Monitoring Active</div>
    </div>
    <div style="text-align:center;color:#fff;">
        <div style="font-family:'Rajdhani',sans-serif;font-size:2.8rem;font-weight:700;color:#00c9a7;">500+</div>
        <div style="font-size:0.9rem;opacity:0.85;margin-top:4px;">Areas Covered</div>
    </div>
    <div style="text-align:center;color:#fff;">
        <div style="font-family:'Rajdhani',sans-serif;font-size:2.8rem;font-weight:700;color:#00c9a7;">10K+</div>
        <div style="font-size:0.9rem;opacity:0.85;margin-top:4px;">Users Protected</div>
    </div>
    <div style="text-align:center;color:#fff;">
        <div style="font-family:'Rajdhani',sans-serif;font-size:2.8rem;font-weight:700;color:#00c9a7;">99.9%</div>
        <div style="font-size:0.9rem;opacity:0.85;margin-top:4px;">System Uptime</div>
    </div>
</div>

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
            <div>
                <h3>Contact</h3>
                <ul>
                    <li><a href="mailto:support@tracksafe.in"><i class="fas fa-envelope"></i> support@tracksafe.in</a></li>
                    <li><a href="tel:+911800000000"><i class="fas fa-phone"></i> 1800-000-0000</a></li>
                    <li><a href="#"><i class="fas fa-map-marker-alt"></i> Chennai, Tamil Nadu</a></li>
                </ul>
            </div>
        </div>
       
    </div>
</section>

<script src="js/main.js"></script>
</body>
</html>
