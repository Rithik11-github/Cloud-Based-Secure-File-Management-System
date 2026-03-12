<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe — Admin Dashboard</title>
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<%
    String msg = (String) session.getAttribute("msg");
    if (msg != null && !msg.isEmpty()) { %>
<script>window.addEventListener('DOMContentLoaded',function(){showToast('<%=msg%>','<%=msg.toLowerCase().contains("error")?"error":"success"%>');});</script>
<% session.removeAttribute("msg"); }

    int totalUsers=0, totalDocuments=0, totalMails=0, blockedIPs=0, totalGroups=0, unauthorizedAttempts=0;
    java.util.List<String[]> recentUsers = new java.util.ArrayList<String[]>();
    java.util.List<String[]> recentMails = new java.util.ArrayList<String[]>();

    Connection conn = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip","root","admin");

        ResultSet r; r = conn.createStatement().executeQuery("SELECT COUNT(*) AS c FROM user_reg");
        if(r.next()) totalUsers = r.getInt("c"); r.close();

        try { r = conn.createStatement().executeQuery("SELECT COUNT(*) AS c FROM documents");
              if(r.next()) totalDocuments=r.getInt("c"); r.close(); } catch(Exception e2){}

        try { r = conn.createStatement().executeQuery("SELECT COUNT(*) AS c FROM mail");
              if(r.next()) totalMails=r.getInt("c"); r.close(); } catch(Exception e3){}

        try { r = conn.createStatement().executeQuery("SELECT COUNT(*) AS c FROM block");
              if(r.next()) blockedIPs=r.getInt("c"); r.close(); } catch(Exception e4){}

        try { r = conn.createStatement().executeQuery("SELECT COUNT(*) AS c FROM secure_groups");
              if(r.next()) totalGroups=r.getInt("c"); r.close(); } catch(Exception e5){}

        try { r = conn.createStatement().executeQuery("SELECT COUNT(*) AS c FROM unauthorized_attempts");
              if(r.next()) unauthorizedAttempts=r.getInt("c"); r.close(); } catch(Exception e6){}

        try { r = conn.createStatement().executeQuery(
                "SELECT aadhar_no,username,email,mobile FROM user_reg ORDER BY user_id DESC LIMIT 5");
              while(r.next()) recentUsers.add(new String[]{r.getString(1),r.getString(2),r.getString(3),r.getString(4)});
              r.close(); } catch(Exception eu){}

        try { r = conn.createStatement().executeQuery(
                "SELECT M_Id,From_Mail,Subject,Message FROM mail ORDER BY M_Id DESC LIMIT 4");
              while(r.next()) recentMails.add(new String[]{String.valueOf(r.getInt(1)),r.getString(2),r.getString(3),r.getString(4)});
              r.close(); } catch(Exception em){}

    } catch(Exception e){} finally { if(conn!=null){try{conn.close();}catch(Exception ex){}} }
%>

<aside class="admin-sidebar" id="adminSidebar">
    <div class="admin-brand">
        <div class="admin-brand-icon">&#9881;</div>
        <div><span class="admin-brand-text">TrackSafe</span><span class="admin-brand-sub">Admin Panel</span></div>
        <div class="sidebar-toggle-btn">&#10094;</div>
    </div>
    <div class="admin-sidebar-badge">
        <div class="admin-avatar">A</div>
        <div class="admin-info">
            <div class="admin-name">Administrator</div>
            <div class="admin-role">Super Admin</div>
        </div>
    </div>
    <nav class="admin-nav">
        <div class="nav-section-label">Dashboard</div>
        <a href="ADMIN_HOME.jsp" class="nav-item active" data-tip="Home"><div class="nav-icon">&#127968;</div><span class="nav-label">Dashboard</span></a>
        <div class="nav-section-label">Management</div>
        <a href="iplocation.jsp" class="nav-item" data-tip="IP Tracking"><div class="nav-icon">&#127757;</div><span class="nav-label">IP Location Tracking</span></a>
        <a href="View_Request.jsp" class="nav-item" data-tip="Mail Requests">
            <div class="nav-icon">&#128235;</div><span class="nav-label">Mail Requests</span>
            <% if(totalMails>0){ %><span class="nav-badge"><%=totalMails%></span><% } %>
        </a>
        <a href="ADMIN_CREATE_GROUP.jsp" class="nav-item" data-tip="Groups"><div class="nav-icon">&#128101;</div><span class="nav-label">Manage Groups</span></a>
        <div class="nav-section-label">System</div>
        <a href="index.jsp" class="nav-item logout" data-tip="Logout"><div class="nav-icon">&#128682;</div><span class="nav-label">Logout</span></a>
    </nav>
