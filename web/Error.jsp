<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Access Blocked</title>

<link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&display=swap" rel="stylesheet">

<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{
font-family:'Sora',sans-serif;
min-height:100vh;
display:flex;
align-items:center;
justify-content:center;
background:radial-gradient(ellipse at 30% 30%,rgba(214,48,49,.20) 0,transparent 55%),
linear-gradient(145deg,#fff0f0,#fff5f5 50%,#ffe8e8);
}

.card{
background:rgba(255,255,255,.80);
backdrop-filter:blur(20px);
border:1px solid rgba(214,48,49,.15);
border-radius:24px;
padding:54px 48px;
max-width:480px;
width:92%;
text-align:center;
box-shadow:0 20px 60px rgba(214,48,49,.12);
animation:up .4s ease both;
}

@keyframes up{
from{opacity:0;transform:translateY(18px)}
to{opacity:1;transform:translateY(0)}
}

.icon{font-size:58px;margin-bottom:18px;}

h1{
font-size:24px;
font-weight:700;
color:#c0392b;
margin-bottom:10px;
}

p{
font-size:14px;
color:rgba(0,0,0,.55);
line-height:1.8;
margin-bottom:8px;
}

.ip-box{
display:inline-block;
background:rgba(214,48,49,.08);
border:1px solid rgba(214,48,49,.20);
border-radius:10px;
padding:10px 22px;
margin:16px 0;
font-size:13px;
color:#c0392b;
font-weight:600;
}

.contact{
margin-top:22px;
font-size:12.5px;
color:rgba(0,0,0,.40);
}

.contact a{
color:#1e5fc8;
text-decoration:none;
}

.contact a:hover{
text-decoration:underline;
}
</style>

<script>

/* Disable refresh keys */
document.addEventListener("keydown", function(e) {

    if (e.keyCode == 116) { // F5
        e.preventDefault();
    }

    if (e.ctrlKey && e.keyCode == 82) { // Ctrl+R
        e.preventDefault();
    }

    if (e.ctrlKey && e.keyCode == 116) { // Ctrl+F5
        e.preventDefault();
    }

});

/* Disable back button */
history.pushState(null, null, location.href);
window.onpopstate = function () {
    history.go(1);
};

</script>

</head>

<body>

<div class="card">
    <div class="icon">🚫</div>

    <h1>Access Blocked</h1>

    <p>Your IP address has been <strong>blocked</strong> due to repeated failed login attempts.</p>
    <p>This is an automated security measure to protect the ExamSec system.</p>

    <div class="ip-box">
        Your IP has been logged and reported to the system administrator.
    </div>

    <p>If you believe this is a mistake, please contact your system administrator to unblock your access.</p>

    <div class="contact">
        Need help? <a href="mailto:admin@examsec.com">Contact Admin</a>
    </div>

</div>

</body>
</html>