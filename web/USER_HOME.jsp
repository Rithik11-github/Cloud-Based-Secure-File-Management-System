<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - Dashboard Home</title>
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<%
    String msg = (String) session.getAttribute("msg");
    if (msg != null && !msg.isEmpty()) { %>
<script>window.addEventListener('DOMContentLoaded',function(){showToast('<%=msg%>','success');});</script>
<% session.removeAttribute("msg"); }
   String uname = (String) session.getAttribute("username");
   if (uname == null) uname = "User";
   String init = uname.length() > 0 ? String.valueOf(uname.charAt(0)).toUpperCase() : "U";
%>

<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="sidebar-brand-icon">&#128752;</div>
        <span class="sidebar-brand-text">TrackSafe</span>
        <div class="sidebar-toggle-btn">&#10094;</div>
    </div>
    <div class="sidebar-user">
        <div class="sidebar-avatar"><%=init%></div>
        <div class="sidebar-user-info">
            <div class="sidebar-user-name"><%=uname%></div>
            <div class="sidebar-user-role">Registered User</div>
        </div>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section-label">Main Menu</div>
        <a href="USER_HOME.jsp" class="nav-item active" data-tip="Home">
            <div class="nav-icon">&#127968;</div><span class="nav-label">Home</span></a>
        <a href="UPLOAD_DOCUMENT.jsp" class="nav-item" data-tip="Upload Document">
            <div class="nav-icon">&#128196;</div><span class="nav-label">Upload Document</span></a>
        <a href="SEARCH.jsp" class="nav-item" data-tip="Search Document">
            <div class="nav-icon">&#128269;</div><span class="nav-label">Search Document</span></a>
        <a href="USER_VIEW_GROUPS.jsp" class="nav-item" data-tip="My Groups">
            <div class="nav-icon">&#128101;</div><span class="nav-label">My Groups</span></a>
        <div class="nav-section-label">Account</div>
        <a href="index.jsp" class="nav-item logout" data-tip="Logout">
            <div class="nav-icon">&#128682;</div><span class="nav-label">Logout</span></a>
    </nav>
</aside>

<div class="main-wrapper">
    <header class="topbar">
        <div class="topbar-toggle">&#9776;</div>
        <div class="topbar-breadcrumb">
            <span>TrackSafe</span><span class="sep"> / </span>
            <span class="current">Dashboard</span>
        </div>
        <div class="topbar-spacer"></div>
        <div class="topbar-search">
            <span class="topbar-search-icon">&#128269;</span>
            <input type="text" placeholder="Quick search...">
        </div>
        <div class="topbar-notif">&#128276;<span class="notif-badge"></span></div>
    </header>

    <main class="page-content">
        <div class="page-header">
            <h1>Dashboard</h1>
            <p>Overview of your activity and platform status.</p>
        </div>

        <div class="dashboard-hero">
            <div class="hero-text">
                <h2>Welcome back, <%=uname%>! &#128075;</h2>
                <p>Your real-time disaster tracking dashboard is active. Upload documents, search files, and collaborate with secure groups.</p>
                <div class="hero-badges">
                    <span class="hero-badge green">&#9679; System Online</span>
                    <span class="hero-badge blue">&#128204; Live Monitoring</span>
                </div>
            </div>
        </div>

        

        <div class="card">
            <div class="card-header">
                <div class="card-title"><div class="card-title-icon">&#128737;</div>About Our Platform</div>
            </div>
            <div class="card-body">
                <div style="display:flex;gap:28px;flex-wrap:wrap;align-items:center;">
                    <div style="flex:1;min-width:240px;">
                        <p style="color:var(--text-mid);line-height:1.7;margin-bottom:14px;">Our platform provides comprehensive disaster management with timely coordination and support.</p>
                        <ul style="list-style:none;display:flex;flex-direction:column;gap:9px;">
                            <li style="display:flex;gap:10px;padding:10px 14px;background:rgba(37,99,235,0.05);border-radius:8px;border-left:3px solid var(--accent2);font-size:0.855rem;color:var(--text-mid);">
                                <span>&#10003;</span> Real-Time Weather Monitoring and Data Analysis for effective crisis management.</li>
                            <li style="display:flex;gap:10px;padding:10px 14px;background:rgba(37,99,235,0.05);border-radius:8px;border-left:3px solid var(--accent);font-size:0.855rem;color:var(--text-mid);">
                                <span>&#10003;</span> Comprehensive Disaster Relief through seamless integration of emergency services.</li>
                            <li style="display:flex;gap:10px;padding:10px 14px;background:rgba(37,99,235,0.05);border-radius:8px;border-left:3px solid var(--primary);font-size:0.855rem;color:var(--text-mid);">
                                <span>&#10003;</span> Timely coordinated response with dedicated emergency support teams.</li>
                        </ul>
                    </div>
                    <div style="flex:0 0 240px;">
                        <img src="images/home1.jpg" style="width:100%;border-radius:12px;object-fit:cover;height:190px;box-shadow:var(--shadow);" alt="About">
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header"><div class="card-title"><div class="card-title-icon">&#9889;</div>Quick Actions</div></div>
            <div class="card-body" style="display:flex;gap:12px;flex-wrap:wrap;">
                <a href="UPLOAD_DOCUMENT.jsp" class="btn btn-primary">&#128196; Upload Document</a>
                <a href="SEARCH.jsp" class="btn btn-secondary">&#128269; Search Files</a>
                <a href="USER_VIEW_GROUPS.jsp" class="btn btn-secondary">&#128101; View Groups</a>
            </div>
        </div>
    </main>

    <footer class="dashboard-footer">
        <div class="footer-inner">
            <div class="footer-col"><h4>Follow Us</h4><ul>
                <li><a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i> Facebook</a></li>
                <li><a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i> Twitter</a></li>
                <li><a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i> Instagram</a></li>
                <li><a href="https://linkedin.com" target="_blank"><i class="fab fa-linkedin"></i> LinkedIn</a></li>
            </ul></div>
            <div class="footer-col"><h4>Useful Links</h4><ul>
                <li><a href="/about-us">About Us</a></li><li><a href="/faq">FAQ</a></li>
                <li><a href="/terms">Terms &amp; Conditions</a></li><li><a href="/privacy-policy">Privacy Policy</a></li>
            </ul></div>
            <div class="footer-col"><h4>Services</h4><ul>
                <li><a href="#">Live Tracking</a></li><li><a href="#">Emergency Alerts</a></li>
                <li><a href="#">Incident Reports</a></li><li><a href="#">24/7 Support</a></li>
            </ul></div>
        </div>
      
    </footer>
</div>
<script src="js/dashboard.js"></script>
</body></html>
