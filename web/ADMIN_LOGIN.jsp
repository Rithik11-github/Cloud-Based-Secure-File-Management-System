<%--
    Document   : ADMIN_LOGIN
    Created on : 6 Aug, 2024
    Author     : Admin1
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - Admin Login</title>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/form.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
        <h1>Admin Control Panel</h1>
        <p>Restricted access — authorized personnel only. Manage and monitor the TrackSafe system.</p>
    </div>
</div>

<div class="dot-container">
    <span class="dot" onclick="currentSlide(1)"></span>
    <span class="dot" onclick="currentSlide(2)"></span>
   
</div>

<h2 class="header-title">Admin Login</h2>

<div class="formbold-main-wrapper">
    <div class="formbold-form-wrapper">

        <!-- Security Badge -->
        <div style="background:linear-gradient(90deg,rgba(255,107,53,0.08),rgba(26,107,189,0.06));border:1px solid rgba(255,107,53,0.2);border-radius:10px;padding:12px 16px;margin-bottom:28px;display:flex;align-items:center;gap:10px;font-size:0.88rem;color:#bf4c1a;">
            <i class="fas fa-exclamation-triangle" style="font-size:1rem;"></i>
            This area is restricted to authorized administrators only.
        </div>

        <!-- Icon Header -->
        <div style="text-align:center;margin-bottom:28px;">
            <div style="width:64px;height:64px;background:linear-gradient(135deg,#0f3460,#1a6bbd);border-radius:16px;display:inline-flex;align-items:center;justify-content:center;box-shadow:0 8px 24px rgba(15,52,96,0.35);">
                <i class="fas fa-user-cog" style="color:#fff;font-size:1.6rem;"></i>
            </div>
            <p style="color:#6a84a0;font-size:0.9rem;margin-top:12px;">Administrator authentication</p>
        </div>

        <form action="ADMIN_LOG" method="post">

            <div class="formbold-mb-3">
                <label for="userName" class="formbold-form-label">
                    <i class="fas fa-user-tie" style="color:#1a6bbd;margin-right:6px;"></i> Admin Name
                </label>
                <input type="text" name="userName" id="userName"
                       placeholder="Enter Admin Username"
                       class="formbold-form-input" required />
            </div>

            <div class="formbold-mb-3">
                <label for="adminPwd" class="formbold-form-label">
                    <i class="fas fa-key" style="color:#1a6bbd;margin-right:6px;"></i> Password
                </label>
                <div style="position:relative;">
                    <input type="password" name="password" id="adminPwd"
                           placeholder="Enter Admin Password"
                           class="formbold-form-input" required
                           style="padding-right:48px;" />
                    <button type="button" onclick="toggleAdminPwd()"
                            style="position:absolute;right:14px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:#6a84a0;font-size:1rem;padding:0;">
                        <i class="fas fa-eye" id="admin-pwd-icon"></i>
                    </button>
                </div>
            </div>

            <button class="formbold-btn" type="submit"
                    style="background:linear-gradient(135deg,#0f3460,#1a6bbd);">
                <i class="fas fa-unlock-alt" style="margin-right:8px;"></i> Login to Dashboard
            </button>
        </form>
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
function toggleAdminPwd() {
    var f = document.getElementById('adminPwd');
    var icon = document.getElementById('admin-pwd-icon');
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
