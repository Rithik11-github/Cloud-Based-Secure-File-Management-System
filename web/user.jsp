<%--
    Document   : USER_REGISTER
    Created on : 6 Nov, 2024
    Author     : Admin1
--%>
<%@page import="java.net.InetAddress"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - User Registration</title>
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
        <h1>Create Your Account</h1>
        <p>Register to access real-time disaster tracking and emergency coordination services.</p>
    </div>
</div>

<div class="dot-container">
    <span class="dot" onclick="currentSlide(1)"></span>
    <span class="dot" onclick="currentSlide(2)"></span>
   
</div>

<h2 class="header-title">User Registration</h2>

<div class="formbold-main-wrapper">
    <div class="formbold-form-wrapper">

        <!-- Info badge -->
        <div style="background:linear-gradient(90deg,rgba(26,107,189,0.08),rgba(0,201,167,0.08));border-radius:10px;padding:12px 16px;margin-bottom:24px;display:flex;align-items:center;gap:10px;font-size:0.88rem;color:#3a5068;">
            <i class="fas fa-shield-alt" style="color:#1a6bbd;font-size:1.1rem;"></i>
            Your information is encrypted and securely stored.
        </div>

        <form action="USER_REG" enctype="multipart/form-data" method="post" onsubmit="return Validate_Data(true)">

            <div class="formbold-mb-3">
                <label for="aadhar_no" class="formbold-form-label">
                    <i class="fas fa-id-card" style="color:#1a6bbd;margin-right:6px;"></i> Aadhaar Card No
                </label>
                <input type="number" name="aadhar_no" id="aadhar_no"
                       placeholder="Enter 12-digit Aadhaar Number"
                       class="formbold-form-input" maxlength="12" required />
            </div>

            <div class="formbold-mb-3">
                <label for="username" class="formbold-form-label">
                    <i class="fas fa-user" style="color:#1a6bbd;margin-right:6px;"></i> User Name
                </label>
                <input type="text" name="username" id="username"
                       placeholder="Enter Full Name"
                       class="formbold-form-input" required />
            </div>

            <div class="formbold-mb-3">
                <label for="email" class="formbold-form-label">
                    <i class="fas fa-envelope" style="color:#1a6bbd;margin-right:6px;"></i> Email ID
                </label>
                <input type="email" name="email" id="email"
                       placeholder="Enter Email Address"
                       class="formbold-form-input" required />
            </div>

            <div class="formbold-input-flex">
                <div>
                    <label for="password" class="formbold-form-label">
                        <i class="fas fa-lock" style="color:#1a6bbd;margin-right:6px;"></i> Password
                    </label>
                    <input type="password" name="password" id="password"
                           placeholder="Create Password"
                           class="formbold-form-input" required />
                </div>
                <div>
                    <label for="confirm_password" class="formbold-form-label">
                        <i class="fas fa-lock" style="color:#1a6bbd;margin-right:6px;"></i> Confirm Password
                    </label>
                    <input type="password" name="confirm_password" id="confirm_password"
                           placeholder="Re-enter Password"
                           class="formbold-form-input" required />
                </div>
            </div>

            <div class="formbold-mb-3">
                <label for="mobile" class="formbold-form-label">
                    <i class="fas fa-phone" style="color:#1a6bbd;margin-right:6px;"></i> Mobile Number
                </label>
                <input type="number" name="mobile" id="mobile"
                       placeholder="Enter 10-digit Mobile Number"
                       class="formbold-form-input" required />
            </div>

            <div class="formbold-mb-3">
                <label for="address" class="formbold-form-label">
                    <i class="fas fa-map-marker-alt" style="color:#1a6bbd;margin-right:6px;"></i> Address
                </label>
                <input type="text" name="address" id="address"
                       placeholder="Enter Full Address"
                       class="formbold-form-input" required />
            </div>

            <div class="formbold-mb-3">
                <label for="ipaddress" class="formbold-form-label">
                    <i class="fas fa-network-wired" style="color:#1a6bbd;margin-right:6px;"></i> IP Address
                </label>
                <input type="text" name="ipaddress" id="ipaddress"
                       class="formbold-form-input"
                       value="<%=InetAddress.getLocalHost().getHostAddress()%>" readonly />
            </div>

            <div class="formbold-mb-3">
                <label for="dob" class="formbold-form-label">
                    <i class="fas fa-calendar-alt" style="color:#1a6bbd;margin-right:6px;"></i> Date of Birth
                </label>
                <input type="date" name="dob" id="dob"
                       class="formbold-form-input" required />
            </div>

            <div class="formbold-form-file-flex">
                <label for="upload" class="formbold-form-label">
                    <i class="fas fa-camera" style="color:#1a6bbd;margin-right:6px;"></i> Profile Image
                </label>
                <input type="file" name="profile_pic" id="upload"
                       class="formbold-form-file"
                       accept="image/*" />
                <div style="font-size:0.78rem;color:#a8bcd0;margin-top:6px;">Accepted: JPG, PNG, WEBP (max 2MB)</div>
            </div>

            <button class="formbold-btn" type="submit">
                <i class="fas fa-user-plus" style="margin-right:8px;"></i> Register Now
            </button>
        </form>

        <br>
        <div class="signup-text">Already have an account? <a href="USER_LOGIN.jsp">Login here</a></div>
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
        </div>
     
    </div>
</section>

<script src="js/main.js"></script>
</body>
</html>
