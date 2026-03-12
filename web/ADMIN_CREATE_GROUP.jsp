<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe — Manage Groups</title>
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<%
    String sessionMsg = (String) session.getAttribute("msg");
    if (sessionMsg != null && !sessionMsg.isEmpty()) { %>
<script>window.addEventListener('DOMContentLoaded',function(){showToast('<%=sessionMsg%>','<%=sessionMsg.toLowerCase().contains("error")?"error":"success"%>');});</script>
<% session.removeAttribute("msg"); }

    /* ---- DB Actions ---- */
    Connection conn = null;
    String actionMsg  = "";
    String actionType = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip","root","admin");
    } catch (Exception e) {
        actionMsg  = "Database connection failed: " + e.getMessage();
        actionType = "error";
    }

    String action = request.getParameter("action");

    if (conn != null) {
        if ("createGroup".equals(action)) {
            String gName = request.getParameter("groupName");
            String gDesc = request.getParameter("groupDesc");
            if (gName != null && !gName.trim().isEmpty()) {
                try {
                    PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO secure_groups(group_name,group_desc,created_at) VALUES(?,?,NOW())");
                    ps.setString(1, gName.trim());
                    ps.setString(2, gDesc != null ? gDesc.trim() : "");
                    ps.executeUpdate();
                    actionMsg  = "Group '" + gName.trim() + "' created successfully!";
                    actionType = "success";
                } catch (Exception e) {
                    actionMsg  = "Error creating group: " + e.getMessage();
                    actionType = "error";
                }
            }
        }

        if ("addIP".equals(action)) {
            String gId = request.getParameter("groupId");
            String ip  = request.getParameter("ipAddress");
            if (gId != null && ip != null && !ip.trim().isEmpty()) {
                try {
                    PreparedStatement chk = conn.prepareStatement(
                        "SELECT id FROM group_ip_access WHERE group_id=? AND ip_address=?");
                    chk.setInt(1, Integer.parseInt(gId)); chk.setString(2, ip.trim());
                    if (chk.executeQuery().next()) {
                        actionMsg  = "IP " + ip.trim() + " already has access to this group.";
                        actionType = "error";
                    } else {
                        PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO group_ip_access(group_id,ip_address,added_at) VALUES(?,?,NOW())");
                        ps.setInt(1, Integer.parseInt(gId)); ps.setString(2, ip.trim());
                        ps.executeUpdate();
                        actionMsg  = "IP " + ip.trim() + " added successfully!";
                        actionType = "success";
                    }
                } catch (Exception e) {
                    actionMsg  = "Error adding IP: " + e.getMessage();
                    actionType = "error";
                }
            }
        }

        if ("removeIP".equals(action)) {
            String ipId = request.getParameter("ipId");
            if (ipId != null) {
                try {
                    PreparedStatement ps = conn.prepareStatement("DELETE FROM group_ip_access WHERE id=?");
                    ps.setInt(1, Integer.parseInt(ipId)); ps.executeUpdate();
                    actionMsg  = "IP removed successfully.";
                    actionType = "success";
                } catch (Exception e) {
                    actionMsg  = "Error removing IP: " + e.getMessage();
                    actionType = "error";
                }
            }
        }

        if ("deleteGroup".equals(action)) {
            String gId = request.getParameter("groupId");
            if (gId != null) {
                try {
                    PreparedStatement p1 = conn.prepareStatement("DELETE FROM group_ip_access WHERE group_id=?");
                    p1.setInt(1, Integer.parseInt(gId)); p1.executeUpdate();
                    PreparedStatement p2 = conn.prepareStatement("DELETE FROM secure_groups WHERE id=?");
                    p2.setInt(1, Integer.parseInt(gId)); p2.executeUpdate();
                    actionMsg  = "Group deleted successfully.";
                    actionType = "success";
                } catch (Exception e) {
                    actionMsg  = "Error deleting group: " + e.getMessage();
                    actionType = "error";
                }
            }
        }
    }
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
        <a href="ADMIN_HOME.jsp" class="nav-item" data-tip="Home"><div class="nav-icon">&#127968;</div><span class="nav-label">Dashboard</span></a>
        <div class="nav-section-label">Management</div>
        <a href="iplocation.jsp" class="nav-item" data-tip="IP Tracking"><div class="nav-icon">&#127757;</div><span class="nav-label">IP Location Tracking</span></a>
        <a href="View_Request.jsp" class="nav-item" data-tip="Mail Requests"><div class="nav-icon">&#128235;</div><span class="nav-label">Mail Requests</span></a>
        <a href="ADMIN_CREATE_GROUP.jsp" class="nav-item active" data-tip="Groups"><div class="nav-icon">&#128101;</div><span class="nav-label">Manage Groups</span></a>
        <div class="nav-section-label">System</div>
        <a href="index.jsp" class="nav-item logout" data-tip="Logout"><div class="nav-icon">&#128682;</div><span class="nav-label">Logout</span></a>
    </nav>