</aside>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-toggle">&#9776;</div>
        <div class="topbar-breadcrumb"><span>Admin</span><span class="sep"> / </span><span class="current">Dashboard</span></div>
        <div class="topbar-spacer"></div>
        <div class="topbar-time" id="admin-clock"></div>
        <div class="topbar-notif">&#128276;<% if(totalMails>0||unauthorizedAttempts>0){ %><span class="notif-badge"></span><% } %></div>
    </header>

    <main class="admin-content">
        <div class="page-header">
            <h1>Admin Dashboard</h1>
            <p>Real-time system overview — users, documents, threats and group status.</p>
        </div>

        <div class="admin-hero">
            <div class="hero-text">
                <h2>&#9881; System Control Centre</h2>
                <p>Monitor all platform activity, manage IP access groups, and respond to user mail requests from one unified panel.</p>
                <div class="hero-badges">
                    <span class="hero-badge green">&#9679;&nbsp; System Active</span>
                    <span class="hero-badge amber">&#128101;&nbsp; <%=totalGroups%> Group<%=totalGroups!=1?"s":""%></span>
                    <% if(blockedIPs>0){ %><span class="hero-badge red">&#128683;&nbsp; <%=blockedIPs%> Blocked IP<%=blockedIPs!=1?"s":""%></span><% } %>
                    <% if(unauthorizedAttempts>0){ %><span class="hero-badge red">&#9888;&nbsp; <%=unauthorizedAttempts%> Threat<%=unauthorizedAttempts!=1?"s":""%></span><% } %>
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card amber"><div class="stat-icon amber">&#128100;</div><div class="stat-info"><div class="stat-value"><%=totalUsers%></div><div class="stat-label">Registered Users</div></div></div>
            <div class="stat-card blue"><div class="stat-icon blue">&#128196;</div><div class="stat-info"><div class="stat-value"><%=totalDocuments%></div><div class="stat-label">Total Documents</div></div></div>
            <div class="stat-card green"><div class="stat-icon green">&#128235;</div><div class="stat-info"><div class="stat-value"><%=totalMails%></div><div class="stat-label">Mail Requests</div></div></div>
            <div class="stat-card red"><div class="stat-icon red">&#128683;</div><div class="stat-info"><div class="stat-value"><%=blockedIPs%></div><div class="stat-label">Blocked IPs</div></div></div>
            <div class="stat-card purple"><div class="stat-icon purple">&#128101;</div><div class="stat-info"><div class="stat-value"><%=totalGroups%></div><div class="stat-label">Secure Groups</div></div></div>
            <div class="stat-card red"><div class="stat-icon red">&#9888;</div><div class="stat-info"><div class="stat-value"><%=unauthorizedAttempts%></div><div class="stat-label">Threat Attempts</div></div></div>
        </div>

        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title"><div class="admin-card-icon">&#128100;</div>Recent Registrations</div>
                <span style="font-size:0.75rem;color:var(--text-light);">Last 5 users</span>
            </div>
            <div class="admin-table-wrap">
                <% if(recentUsers.isEmpty()){ %>
                <div class="empty-state"><span class="empty-icon">&#128100;</span><h3>No users registered yet.</h3></div>
                <% } else { %>
                <table class="admin-table">
                    <thead><tr><th>#</th><th>Aadhaar No</th><th>Username</th><th>Email</th><th>Mobile</th></tr></thead>
                    <tbody>
                    <% int rn=0; for(String[] u:recentUsers){ rn++; %>
                    <tr>
                        <td><span class="table-num"><%=rn%></span></td>
                        <td><span class="badge badge-info" style="font-family:monospace;font-size:0.75rem;"><%=u[0]!=null?u[0]:"—"%></span></td>
                        <td style="font-weight:600;"><%=u[1]!=null?u[1]:"—"%></td>
                        <td style="color:var(--text-mid);font-size:0.83rem;"><%=u[2]!=null?u[2]:"—"%></td>
                        <td style="color:var(--text-mid);font-size:0.83rem;"><%=u[3]!=null?u[3]:"—"%></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;" class="admin-two-col">
            <div class="admin-card" style="margin-bottom:0;">
                <div class="admin-card-header">
                    <div class="admin-card-title"><div class="admin-card-icon">&#128235;</div>Recent Mail Requests</div>
                    <a href="View_Request.jsp" class="btn btn-amber btn-sm">View All</a>
                </div>
                <div class="admin-card-body">
                    <% if(recentMails.isEmpty()){ %>
                    <div class="empty-state" style="padding:20px;"><span class="empty-icon">&#128235;</span><h3>No mail requests yet.</h3></div>
                    <% } else { for(String[] m:recentMails){ String ini=m[1]!=null&&m[1].length()>0?String.valueOf(m[1].charAt(0)).toUpperCase():"?"; String subj=m[2]!=null?m[2]:"No Subject"; String body=m[3]!=null?(m[3].length()>70?m[3].substring(0,70)+"…":m[3]):""; %>
                    <div style="display:flex;align-items:flex-start;gap:10px;padding:10px 0;border-bottom:1px solid var(--border);">
                        <div class="mail-avatar" style="width:32px;height:32px;font-size:0.8rem;flex-shrink:0;"><%=ini%></div>
                        <div style="flex:1;min-width:0;">
                            <div style="font-weight:600;font-size:0.83rem;"><%=m[1]!=null?m[1]:""%></div>
                            <div style="font-size:0.76rem;color:var(--primary);font-weight:600;"><%=subj%></div>
                            <div style="font-size:0.75rem;color:var(--text-light);margin-top:1px;"><%=body%></div>
                        </div>
                        <span class="badge badge-pending" style="flex-shrink:0;">Pending</span>
                    </div>
                    <% } } %>
                </div>
            </div>

            <div class="admin-card" style="margin-bottom:0;">
                <div class="admin-card-header"><div class="admin-card-title"><div class="admin-card-icon">&#9889;</div>Quick Actions</div></div>
                <div class="admin-card-body">
                    <div style="display:flex;flex-direction:column;gap:10px;">
                        <a href="iplocation.jsp" class="btn btn-amber" style="justify-content:center;">&#127757;&nbsp; IP Location Tracking</a>
                        <a href="View_Request.jsp" class="btn btn-blue" style="justify-content:center;">&#128235;&nbsp; View Mail Requests</a>
                        <a href="ADMIN_CREATE_GROUP.jsp" class="btn btn-green" style="justify-content:center;">&#128101;&nbsp; Manage Groups</a>
                        <a href="index.jsp" class="btn btn-ghost" style="justify-content:center;">&#128682;&nbsp; Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="admin-footer">
        <div class="footer-inner">
            <div class="footer-col"><h4>Follow Us</h4><ul>
                <li><a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i> Facebook</a></li>
                <li><a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i> Twitter</a></li>
                <li><a href="https://linkedin.com" target="_blank"><i class="fab fa-linkedin"></i> LinkedIn</a></li>
            </ul></div>
            <div class="footer-col"><h4>Admin Tools</h4><ul>
                <li><a href="iplocation.jsp">IP Tracking</a></li>
                <li><a href="View_Request.jsp">Mail Requests</a></li>
                <li><a href="ADMIN_CREATE_GROUP.jsp">Group Management</a></li>
            </ul></div>
        </div>
      
    </footer>
</div>
<style>.admin-two-col{display:grid;grid-template-columns:1fr 1fr;gap:20px;}@media(max-width:900px){.admin-two-col{grid-template-columns:1fr;}}</style>
<script src="js/admin.js"></script>
</body></html>
