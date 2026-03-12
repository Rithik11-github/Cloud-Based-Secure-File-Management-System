<%@page import="java.sql.ResultSet"%>
<%@page import="Connection.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe — Mail Requests</title>
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

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
        <a href="ADMIN_HOME.jsp" class="nav-item" data-tip="Home"><div class="nav-icon">&#127968;</div><span class="nav-label">Dashboard</span></a>
        <div class="nav-section-label">Management</div>
        <a href="iplocation.jsp" class="nav-item" data-tip="IP Tracking"><div class="nav-icon">&#127757;</div><span class="nav-label">IP Location Tracking</span></a>
        <a href="View_Request.jsp" class="nav-item active" data-tip="Mail Requests"><div class="nav-icon">&#128235;</div><span class="nav-label">Mail Requests</span></a>
        <a href="ADMIN_CREATE_GROUP.jsp" class="nav-item" data-tip="Groups"><div class="nav-icon">&#128101;</div><span class="nav-label">Manage Groups</span></a>
        <div class="nav-section-label">System</div>
        <a href="index.jsp" class="nav-item logout" data-tip="Logout"><div class="nav-icon">&#128682;</div><span class="nav-label">Logout</span></a>
    </nav>
</aside>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-toggle">&#9776;</div>
        <div class="topbar-breadcrumb">
            <a href="ADMIN_HOME.jsp">Admin</a><span class="sep"> / </span>
            <span class="current">Mail Requests</span>
        </div>
        <div class="topbar-spacer"></div>
        <div class="topbar-time" id="admin-clock"></div>
        <div class="topbar-notif">&#128276;<span class="notif-badge"></span></div>
    </header>

    <main class="admin-content">
        <div class="page-header">
            <h1>&#128235; Mail Requests</h1>
            <p>Review user mail requests and send decryption key links to approved requestors.</p>
        </div>

        <%-- How it works strip --%>
        <div style="display:flex;gap:14px;flex-wrap:wrap;margin-bottom:24px;align-items:stretch;">
            <div style="flex:1;min-width:180px;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:16px 18px;display:flex;align-items:flex-start;gap:12px;">
                <div style="width:30px;height:30px;background:rgba(245,158,11,0.2);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:0.9rem;flex-shrink:0;">1</div>
                <div><div style="font-family:'Syne',sans-serif;font-weight:700;font-size:0.85rem;color:var(--text);margin-bottom:3px;">User Requests Key</div>
                <div style="font-size:0.78rem;color:var(--text-light);">A user searches for a file and clicks Request Key, which sends an email to admin.</div></div>
            </div>
            <div style="display:flex;align-items:center;color:var(--text-light);font-size:1.2rem;padding:0 4px;">&#8594;</div>
            <div style="flex:1;min-width:180px;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:16px 18px;display:flex;align-items:flex-start;gap:12px;">
                <div style="width:30px;height:30px;background:rgba(59,130,246,0.2);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:0.9rem;flex-shrink:0;color:var(--blue);">2</div>
                <div><div style="font-family:'Syne',sans-serif;font-weight:700;font-size:0.85rem;color:var(--text);margin-bottom:3px;">Admin Reviews</div>
                <div style="font-size:0.78rem;color:var(--text-light);">Review the request details — sender, subject, and message — before approving.</div></div>
            </div>
            <div style="display:flex;align-items:center;color:var(--text-light);font-size:1.2rem;padding:0 4px;">&#8594;</div>
            <div style="flex:1;min-width:180px;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:16px 18px;display:flex;align-items:flex-start;gap:12px;">
                <div style="width:30px;height:30px;background:rgba(16,185,129,0.2);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:0.9rem;flex-shrink:0;color:var(--green);">3</div>
                <div><div style="font-family:'Syne',sans-serif;font-weight:700;font-size:0.85rem;color:var(--text);margin-bottom:3px;">Send Decryption Link</div>
                <div style="font-size:0.78rem;color:var(--text-light);">Click Send to email the decryption key link to the requestor's email address.</div></div>
            </div>
        </div>

        <%-- Mail Cards --%>
        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title">
                    <div class="admin-card-icon">&#128235;</div>
                    Pending Mail Requests
                </div>
            </div>
            <div class="admin-card-body">
                <%
                    boolean hasMails = false;
                    try {
                        DbConnection db = new DbConnection();
                        String query = "SELECT * FROM mail ORDER BY M_Id DESC";
                        ResultSet ts = db.Select(query);
                        int mailNum = 0;

                        while (ts.next()) {
                            hasMails = true;
                            mailNum++;
                            int mid        = ts.getInt("M_Id");
                            String fromMail = ts.getString("From_Mail");
                            String aadharNo = ts.getString("aadhar_no");
                            String subject  = ts.getString("Subject");
                            String msgText  = ts.getString("Message");
                            String initial  = fromMail != null && fromMail.length() > 0
                                              ? String.valueOf(fromMail.charAt(0)).toUpperCase() : "?";
                            String shortMsg = msgText != null ? (msgText.length() > 120 ? msgText.substring(0,120)+"…" : msgText) : "";
                %>
                <div class="mail-request-card">
                    <div class="mail-card-header">
                        <div class="mail-card-from">
                            <div class="mail-avatar"><%=initial%></div>
                            <div>
                                <div class="mail-sender">Request #<%=mailNum%></div>
                                <div class="mail-email"><%=fromMail!=null?fromMail:"—"%></div>
                            </div>
                        </div>
                        <div style="display:flex;flex-direction:column;align-items:flex-end;gap:5px;flex-shrink:0;">
                            <span class="badge badge-pending">Pending</span>
                            <span style="font-size:0.7rem;color:var(--text-light);">ID: <%=mid%></span>
                        </div>
                    </div>

                    <div class="mail-card-body">
                        <div class="mail-field">
                            <div class="mail-field-label">&#128272; Aadhaar No</div>
                            <div class="mail-field-value" style="font-family:monospace;font-size:0.875rem;font-weight:700;color:var(--primary);">
                                <%=aadharNo!=null?aadharNo:"—"%>
                            </div>
                        </div>
                        <div class="mail-field">
                            <div class="mail-field-label">&#128394; Subject</div>
                            <div class="mail-field-value" style="font-weight:600;"><%=subject!=null?subject:"No Subject"%></div>
                        </div>
                        <div class="mail-field">
                            <div class="mail-field-label">&#128172; Message</div>
                            <div class="mail-field-value"><%=shortMsg%></div>
                        </div>
                    </div>

                    <div class="mail-card-actions">
                        <button onclick="Send_Link(<%=mid%>, '<%=fromMail!=null?fromMail.replace("'","\\'"):""%>', '<%=aadharNo!=null?aadharNo:""%>')"
                                class="btn btn-green">
                            &#9993;&nbsp; Send Decryption Link
                        </button>
                        <button onclick="if(confirm('Mark this request as reviewed?'))showToast('Request #<%=mailNum%> marked as reviewed.','success');"
                                class="btn btn-ghost btn-sm">
                            &#10003;&nbsp; Mark Reviewed
                        </button>
                    </div>
                </div>
                <%
                        } // end while

                        if (!hasMails) {
                %>
                <div class="empty-state">
                    <span class="empty-icon">&#128235;</span>
                    <h3>No mail requests found.</h3>
                    <p>When users request file access, their messages appear here.</p>
                </div>
                <%
                        }
                    } catch (Exception e) {
                %>
                <div class="alert alert-error">
                    &#10006;&nbsp; Error loading mail requests: <%=e.getMessage()%>
                </div>
                <%  } %>
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
                <li><a href="ADMIN_HOME.jsp">Dashboard</a></li>
                <li><a href="iplocation.jsp">IP Tracking</a></li>
                <li><a href="ADMIN_CREATE_GROUP.jsp">Group Management</a></li>
            </ul></div>
        </div>
        <div class="footer-bottom">&copy; 2024 TrackSafe Admin Panel.</div>
    </footer>
</div>
<script src="js/admin.js"></script>
</body></html>
