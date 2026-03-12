<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - Search Results</title>
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<%
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
        <a href="USER_HOME.jsp" class="nav-item" data-tip="Home">
            <div class="nav-icon">&#127968;</div><span class="nav-label">Home</span></a>
        <a href="UPLOAD_DOCUMENT.jsp" class="nav-item" data-tip="Upload Document">
            <div class="nav-icon">&#128196;</div><span class="nav-label">Upload Document</span></a>
        <a href="SEARCH.jsp" class="nav-item active" data-tip="Search Document">
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
            <a href="SEARCH.jsp" style="color:var(--text-light);text-decoration:none;">Search</a>
            <span class="sep"> / </span>
            <span class="current">Results</span>
        </div>
        <div class="topbar-spacer"></div>
        <div class="topbar-notif">&#128276;<span class="notif-badge"></span></div>
    </header>

    <main class="page-content">
        <div class="page-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;">
            <div>
                <h1>Search Results</h1>
                <p>Files matching your search criteria are shown below.</p>
            </div>
            <a href="SEARCH.jsp" class="btn btn-secondary">&#8592; New Search</a>
        </div>

        <!-- Results -->
        <%
            ResultSet rs = (ResultSet) request.getAttribute("searchResults");
            if (rs != null) {
                if (!rs.isBeforeFirst()) {
        %>
        <div class="no-results">
            <div class="empty-icon">&#128269;</div>
            <h3>No Files Found</h3>
            <p style="font-size:0.85rem;margin-top:4px;">Try a different search term or criteria.</p>
            <a href="SEARCH.jsp" class="btn btn-primary" style="margin-top:16px;">&#8592; Search Again</a>
        </div>
        <%
                } else {
                    int count = 0;
                    while (rs.next()) {
                        count++;
                        String fileName = rs.getString("file_name");
                        String ext = "";
                        if (fileName != null && fileName.contains(".")) {
                            ext = fileName.substring(fileName.lastIndexOf('.') + 1).toUpperCase();
                        }
        %>
        <div class="result-item">
            <div class="result-file-icon">
                <span style="color:#fff;font-size:0.7rem;font-weight:700;"><%=ext.isEmpty()?"FILE":ext%></span>
            </div>
            <div class="result-info">
                <strong><%=rs.getString("file_name")%></strong>
                <div class="result-meta">
                    ID: <%=rs.getString("id")%>
                    &nbsp;&#183;&nbsp;
                    Size: <%=rs.getLong("file_size")%> bytes
                </div>
            </div>
            <a href="mail?email=<%=rs.getString("email")%>&id=<%=rs.getString("id")%>"
               class="btn-request-key">
                &#128273; Request Key
            </a>
        </div>
        <%
                    }
                    if (count == 0) { %>
        <div class="no-results">
            <div class="empty-icon">&#128269;</div>
            <h3>No Files Found</h3>
            <a href="SEARCH.jsp" class="btn btn-primary" style="margin-top:16px;">&#8592; Search Again</a>
        </div>
        <%  }
            }
        } else { %>
        <div class="no-results">
            <div class="empty-icon">&#128196;</div>
            <h3>No Results</h3>
            <p style="font-size:0.85rem;margin-top:4px;">Please perform a search to see results here.</p>
            <a href="SEARCH.jsp" class="btn btn-primary" style="margin-top:16px;">&#128269; Go to Search</a>
        </div>
        <% } %>

    </main>

    <footer class="dashboard-footer">
        <div class="footer-inner">
            <div class="footer-col"><h4>Follow Us</h4><ul>
                <li><a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i> Facebook</a></li>
                <li><a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i> Twitter</a></li>
                <li><a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i> Instagram</a></li>
            </ul></div>
            <div class="footer-col"><h4>Useful Links</h4><ul>
                <li><a href="/about-us">About Us</a></li>
                <li><a href="/faq">FAQ</a></li>
                <li><a href="/terms">Terms &amp; Conditions</a></li>
            </ul></div>
            <div class="footer-col"><h4>Services</h4><ul>
                <li><a href="#">Live Tracking</a></li><li><a href="#">Emergency Alerts</a></li>
            </ul></div>
        </div>
        
    </footer>
</div>
<script src="js/dashboard.js"></script>
</body></html>
