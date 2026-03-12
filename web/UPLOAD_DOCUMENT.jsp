<%@ page import="Connection.DbConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - Upload Document</title>
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
        <a href="USER_HOME.jsp" class="nav-item" data-tip="Home">
            <div class="nav-icon">&#127968;</div><span class="nav-label">Home</span></a>
        <a href="UPLOAD_DOCUMENT.jsp" class="nav-item active" data-tip="Upload Document">
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
            <span class="current">Upload Document</span>
        </div>
        <div class="topbar-spacer"></div>
        <div class="topbar-notif">&#128276;<span class="notif-badge"></span></div>
    </header>

    <main class="page-content">
        <div class="page-header">
            <h1>Upload Document</h1>
            <p>Securely upload and store your files to the TrackSafe system.</p>
        </div>

        <%
            Integer user_id = (Integer) session.getAttribute("user_id");
            String aadhar_no = (String) session.getAttribute("aadhar_no");

            if (user_id != null && aadhar_no != null) {
                try {
                    DbConnection db = new DbConnection();
                    ResultSet rs = db.Select("SELECT * FROM user_reg WHERE user_id='" + user_id + "' AND aadhar_no='" + aadhar_no + "'");
                    if (rs.next()) {
        %>

        <div class="card" style="max-width:600px;">
            <div class="card-header">
                <div class="card-title">
                    <div class="card-title-icon">&#128196;</div>
                    New File Upload
                </div>
            </div>
            <div class="card-body">
                <!-- Info strip -->
                <div style="background:rgba(37,99,235,0.06);border:1px solid rgba(37,99,235,0.15);border-radius:8px;padding:11px 14px;margin-bottom:20px;font-size:0.83rem;color:var(--text-mid);display:flex;align-items:center;gap:8px;">
                    <span>&#128274;</span> Files are encrypted and linked to your Aadhaar before storage.
                </div>

                <form action="Upload_File" method="post" enctype="multipart/form-data">

                    <div class="form-group">
                        <label class="form-label">Aadhaar Number</label>
                        <input type="text" name="aadhar_no" class="form-control"
                               value="<%= rs.getString("aadhar_no") %>" required readonly />
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" class="form-control"
                               value="<%= rs.getString("email") %>" required readonly />
                    </div>

                    <div class="form-group">
                        <label class="form-label">Select Document <span>*</span></label>
                        <input type="file" name="Docmnt" class="form-control-file" required />
                        <div style="font-size:0.76rem;color:var(--text-light);margin-top:5px;">
                            Supported: PDF, DOC, DOCX, JPG, PNG (max 10MB)
                        </div>
                    </div>

                    <!-- Upload area hint -->
                    <div style="background:var(--surface2);border:2px dashed rgba(37,99,235,0.2);border-radius:10px;padding:18px;text-align:center;margin-bottom:20px;color:var(--text-light);font-size:0.83rem;">
                        &#128196; Drag &amp; drop or click "Choose File" above to select your document
                    </div>

                    <div style="display:flex;gap:12px;">
                        <button type="submit" class="btn btn-primary">
                            &#128196; Upload Now
                        </button>
                        <a href="USER_HOME.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>

        <%
                    } else { %>
        <div style="background:#fff5f5;border:1px solid rgba(239,68,68,0.2);border-radius:12px;padding:24px;color:var(--danger);text-align:center;">
            <div style="font-size:2rem;margin-bottom:8px;">&#10006;</div>
            <strong>User not found.</strong> Please login again.
        </div>
        <%
                    }
                } catch (Exception e) { %>
        <div style="background:#fff5f5;border:1px solid rgba(239,68,68,0.2);border-radius:12px;padding:24px;color:var(--danger);">
            <strong>Error:</strong> <%= e.getMessage() %>
        </div>
        <%
                }
            } else {
                session.setAttribute("msg", "Session expired. Please login.");
                response.sendRedirect("USER_LOGIN.jsp");
            }
        %>
    </main>

    <footer class="dashboard-footer">
        <div class="footer-inner">
            <div class="footer-col"><h4>Follow Us</h4><ul>
                <li><a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i> Facebook</a></li>
                <li><a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i> Twitter</a></li>
                <li><a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i> Instagram</a></li>
            </ul></div>
            <div class="footer-col"><h4>Useful Links</h4><ul>
                <li><a href="/about-us">About Us</a></li><li><a href="/faq">FAQ</a></li>
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