</aside>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-toggle">&#9776;</div>
        <div class="topbar-breadcrumb">
            <a href="ADMIN_HOME.jsp">Admin</a><span class="sep"> / </span>
            <span class="current">Manage Groups</span>
        </div>
        <div class="topbar-spacer"></div>
        <div class="topbar-time" id="admin-clock"></div>
        <div class="topbar-notif">&#128276;</div>
    </header>

    <main class="admin-content">
        <div class="page-header">
            <h1>&#128101; Manage Secure Groups</h1>
            <p>Create IP-gated secure groups and assign user IP addresses to control channel access.</p>
        </div>

        <%-- Action Alert --%>
        <% if (!actionMsg.isEmpty()) { %>
        <div class="alert alert-<%=actionType%>">
            <span><%="success".equals(actionType)?"✓":"✕"%></span> <%=actionMsg%>
        </div>
        <% } %>

        <%-- DB Error --%>
        <% if (conn == null && actionMsg.isEmpty()) { %>
        <div class="alert alert-error">&#10006; Could not connect to the database.</div>
        <% } %>

        <div style="display:grid;grid-template-columns:1fr 1.6fr;gap:20px;align-items:flex-start;" class="group-layout">

            <%-- CREATE FORM --%>
            <div class="admin-card" style="margin-bottom:0;position:sticky;top:80px;">
                <div class="admin-card-header">
                    <div class="admin-card-title">
                        <div class="admin-card-icon">&#43;</div>
                        Create New Group
                    </div>
                </div>
                <div class="admin-card-body">
                    <div style="background:rgba(245,158,11,0.08);border:1px solid rgba(245,158,11,0.2);border-radius:var(--radius-sm);padding:11px 14px;margin-bottom:18px;font-size:0.81rem;color:var(--primary);display:flex;align-items:flex-start;gap:8px;">
                        <span style="flex-shrink:0;">&#128274;</span>
                        Groups use IP-based access control. Only listed IPs can see group chat content.
                    </div>

                    <form method="post" action="ADMIN_CREATE_GROUP.jsp">
                        <input type="hidden" name="action" value="createGroup">

                        <div class="form-group">
                            <label class="form-label">Group Name <span>*</span></label>
                            <input type="text" name="groupName" class="form-control"
                                   placeholder="e.g. Emergency Response Team" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Description</label>
                            <textarea name="groupDesc" class="form-control"
                                      placeholder="Brief description of this group's purpose..."></textarea>
                        </div>

                        <button type="submit" class="btn btn-amber" style="width:100%;justify-content:center;">
                            &#43;&nbsp; Create Group
                        </button>
                    </form>
                </div>
            </div>

            <%-- EXISTING GROUPS --%>
            <div>
                <div style="font-family:'Syne',sans-serif;font-size:0.9rem;font-weight:700;color:var(--text);margin-bottom:14px;display:flex;align-items:center;gap:8px;">
                    <span style="width:26px;height:26px;background:rgba(245,158,11,0.2);border-radius:7px;display:inline-flex;align-items:center;justify-content:center;font-size:0.85rem;">&#128274;</span>
                    Existing Groups &amp; IP Access
                </div>

                <%
                    if (conn != null) {
                        try {
                            ResultSet groups = conn.createStatement().executeQuery(
                                "SELECT * FROM secure_groups ORDER BY created_at DESC");
                            boolean any = false;

                            while (groups.next()) {
                                any = true;
                                int gId    = groups.getInt("id");
                                String gNm = groups.getString("group_name");
                                String gDs = groups.getString("group_desc");

                                /* Count IPs */
                                PreparedStatement cntPs = conn.prepareStatement(
                                    "SELECT COUNT(*) AS c FROM group_ip_access WHERE group_id=?");
                                cntPs.setInt(1, gId);
                                ResultSet cntRs = cntPs.executeQuery();
                                int ipCnt = cntRs.next() ? cntRs.getInt("c") : 0;
                                cntRs.close(); cntPs.close();
                %>

                <div class="group-item">
                    <div class="group-item-header">
                        <div>
                            <div class="group-item-title">&#128101;&nbsp;<%=gNm%></div>
                            <% if (gDs!=null && !gDs.isEmpty()) { %>
                            <div class="group-item-desc"><%=gDs%></div>
                            <% } %>
                        </div>
                        <div style="display:flex;align-items:center;gap:10px;flex-shrink:0;">
                            <span class="badge badge-allowed"><%=ipCnt%> IP<%=ipCnt!=1?"s":""%></span>
                            <form method="post" action="ADMIN_CREATE_GROUP.jsp" style="display:inline;"
                                  onsubmit="return confirm('Delete group &quot;<%=gNm%>&quot; and all its IP access? This cannot be undone.');">
                                <input type="hidden" name="action" value="deleteGroup">
                                <input type="hidden" name="groupId" value="<%=gId%>">
                                <button type="submit" class="btn btn-danger btn-xs">&#128465; Delete</button>
                            </form>
                        </div>
                    </div>

                    <div class="group-item-body">
                        <%-- IP Table --%>
                        <div class="admin-table-wrap" style="margin-bottom:16px;">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>IP Address</th>
                                        <th>Added On</th>
                                        <th>Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    PreparedStatement ipSt = conn.prepareStatement(
                                        "SELECT * FROM group_ip_access WHERE group_id=? ORDER BY added_at ASC");
                                    ipSt.setInt(1, gId);
                                    ResultSet ips = ipSt.executeQuery();
                                    int ipNum = 0;
                                    while (ips.next()) {
                                        ipNum++;
                                %>
                                <tr>
                                    <td><span class="table-num"><%=ipNum%></span></td>
                                    <td>
                                        <span class="badge badge-allowed" style="font-family:monospace;">
                                            &#9679;&nbsp;<%=ips.getString("ip_address")%>
                                        </span>
                                    </td>
                                    <td style="color:var(--text-mid);font-size:0.8rem;"><%=ips.getString("added_at")%></td>
                                    <td>
                                        <form method="post" action="ADMIN_CREATE_GROUP.jsp" style="display:inline;"
                                              onsubmit="return confirm('Remove this IP address?');">
                                            <input type="hidden" name="action" value="removeIP">
                                            <input type="hidden" name="ipId" value="<%=ips.getInt("id")%>">
                                            <button type="submit" class="btn btn-danger btn-xs">&#10006; Remove</button>
                                        </form>
                                    </td>
                                </tr>
                                <%  }
                                    if (ipNum == 0) { %>
                                <tr>
                                    <td colspan="4" style="text-align:center;color:var(--text-light);font-style:italic;padding:16px;">
                                        No IP addresses added yet.
                                    </td>
                                </tr>
                                <%  }
                                    ips.close(); ipSt.close();
                                %>
                                </tbody>
                            </table>
                        </div>

                        <%-- Add IP Form --%>
                        <form method="post" action="ADMIN_CREATE_GROUP.jsp">
                            <input type="hidden" name="action" value="addIP">
                            <input type="hidden" name="groupId" value="<%=gId%>">
                            <div class="ip-form-inline">
                                <input type="text" name="ipAddress" class="form-control"
                                       placeholder="e.g. 192.168.1.10"
                                       pattern="^(\d{1,3}\.){3}\d{1,3}$"
                                       title="Enter a valid IPv4 address" required>
                                <button type="submit" class="btn btn-green" style="white-space:nowrap;">
                                    &#43;&nbsp; Add IP
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <%
                            } // end while groups

                            if (!any) {
                %>
                <div class="empty-state" style="background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:40px 20px;">
                    <span class="empty-icon">&#128101;</span>
                    <h3>No groups yet.</h3>
                    <p>Use the form on the left to create your first secure group.</p>
                </div>
                <%
                            }
                        } catch (Exception e) {
                %>
                <div class="alert alert-error">&#10006; Error loading groups: <%=e.getMessage()%></div>
                <%  }
                    }
                %>
            </div>

        </div><%-- /.group-layout --%>

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
                <li><a href="View_Request.jsp">Mail Requests</a></li>
            </ul></div>
        </div>
        
    </footer>
</div>

<% if (conn != null) { try { conn.close(); } catch (Exception ex) {} } %>

<style>
.group-layout { display:grid; grid-template-columns:1fr 1.6fr; gap:20px; align-items:flex-start; }
@media(max-width:900px){ .group-layout{ grid-template-columns:1fr; } .admin-card[style*="sticky"]{position:relative;top:0 !important;} }
</style>
<script src="js/admin.js"></script>
</body></html>
