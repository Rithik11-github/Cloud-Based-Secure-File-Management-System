<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe - My Groups</title>
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<%
    String msgAttr = (String) session.getAttribute("msg");
    if (msgAttr != null && !msgAttr.isEmpty()) { %>
<script>window.addEventListener('DOMContentLoaded',function(){showToast('<%=msgAttr%>','success');});</script>
<% session.removeAttribute("msg"); }
   String uname = (String) session.getAttribute("username");
   if (uname == null) uname = "User";
   String init = uname.length() > 0 ? String.valueOf(uname.charAt(0)).toUpperCase() : "U";
%>

<%
    // Get real IP
    String userIP = request.getHeader("X-Forwarded-For");
    if (userIP == null || userIP.isEmpty() || "unknown".equalsIgnoreCase(userIP))
        userIP = request.getHeader("Proxy-Client-IP");
    if (userIP == null || userIP.isEmpty() || "unknown".equalsIgnoreCase(userIP))
        userIP = request.getRemoteAddr();
    if (userIP != null && userIP.contains(","))
        userIP = userIP.split(",")[0].trim();

    // DB Connection
    Connection conn = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip","root","admin");
    } catch (Exception e) { /* handled below */ }

    // Handle send message
    String action = request.getParameter("action");
    if ("sendMessage".equals(action) && conn != null) {
        String groupId   = request.getParameter("groupId");
        String msgText   = request.getParameter("messageText");
        String sender    = (String) session.getAttribute("username");
        if (sender == null) sender = "User";
        if (groupId != null && msgText != null && !msgText.trim().isEmpty()) {
            PreparedStatement chk = conn.prepareStatement(
                "SELECT id FROM group_ip_access WHERE group_id=? AND ip_address=?");
            chk.setInt(1, Integer.parseInt(groupId));
            chk.setString(2, userIP);
            ResultSet chkRs = chk.executeQuery();
            if (chkRs.next()) {
                PreparedStatement ins = conn.prepareStatement(
                    "INSERT INTO group_messages(group_id,sender_name,sender_ip,message,sent_at) VALUES(?,?,?,?,NOW())");
                ins.setInt(1, Integer.parseInt(groupId));
                ins.setString(2, sender);
                ins.setString(3, userIP);
                ins.setString(4, msgText.trim());
                ins.executeUpdate();
            }
            response.sendRedirect("USER_VIEW_GROUPS.jsp");
            return;
        }
    }
    final String finalUserIP = userIP;
    final Connection finalConn = conn;
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
        <a href="SEARCH.jsp" class="nav-item" data-tip="Search Document">
            <div class="nav-icon">&#128269;</div><span class="nav-label">Search Document</span></a>
        <a href="USER_VIEW_GROUPS.jsp" class="nav-item active" data-tip="My Groups">
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
            <span class="current">Secure Groups</span>
        </div>
        <div class="topbar-spacer"></div>
        <div class="topbar-notif">&#128276;<span class="notif-badge"></span></div>
    </header>

    <main class="page-content">
        <div class="page-header">
            <h1>&#128274; Secure Groups</h1>
            <p>IP-based access controlled group channels for authorized communication.</p>
        </div>

        <!-- IP Banner -->
        <div class="ip-info-banner">
            &#128205; Your IP address: <strong><%=finalUserIP%></strong>
            &nbsp;&mdash;&nbsp; Access is granted by the administrator based on your IP address.
        </div>

        <!-- DB Error -->
        <% if (finalConn == null) { %>
        <div style="background:#fff5f5;border:1px solid rgba(239,68,68,0.2);border-radius:12px;padding:20px;color:var(--danger);margin-bottom:20px;">
            &#10006; Database connection failed. Please contact the administrator.
        </div>
        <% } %>

        <%
            if (finalConn != null) {
                try {
                    Statement stmt = finalConn.createStatement();
                    ResultSet groups = stmt.executeQuery("SELECT * FROM secure_groups ORDER BY created_at DESC");
                    boolean any = false;

                    while (groups.next()) {
                        any = true;
                        int gId       = groups.getInt("id");
                        String gName  = groups.getString("group_name");
                        String gDesc  = groups.getString("group_desc");

                        PreparedStatement acc = finalConn.prepareStatement(
                            "SELECT id FROM group_ip_access WHERE group_id=? AND ip_address=?");
                        acc.setInt(1, gId); acc.setString(2, finalUserIP);
                        boolean hasAccess = acc.executeQuery().next();

                        // Log unauthorized attempt
                        if (!hasAccess) {
                            try {
                                PreparedStatement logPs = finalConn.prepareStatement(
                                    "INSERT INTO unauthorized_attempts(ip_address,group_id,attempt_time) " +
                                    "VALUES(?,?,NOW()) ON DUPLICATE KEY UPDATE attempt_time=NOW()");
                                logPs.setString(1, finalUserIP);
                                logPs.setInt(2, gId);
                                logPs.executeUpdate();
                            } catch (Exception le) {}
                        }
        %>

        <div class="group-card">
            <div class="group-card-header">
                <div>
                    <h3>&#128101; <%=gName%></h3>
                    <% if (gDesc != null && !gDesc.isEmpty()) { %>
                    <p><%=gDesc%></p>
                    <% } %>
                </div>
                <% if (hasAccess) { %>
                <span class="badge-access">&#10003; Access Granted</span>
                <% } else { %>
                <span class="badge-denied">&#128274; Access Denied</span>
                <% } %>
            </div>

            <div class="group-card-body">
                <% if (hasAccess) { %>

                <div class="chat-area" id="chatArea-<%=gId%>">
                    <%
                        PreparedStatement msgSt = finalConn.prepareStatement(
                            "SELECT * FROM group_messages WHERE group_id=? ORDER BY sent_at ASC");
                        msgSt.setInt(1, gId);
                        ResultSet msgs = msgSt.executeQuery();
                        int mc = 0;
                        while (msgs.next()) { mc++;
                    %>
                    <div class="chat-message others">
                        <div class="sender">&#128100; <%=msgs.getString("sender_name")%></div>
                        <div class="text"><%=msgs.getString("message")%></div>
                        <div class="time"><%=msgs.getString("sent_at")%> &nbsp;&middot;&nbsp; <%=msgs.getString("sender_ip")%></div>
                    </div>
                    <%  }
                        if (mc == 0) { %>
                    <div style="text-align:center;color:var(--text-light);padding:40px 20px;font-size:0.875rem;">
                        &#128172; No messages yet. Be the first to send one!
                    </div>
                    <%  } %>
                </div>

                <form method="post" action="USER_VIEW_GROUPS.jsp">
                    <input type="hidden" name="action" value="sendMessage">
                    <input type="hidden" name="groupId" value="<%=gId%>">
                    <div class="chat-input-row">
                        <input type="text" name="messageText"
                               placeholder="Type a message..." maxlength="500" required>
                        <button type="submit" class="btn-send">&#9658; Send</button>
                    </div>
                </form>

                <% } else { %>

                <div class="access-denied-box">
                    <div class="lock-icon">&#128274;</div>
                    <h4>Access Restricted</h4>
                    <p>Your IP address <strong><%=finalUserIP%></strong> is not authorized for this group.<br>
                    Contact the administrator to request access.</p>
                </div>

                <% } %>
            </div>
        </div>

        <%
                    }
                    if (!any) {
        %>
        <div style="text-align:center;padding:60px 20px;background:var(--surface);border-radius:var(--radius);border:1px solid var(--border);box-shadow:var(--shadow-sm);">
            <div style="font-size:3rem;margin-bottom:12px;">&#128101;</div>
            <h3 style="font-family:'Syne',sans-serif;font-weight:700;margin-bottom:6px;">No Groups Available</h3>
            <p style="color:var(--text-light);font-size:0.875rem;">No secure groups have been created by the administrator yet.</p>
        </div>
        <%
                    }
                } catch (Exception e) { %>
        <div style="background:#fff5f5;border:1px solid rgba(239,68,68,0.2);border-radius:12px;padding:20px;color:var(--danger);">
            &#10006; Error loading groups: <%=e.getMessage()%>
        </div>
        <%  }
            }
        %>

        <% if (finalConn != null) { try { finalConn.close(); } catch (Exception e) {} } %>

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
