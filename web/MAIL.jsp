<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - Send Mail</title>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/mail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<nav>
    <ul>
        <li><a href="index.jsp">HOME</a></li>
        <li><a href="user.jsp">USER REGISTER</a></li>
        <li><a href="USER_LOGIN.jsp">USER LOGIN</a></li>
        <li><a href="ADMIN_LOGIN.jsp">ADMIN LOGIN</a></li>
        <li><a href="MAIL.jsp">MAIL</a></li>
    </ul>
</nav>

<!-- Page Title -->
<div style="margin-top:70px;background:linear-gradient(135deg,#0f4a8a,#1a6bbd);padding:48px 40px;text-align:center;">
    <div style="width:60px;height:60px;background:rgba(255,255,255,0.15);border-radius:14px;display:inline-flex;align-items:center;justify-content:center;margin-bottom:16px;">
        <i class="fas fa-paper-plane" style="color:#fff;font-size:1.5rem;"></i>
    </div>
    <h1 style="font-family:'Rajdhani',sans-serif;font-size:2rem;font-weight:700;color:#fff;margin-bottom:8px;">Send a Message</h1>
    <p style="color:rgba(255,255,255,0.78);font-size:0.95rem;">Contact the TrackSafe support team directly.</p>
</div>

<div style="background:#eef4fc;padding:48px 16px;">
<div class="mails-container">

    <!-- Info Strip -->
    <div style="background:linear-gradient(90deg,rgba(0,201,167,0.08),rgba(26,107,189,0.06));border:1px solid rgba(0,201,167,0.2);border-radius:10px;padding:12px 16px;margin-bottom:28px;display:flex;align-items:center;gap:10px;font-size:0.88rem;color:#00796b;">
        <i class="fas fa-info-circle"></i>
        Enter your registered email to auto-fetch your Aadhaar. Your message goes directly to our support team.
    </div>

    <form action="Request_Mail" method="post" enctype="multipart/form-data">
        <table>
            <tr>
                <td><b><font color="red">From:</font></b></td>
                <td>
                    <input type="text" id="from_mail" name="from_mail"
                           onblur="fetchAadhar()"
                           placeholder="your@email.com" required>
                    <input type="hidden" id="aadhar" name="Aadhar" readonly>
                    <div id="aadhar-status" style="font-size:0.78rem;margin-top:4px;color:#6a84a0;"></div>
                </td>
            </tr>
            <tr>
                <td><b><font color="red">To:</font></b></td>
                <td>
                    <input type="text" name="To" value="triosjavateam@gmail.com" readonly>
                </td>
            </tr>
            <tr>
                <td><b><font color="red">Subject:</font></b></td>
                <td>
                    <input type="text" name="subject" placeholder="Enter message subject" required>
                </td>
            </tr>
            <tr>
                <td style="vertical-align:top;padding-top:12px;"><b><font color="red">Message:</font></b></td>
                <td>
                    <textarea rows="10" name="Message" placeholder="Write your message here..." required></textarea>
                </td>
            </tr>
            <tr>
                <td><b><font color="red">Date:</font></b></td>
                <td>
                    <input type="date" id="current-date" name="current_date" readonly>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <input type="submit" value="Send Message">
                    <input type="reset" value="Clear">
                </td>
            </tr>
        </table>
    </form>
</div>
</div>

<script>
function fetchAadhar() {
    var fromMail = document.getElementById("from_mail").value;
    var status = document.getElementById("aadhar-status");

    if (!fromMail) {
        status.textContent = '';
        return;
    }

    status.textContent = 'Verifying email...';
    status.style.color = '#1a6bbd';

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "VerifyMailServlet", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var response = xhr.responseText.trim();
            if (response === "not_found") {
                status.textContent = '⚠ Email not found in the database.';
                status.style.color = '#e53935';
                document.getElementById("aadhar").value = '';
            } else if (response === "error") {
                status.textContent = '⚠ Verification error. Please try again.';
                status.style.color = '#e53935';
            } else {
                document.getElementById("aadhar").value = response;
                status.textContent = '✓ Email verified successfully.';
                status.style.color = '#00897b';
            }
        }
    };

    xhr.send("from_mail=" + encodeURIComponent(fromMail));
}

// Set current date
var today = new Date();
document.getElementById('current-date').value = today.toISOString().split('T')[0];
</script>

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
</body>
</html>
