<%--
    Document   : DOWNLOAD
    Created on : 16 Nov, 2024
    Author     : Admin1
--%>
<%@page import="java.net.InetAddress"%>
<%@ page import="java.sql.*, Connection.DbConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - Download File</title>
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<%-- ============================================================
     SESSION & MESSAGE
     ============================================================ --%>
<%
    String msg = (String) session.getAttribute("msg");
    if (msg != null && !msg.isEmpty()) {
%>
<script>
    window.addEventListener('DOMContentLoaded', function () {
        showToast('<%=msg%>', <%=msg.toLowerCase().contains("error")||msg.toLowerCase().contains("invalid")||msg.toLowerCase().contains("failed") ? "'error'" : "'success'"%>);
    });
</script>
<%
    session.removeAttribute("msg");
    }

    String uname   = (String)  session.getAttribute("username");
    String aadharS = (String)  session.getAttribute("aadhar_no");
    Integer userId = (Integer) session.getAttribute("user_id");

    if (uname   == null) uname   = "User";
    if (aadharS == null) aadharS = "";
    if (userId  == null) userId  = 0;

    String init = uname.length() > 0
                  ? String.valueOf(uname.charAt(0)).toUpperCase() : "U";

    /* Pre-fill file info if ?id= is passed from Recent Uploads table */
    String  preFileId   = request.getParameter("id");
    String  preFileName = "";
    String  preFileSize = "";
    String  preUpDate   = "";

    if (preFileId != null && !preFileId.isEmpty()) {
        Connection connPre = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            connPre = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ip", "root", "admin");
            PreparedStatement psPre = connPre.prepareStatement(
                "SELECT file_name, file_size, upload_date FROM documents " +
                "WHERE id = ? AND aadhar_no = ? LIMIT 1");
            psPre.setString(1, preFileId);
            psPre.setString(2, aadharS);
            ResultSet rsPre = psPre.executeQuery();
            if (rsPre.next()) {
                preFileName = rsPre.getString("file_name")   != null ? rsPre.getString("file_name")   : "";
                preFileSize = String.valueOf(rsPre.getLong("file_size"));
                preUpDate   = rsPre.getString("upload_date") != null ? rsPre.getString("upload_date") : "";
            }
            rsPre.close(); psPre.close();
        } catch (Exception epre) {
            /* silently ignore */
        } finally {
            if (connPre != null) { try { connPre.close(); } catch (Exception ex) {} }
        }
    }
%>

<%-- ============================================================
     SIDEBAR
     ============================================================ --%>
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
            <div class="nav-icon">&#127968;</div>
            <span class="nav-label">Home</span>
        </a>
        <a href="UPLOAD_DOCUMENT.jsp" class="nav-item" data-tip="Upload Document">
            <div class="nav-icon">&#128196;</div>
            <span class="nav-label">Upload Document</span>
        </a>
        <a href="SEARCH.jsp" class="nav-item" data-tip="Search Document">
            <div class="nav-icon">&#128269;</div>
            <span class="nav-label">Search Document</span>
        </a>
        <a href="USER_VIEW_GROUPS.jsp" class="nav-item" data-tip="My Groups">
            <div class="nav-icon">&#128101;</div>
            <span class="nav-label">My Groups</span>
        </a>
        <a href="DOWNLOAD.jsp" class="nav-item active" data-tip="Download File">
            <div class="nav-icon">&#128229;</div>
            <span class="nav-label">Download File</span>
        </a>

        <div class="nav-section-label">Account</div>
        <a href="index.jsp" class="nav-item logout" data-tip="Logout">
            <div class="nav-icon">&#128682;</div>
            <span class="nav-label">Logout</span>
        </a>
    </nav>
</aside>

<%-- ============================================================
     MAIN WRAPPER
     ============================================================ --%>
