<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.net.InetAddress"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackSafe — IP Location Tracking</title>
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<%
    /* ---- Fetch blocked IP data ---- */
    String serverIP  = "";
    int    totalBlocked = 0;
    java.util.List<String[]> blockedList = new java.util.ArrayList<String[]>();

    try {
        InetAddress inet = InetAddress.getLocalHost();
        serverIP = inet.getHostAddress();
    } catch (Exception eip) { serverIP = "127.0.0.1"; }

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ip","root","admin");
        ResultSet rs = connection.createStatement().executeQuery("SELECT * FROM block");
        while (rs.next()) {
            totalBlocked++;
            blockedList.add(new String[]{
                rs.getString("ip"),
                rs.getString("lat"),
                rs.getString("lan")
            });
        }
        rs.close(); connection.close();
    } catch (Exception e) { /* handled below */ }
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
        <a href="iplocation.jsp" class="nav-item active" data-tip="IP Tracking"><div class="nav-icon">&#127757;</div><span class="nav-label">IP Location Tracking</span></a>
        <a href="View_Request.jsp" class="nav-item" data-tip="Mail Requests"><div class="nav-icon">&#128235;</div><span class="nav-label">Mail Requests</span></a>
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
            <span class="current">IP Location Tracking</span>
        </div>
        <div class="topbar-spacer"></div>
        <div class="topbar-time" id="admin-clock"></div>
        <div class="topbar-notif">&#128276;</div>
    </header>

    <main class="admin-content">
        <div class="page-header">
            <h1>&#127757; IP Location Tracking</h1>
            <p>Track and map blocked IP addresses. View geographic coordinates and open map view.</p>
        </div>

        <%-- Info strip --%>
        <div style="display:flex;gap:14px;flex-wrap:wrap;margin-bottom:24px;">
            <div class="stat-card amber" style="flex:1;min-width:160px;">
                <div class="stat-icon amber">&#128683;</div>
                <div class="stat-info"><div class="stat-value"><%=totalBlocked%></div><div class="stat-label">Blocked IPs</div></div>
            </div>
            <div class="stat-card blue" style="flex:1;min-width:160px;">
                <div class="stat-icon blue">&#127760;</div>
                <div class="stat-info">
                    <div class="stat-value" style="font-size:0.9rem;font-weight:700;font-family:monospace;"><%=serverIP%></div>
                    <div class="stat-label">Server IP</div>
                </div>
            </div>
        </div>

        <%-- Blocked IPs Grid --%>
        <div class="admin-card">
            <div class="admin-card-header">
                <div class="admin-card-title">
                    <div class="admin-card-icon">&#127757;</div>
                    Tracked Attacker Locations
                </div>
                <span class="badge badge-blocked"><%=totalBlocked%> Blocked</span>
            </div>
            <div class="admin-card-body">
                <% if (blockedList.isEmpty()) { %>
                <div class="empty-state">
                    <span class="empty-icon">&#127757;</span>
                    <h3>No blocked IPs found.</h3>
                    <p>The block list is currently empty.</p>
                </div>
                <% } else { %>
                <div class="ip-location-grid">
                    <% int ipNum = 0; for (String[] bl : blockedList) {
                           ipNum++;
                           String blIP  = bl[0] != null ? bl[0] : "—";
                           String blLat = bl[1] != null ? bl[1] : "N/A";
                           String blLon = bl[2] != null ? bl[2] : "N/A";
                    %>
                    <div class="ip-location-card">
                        <div class="ip-card-header">
                            <div>
                                <div style="font-size:0.68rem;font-weight:700;text-transform:uppercase;letter-spacing:0.8px;color:var(--text-light);margin-bottom:3px;">
                                    Blocked IP #<%=ipNum%>
                                </div>
                                <div class="ip-address-display"><%=blIP%></div>
                            </div>
                            <span class="badge badge-blocked">&#128683; Blocked</span>
                        </div>

                        <div class="ip-coords">
                            <div class="ip-coord-item">
                                <div class="ip-coord-label">&#127761; Latitude</div>
                                <div class="ip-coord-value"><%=blLat%></div>
                            </div>
                            <div class="ip-coord-item">
                                <div class="ip-coord-label">&#127761; Longitude</div>
                                <div class="ip-coord-value"><%=blLon%></div>
                            </div>
                        </div>

                        <% if (!blLat.equals("N/A") && !blLon.equals("N/A")) { %>
                        <a href="#"
                           onclick="window.open('map.jsp?lat=<%=blLat%>&long=<%=blLon%>','mapWin','width=820,height=520,resizable=no'); return false;"
                           class="btn-view-map">
                            &#128205;&nbsp; View on Map
                        </a>
                        <% } else { %>
                        <div style="text-align:center;font-size:0.78rem;color:var(--text-light);padding:9px;background:var(--bg2);border-radius:var(--radius-sm);">
                            Coordinates unavailable
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>

                <%-- Also show as table --%>
                <hr class="divider" style="margin:24px 0;">
                <div style="font-family:'Syne',sans-serif;font-size:0.9rem;font-weight:700;color:var(--text);margin-bottom:14px;">
                    &#128203; Full Block List
                </div>
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>IP Address</th>
                                <th>Latitude</th>
                                <th>Longitude</th>
                                <th>Map</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int tNum = 0; for (String[] bl : blockedList) {
                                   tNum++;
                                   String bIP  = bl[0] != null ? bl[0] : "—";
                                   String bLat = bl[1] != null ? bl[1] : "N/A";
                                   String bLon = bl[2] != null ? bl[2] : "N/A";
                            %>
                            <tr>
                                <td><span class="table-num"><%=tNum%></span></td>
                                <td><span style="font-family:monospace;font-weight:700;color:var(--primary);"><%=bIP%></span></td>
                                <td style="font-family:monospace;color:var(--text-mid);"><%=bLat%></td>
                                <td style="font-family:monospace;color:var(--text-mid);"><%=bLon%></td>
                                <td>
                                    <% if (!bLat.equals("N/A") && !bLon.equals("N/A")) { %>
                                    <button onclick="window.open('map.jsp?lat=<%=bLat%>&long=<%=bLon%>','mapWin','width=820,height=520,resizable=no')"
                                            class="btn btn-amber btn-xs">&#128205; Map</button>
                                    <% } else { %>
                                    <span style="color:var(--text-light);font-size:0.76rem;">N/A</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
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
                <li><a href="View_Request.jsp">Mail Requests</a></li>
                <li><a href="ADMIN_CREATE_GROUP.jsp">Group Management</a></li>
            </ul></div>
        </div>
      
    </footer>
</div>
<script src="js/admin.js"></script>
</body></html>
