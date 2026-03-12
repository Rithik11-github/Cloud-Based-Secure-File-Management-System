<%--
    Document   : SEARCH
    Author     : Admin1
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - Search Documents</title>
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
            <span class="current">Search Document</span>
        </div>
        <div class="topbar-spacer"></div>
        <div class="topbar-notif">&#128276;<span class="notif-badge"></span></div>
    </header>

    <main class="page-content">
        <div class="page-header">
            <h1>Search Documents</h1>
            <p>Find uploaded files by name, Aadhaar number, or email address.</p>
        </div>

        <!-- Search Form Card -->
        <div class="card" style="max-width:680px;margin-bottom:28px;">
            <div class="card-header">
                <div class="card-title">
                    <div class="card-title-icon">&#128269;</div>
                    Search Files
                </div>
            </div>
            <div class="card-body">
                <form action="Search_File" method="get">
                    <div class="form-group">
                        <label class="form-label">Search By</label>
                        <select name="searchCriteria" id="searchCriteria" class="form-control">
                            <option value="file_name">File Name</option>
                            <option value="aadhar_no">Aadhaar Number</option>
                            <option value="email">Email Address</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Search Term <span style="color:var(--danger);">*</span></label>
                        <div style="display:flex;gap:10px;">
                            <input type="text" name="searchValue" id="searchValue"
                                   class="form-control"
                                   placeholder="Enter your search term..."
                                   required style="flex:1;" />
                            <button type="submit" class="btn btn-primary" style="white-space:nowrap;">
                                &#128269; Search
                            </button>
                        </div>
                    </div>
                </form>

                <!-- Tips -->
                <div style="margin-top:8px;display:flex;gap:10px;flex-wrap:wrap;">
                    <span style="background:rgba(37,99,235,0.07);border:1px solid rgba(37,99,235,0.13);border-radius:20px;padding:4px 12px;font-size:0.75rem;color:var(--text-mid);">
                        &#128161; Use partial file names for broader results
                    </span>
                    <span style="background:rgba(16,185,129,0.07);border:1px solid rgba(16,185,129,0.2);border-radius:20px;padding:4px 12px;font-size:0.75rem;color:var(--text-mid);">
                        &#128274; Only accessible files shown
                    </span>
                </div>
            </div>
        </div>

        <!-- Recent Searches hint -->
        <div style="font-size:0.8rem;color:var(--text-light);margin-bottom:20px;display:flex;align-items:center;gap:6px;">
            &#128336; Use the search form above to find documents by any criteria.
        </div>
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
                <li><a href="#">Live Tracking</a></li>
                <li><a href="#">Emergency Alerts</a></li>
            </ul></div>
        </div>
       
    </footer>
</div>
<script src="js/dashboard.js"></script>
</body></html>