<div class="main-wrapper">

    <%-- TOPBAR --%>
    <header class="topbar">
        <div class="topbar-toggle">&#9776;</div>
        <div class="topbar-breadcrumb">
            <span>TrackSafe</span>
            <span class="sep"> / </span>
            <a href="USER_HOME.jsp" style="color:var(--text-light);text-decoration:none;">Dashboard</a>
            <span class="sep"> / </span>
            <span class="current">Download File</span>
        </div>
        <div class="topbar-spacer"></div>
        <div class="topbar-notif">&#128276;<span class="notif-badge"></span></div>
    </header>

    <%-- PAGE CONTENT --%>
    <main class="page-content">

        <div class="page-header">
            <h1>&#128229; Download File</h1>
            <p>Enter your encryption key to securely download and decrypt your file.</p>
        </div>

        <%-- ============== HOW IT WORKS STRIP ============== --%>
        <div style="display:flex;gap:14px;flex-wrap:wrap;margin-bottom:24px;">
            <div class="how-step">
                <div class="how-step-num">1</div>
                <div>
                    <div class="how-step-title">Request Key</div>
                    <div class="how-step-desc">Use Search &rarr; Request Key to email the decryption key to the file owner.</div>
                </div>
            </div>
            <div class="how-step-arrow">&#8594;</div>
            <div class="how-step">
                <div class="how-step-num">2</div>
                <div>
                    <div class="how-step-title">Receive Key</div>
                    <div class="how-step-desc">The file owner approves and sends you the encryption key by email.</div>
                </div>
            </div>
            <div class="how-step-arrow">&#8594;</div>
            <div class="how-step">
                <div class="how-step-num">3</div>
                <div>
                    <div class="how-step-title">Download</div>
                    <div class="how-step-desc">Enter the key below and click Download to receive your decrypted file.</div>
                </div>
            </div>
        </div>

        <%-- ============== MAIN DOWNLOAD CARD ============== --%>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;" class="two-col-grid">

            <%-- Download Form --%>
            <div class="card">
                <div class="card-header">
                    <div class="card-title">
                        <div class="card-title-icon">&#128273;</div>
                        Enter Encryption Key
                    </div>
                </div>
                <div class="card-body">

                    <%-- Security note --%>
                    <div style="background:rgba(245,158,11,0.08);border:1px solid rgba(245,158,11,0.25);border-left:4px solid var(--warning);border-radius:0 8px 8px 0;padding:11px 14px;margin-bottom:20px;font-size:0.82rem;color:#92400e;display:flex;align-items:flex-start;gap:8px;">
                        <span style="font-size:1rem;flex-shrink:0;">&#128274;</span>
                        <span>Your encryption key is private. Never share it. This key is tied to your specific file and Aadhaar.</span>
                    </div>

                    <form action="DownloadFile" method="get" onsubmit="return validateDownload();">

                        <% if (preFileId != null && !preFileId.isEmpty()) { %>
                        <%-- Pre-filled file preview from dashboard --%>
                        <div style="background:var(--surface2);border:1px solid var(--border);border-radius:var(--radius-sm);padding:14px 16px;margin-bottom:18px;display:flex;align-items:center;gap:14px;">
                            <div style="width:44px;height:44px;background:linear-gradient(135deg,var(--primary),var(--accent));border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:0.72rem;font-weight:700;color:#fff;flex-shrink:0;">
                                <%
                                    String dext = preFileName.contains(".") ? preFileName.substring(preFileName.lastIndexOf('.')+1).toUpperCase() : "FILE";
                                    out.print(dext.length() > 4 ? dext.substring(0,4) : dext);
                                %>
                            </div>
                            <div style="min-width:0;flex:1;">
                                <div style="font-weight:600;font-size:0.875rem;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                    <%=preFileName.isEmpty() ? "Selected File" : preFileName%>
                                </div>
                                <div style="font-size:0.75rem;color:var(--text-light);margin-top:2px;">
                                    <% if (!preFileSize.isEmpty()) { try {
                                        long b = Long.parseLong(preFileSize);
                                        if (b >= 1048576) out.print(String.format("%.1f MB", b/1048576.0));
                                        else if (b >= 1024) out.print(String.format("%.1f KB", b/1024.0));
                                        else out.print(b + " B");
                                    } catch(Exception ef){out.print(preFileSize);} } %>
                                    <% if (!preUpDate.isEmpty()) { %> &nbsp;&middot;&nbsp; <%=preUpDate%><% } %>
                                </div>
                            </div>
                            <span style="background:rgba(16,185,129,0.1);color:var(--accent2);border:1px solid rgba(16,185,129,0.25);padding:3px 10px;border-radius:20px;font-size:0.72rem;font-weight:700;">
                                Selected
                            </span>
                        </div>
                        <input type="hidden" name="file_id" value="<%=preFileId%>">
                        <% } %>

                        <div class="form-group">
                            <label class="form-label">
                                Encryption Key <span style="color:var(--danger);">*</span>
                            </label>
                            <div style="position:relative;">
                                <input type="password"
                                       name="encryption_key"
                                       id="enc_key"
                                       class="form-control"
                                       placeholder="Paste your encryption key here..."
                                       style="padding-right:48px;font-family:monospace;letter-spacing:0.5px;"
                                       required />
                                <button type="button" onclick="toggleKeyVisibility()"
                                        title="Show/hide key"
                                        style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:var(--text-light);font-size:1rem;padding:0;line-height:1;">
                                    <span id="eye-icon">&#128065;</span>
                                </button>
                            </div>
                            <div id="key-hint" style="font-size:0.75rem;color:var(--text-light);margin-top:5px;">
                                Paste the key exactly as received — it is case-sensitive.
                            </div>
                        </div>

                        <div id="key-strength-bar" style="height:4px;border-radius:4px;background:#e2e8f0;margin-bottom:18px;overflow:hidden;">
                            <div id="key-strength-fill" style="height:100%;width:0%;background:var(--danger);border-radius:4px;transition:width 0.3s,background 0.3s;"></div>
                        </div>

                        <div style="display:flex;gap:10px;">
                            <button type="submit" class="btn btn-primary" style="flex:1;justify-content:center;">
                                &#128229;&nbsp; Download &amp; Decrypt
                            </button>
                            <a href="USER_HOME.jsp" class="btn btn-secondary">Cancel</a>
                        </div>

                    </form>
                </div>
            </div>

            <%-- Info / Help Card --%>
            <div style="display:flex;flex-direction:column;gap:16px;">

                <%-- Status card --%>
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <div class="card-title-icon">&#128203;</div>
                            File Access Info
                        </div>
                    </div>
                    <div class="card-body">
                        <div style="display:flex;flex-direction:column;gap:10px;">
                            <div class="profile-detail-item">
                                <div class="profile-detail-label">&#128100; Requesting As</div>
                                <div class="profile-detail-value"><%=uname%></div>
                            </div>
                            <div class="profile-detail-item">
                                <div class="profile-detail-label">&#128273; Aadhaar</div>
                                <div class="profile-detail-value"><%=aadharS.isEmpty() ? "—" : aadharS%></div>
                            </div>
                            <div class="profile-detail-item">
                                <div class="profile-detail-label">&#127760; Your IP</div>
                                <div class="profile-detail-value" style="font-family:monospace;">
                                   <%=InetAddress.getLocalHost().getHostAddress()%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Help box --%>
                <div style="background:linear-gradient(135deg,rgba(37,99,235,0.06),rgba(6,182,212,0.04));border:1px solid rgba(37,99,235,0.12);border-radius:var(--radius);padding:20px;">
                    <div style="font-family:'Syne',sans-serif;font-weight:700;font-size:0.95rem;color:var(--text);margin-bottom:12px;">
                        &#10067; Need Help?
                    </div>
                    <ul style="list-style:none;display:flex;flex-direction:column;gap:10px;">
                        <li style="font-size:0.82rem;color:var(--text-mid);display:flex;align-items:flex-start;gap:8px;">
                            <span style="color:var(--primary);font-weight:700;flex-shrink:0;">&#8226;</span>
                            Don't have a key? Go to <a href="SEARCH.jsp" style="color:var(--primary);font-weight:600;">Search</a> and click <em>Request Key</em> on the file.
                        </li>
                        <li style="font-size:0.82rem;color:var(--text-mid);display:flex;align-items:flex-start;gap:8px;">
                            <span style="color:var(--primary);font-weight:700;flex-shrink:0;">&#8226;</span>
                            The key is sent to the file owner's email and requires their approval.
                        </li>
                        <li style="font-size:0.82rem;color:var(--text-mid);display:flex;align-items:flex-start;gap:8px;">
                            <span style="color:var(--primary);font-weight:700;flex-shrink:0;">&#8226;</span>
                            Keys expire after use — request a new one if download fails.
                        </li>
                        <li style="font-size:0.82rem;color:var(--text-mid);display:flex;align-items:flex-start;gap:8px;">
                            <span style="color:var(--primary);font-weight:700;flex-shrink:0;">&#8226;</span>
                            Contact support if the file doesn't download after entering the correct key.
                        </li>
                    </ul>
                </div>

            </div>
        </div>

    </main>

    <%-- FOOTER --%>
    <footer class="dashboard-footer">
        <div class="footer-inner">
            <div class="footer-col">
                <h4>Follow Us</h4>
                <ul>
                    <li><a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i> Facebook</a></li>
                    <li><a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i> Twitter</a></li>
                    <li><a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i> Instagram</a></li>
                    <li><a href="https://linkedin.com" target="_blank"><i class="fab fa-linkedin"></i> LinkedIn</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Useful Links</h4>
                <ul>
                    <li><a href="/about-us">About Us</a></li>
                    <li><a href="/faq">FAQ</a></li>
                    <li><a href="/terms">Terms &amp; Conditions</a></li>
                    <li><a href="/privacy-policy">Privacy Policy</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Services</h4>
                <ul>
                    <li><a href="#">Live Tracking</a></li>
                    <li><a href="#">Emergency Alerts</a></li>
                    <li><a href="#">Incident Reports</a></li>
                    <li><a href="#">24/7 Support</a></li>
                </ul>
            </div>
        </div>
       
    </footer>

</div><%-- /.main-wrapper --%>

<script src="js/dashboard.js"></script>
<script>
/* ---- Show/hide key ---- */
function toggleKeyVisibility() {
    var f = document.getElementById('enc_key');
    var e = document.getElementById('eye-icon');
    if (f.type === 'password') {
        f.type = 'text';
        e.innerHTML = '&#128064;';
    } else {
        f.type = 'password';
        e.innerHTML = '&#128065;';
    }
}

/* ---- Key strength visual ---- */
document.getElementById('enc_key').addEventListener('input', function () {
    var v    = this.value;
    var fill = document.getElementById('key-strength-fill');
    var hint = document.getElementById('key-hint');
    var pct  = Math.min(100, v.length * 3);
    fill.style.width = pct + '%';
    if (v.length === 0) {
        fill.style.background = 'var(--danger)';
        hint.textContent = 'Paste the key exactly as received — it is case-sensitive.';
    } else if (v.length < 16) {
        fill.style.background = 'var(--warning)';
        hint.textContent = 'Key seems short — check that you copied it completely.';
        hint.style.color = '#92400e';
    } else {
        fill.style.background = 'var(--accent2)';
        hint.textContent = 'Key length looks good. Click Download to proceed.';
        hint.style.color = '#065f46';
    }
});

/* ---- Form validation ---- */
function validateDownload() {
    var key = document.getElementById('enc_key').value.trim();
    if (key.length < 4) {
        showToast('Please enter a valid encryption key.', 'error');
        return false;
    }
    return true;
}
</script>

<%-- Inline extra styles for this page only --%>
<style>
.how-step {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 16px 18px;
    flex: 1;
    min-width: 180px;
    box-shadow: var(--shadow-sm);
}

.how-step-num {
    width: 30px; height: 30px;
    background: linear-gradient(135deg, var(--primary), var(--accent));
    border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
    color: #fff; font-family: 'Syne', sans-serif;
    font-weight: 800; font-size: 0.9rem;
    flex-shrink: 0;
}

.how-step-title {
    font-family: 'Syne', sans-serif;
    font-weight: 700; font-size: 0.88rem;
    color: var(--text); margin-bottom: 3px;
}

.how-step-desc {
    font-size: 0.78rem; color: var(--text-light); line-height: 1.5;
}

.how-step-arrow {
    display: flex; align-items: center;
    color: var(--text-light); font-size: 1.2rem;
    padding-top: 12px; flex-shrink: 0;
}

@media (max-width: 700px) {
    .how-step-arrow { display: none; }
}
</style>

</body>
</html>
