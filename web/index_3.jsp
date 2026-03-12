<%-- 
    Document   : index_1
    Created on : 11 Nov, 2024, 4:54:49 PM
    Author     : Admin1
--%>



<%@page import="Connection.DbConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.net.InetAddress"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
    <!-- Basic -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">   
   
    <!-- Mobile Metas -->
    <meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
 
     <!-- Site Metas -->
    <title>Intrusion Detection System</title>  
    <meta name="keywords" content="">
    <meta name="description" content="">
    <meta name="author" content="">
       <script src="https://api.tomtom.com/maps-sdk-for-web/cdn/5.x/5.64.0/services/services-web.min.js"></script>
         <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
          <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/form.css">
  
        <script type="text/javascript">
            var map = null;
            var latLong = null;
            function showlocation() {
                // One-shot position request.
                navigator.geolocation.getCurrentPosition(callback);
            }

            function callback(position) {

                var lat = position.coords.latitude;
                var lon = position.coords.longitude;
                document.getElementById("lat").value = lat;
                document.getElementById("lan").value = lon;

                latLong = new google.maps.LatLng(lat, lon);

                var latlng = new google.maps.LatLng(lat, lon);
                var geocoder = new google.maps.Geocoder();
                geocoder.geocode
                        ({'latLng': latlng},
                                function (results, status)
                                {
                                    var add = document.getElementById("city").value = results[0].formatted_address;
                                    alert(add);
                                });
                var addr = document.getElementById("city").value;
                if (addr === '' || addr === null || addr === undefined) {
                    tt.services.reverseGeocode({key: "1MmbJI1SBWF7Yht63JQXbpE5Yp5BvAge", position: latLong})

                            .go()
                            .then(function (results) {
                                // alert("success");
                                var add = document.getElementById("city").value = results.addresses[0].address.freeformAddress;
                                //alert(add); 
                                //alert(results.addresses[0].address.freeformAddress);
                            });
                    initMap();
                }
            }
            function initMap() {
                var mapOptions = {
                    center: latLong,
                    zoom: 8,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };
                map = new google.maps.Map(document.getElementById("map-canvas"),
                        mapOptions);
                var marker = new google.maps.Marker({
                    position: latLong
                });

                marker.setMap(map);
                map.setZoom(8);
                map.setCenter(marker.getPosition());
            }

            //   google.maps.event.addDomListener(window, 'load', initMap);
        </script>
<script type="text/javascript">

      var flashvars = {};
      flashvars.cssSource = "piecemaker.css";
      flashvars.xmlSource = "photo_list.xml";
		
      var params = {};
      params.play = "true";
      params.menu = "false";
      params.scale = "showall";
      params.wmode = "transparent";
      params.allowfullscreen = "true";
      params.allowscriptaccess = "always";
      params.allownetworking = "all";
	  
      swfobject.embedSWF('piecemaker.swf', 'piecemaker', '940', '420', '10', null, flashvars,    
      params, null);
    
</script>
<script>
     function validateTime() {
var id=document.getElementById("userid").value;
var pass=document.getElementById("password").value;

 

if(id===""){    
    alert("Error: uid cannot be blank!");
    return false;
}
if(pass===""){    
    alert("Error: pwd cannot be blank!");
    return false;
}
if(!ValidCaptcha()){
    
     alert("Entered Captcha is Wrong ");
 return false; 
    
}


else{return  true;}

}
</script>
<script language="javascript" type="text/javascript">
function clearText(field)
{
    if (field.defaultValue == field.value) field.value = '';
    else if (field.value == '') field.value = field.defaultValue;
}
</script>
   <script type="text/javascript">

   //Created / Generates the captcha function    
    function DrawCaptcha()
    {
        var a = Math.ceil(Math.random() * 10)+ '';
        var b = Math.ceil(Math.random() * 10)+ '';       
        var c = Math.ceil(Math.random() * 10)+ '';  
        var d = Math.ceil(Math.random() * 10)+ '';  
        var e = Math.ceil(Math.random() * 10)+ '';  
        var f = Math.ceil(Math.random() * 10)+ '';  
        var g = Math.ceil(Math.random() * 10)+ '';  
        var code = a + ' ' + b + ' ' + ' ' + c + ' ' + d + ' ' + e + ' '+ f + ' ' + g;
        document.getElementById("txtCaptcha").value = code
    }

    // Validate the Entered input aganist the generated security code function   
    function ValidCaptcha(){
        var str1 = removeSpaces(document.getElementById('txtCaptcha').value);
        var str2 = removeSpaces(document.getElementById('txtInput').value);
        if (str1 == str2) return true;        
        return false;
        
    }

    // Remove the spaces from the entered and generated code
    function removeSpaces(string)
    {
        return string.split(' ').join('');
    }
    
 
    </script>

</head>
<body onload="DrawCaptcha();display();">
    
     <nav>
            <ul>
               <li><a href="index.jsp">HOME</a></li>
        <li><a href="user.jsp">USER REGISTER</a></li>
        <li><a href="USER_LOGIN.jsp">USER LOGIN</a></li>
        <li><a href="ADMIN_LOGIN.jsp">ADMIN LOGIN</a></li>
            </ul>
        </nav>
        
    
    <div class="slideshow-container">
        <img class="slides" src="images/home1.jpg" alt="Tracking Concept 1">
          <div class="centered">
              <h1>Welcome to the Tracking System</h1>
          <p>Track and monitor activities in real-time with advanced features and security.</p>
          
          </div>
        <img class="slides" src="images/home2.jpg" alt="Tracking Concept 2">
        <img class="slides" src="images/home3.jpg" alt="Tracking Concept 3">
    </div>

    <div class="dot-container">
        <span class="dot" onclick="currentSlide(1)"></span>
        <span class="dot" onclick="currentSlide(2)"></span>
        <span class="dot" onclick="currentSlide(3)"></span>
    </div>
       

               <%
            String msg = (String) session.getAttribute("msg");
            if (msg != null) {
        %>
        <script>
            var ss = '<%=msg%>';
            alert(ss);
        </script>
        <%
                session.removeAttribute("msg");
            }
        %>
        
        
        
     <%
    // Attempt to retrieve the IP address from the headers
    String ip = InetAddress.getLocalHost().getHostAddress();
    
    

    
    try {
        String qry = "SELECT * FROM block WHERE ip='" + ip + "'";
        DbConnection db = new DbConnection();
        ResultSet rs = db.Select(qry);
        if (rs.next()) {
            response.sendRedirect("Error.jsp");
        }
    } catch (Exception e) {
        out.println(e);
    }
%>

   
               <h2 class="header-title">USER LOGIN</h2>
            
            <div class="formbold-main-wrapper">

  <div class="formbold-form-wrapper">
    
     <form method="POST" name="form1" action="login4.jsp" id="loginForm" onSubmit="return validateTime();ValidCaptcha()" class="login__form">
      <div class="formbold-mb-3">
        <div>
          <label for="firstname" class="formbold-form-label">User ID</label>
          <input type="text"  name="aadhar_no"  id="firstname" placeholder="Enter Aadhar Number" class="formbold-form-input" required />
        </div>

        
      </div>
        <div class="formbold-mb-3">
        <div>
          <label for="firstname" class="formbold-form-label">Password </label>
          <input type="password" name="Password"  id="firstname" placeholder="Enter your Password" class="formbold-form-input" required />
        </div>
      </div>
         
          <div class="formbold-mb-3">
        <div>
          <label for="firstname" class="formbold-form-label">Captcha </label>      
          <input type="text"  id="txtCaptcha" class="formbold-form-input" readonly />
           <input type="button" class="login__input" id="btnrefresh" value="Refresh" onclick="DrawCaptcha();" />
        </div>
      </div>
         
         
          <div class="formbold-mb-3">
        <div>
          <label for="firstname" class="formbold-form-label">Type </label>
          <input type="text" id="txtInput"  class="formbold-form-input" required />
        </div>
      </div>
                     <input type="hidden" value="<%= ip %>" name="ip" readonly>
                    <input class="qsd"  type="hidden" value="" id="city" name="city"  readonly>
                    <input class="qsd" type="hidden" value="" id="lat" name="lat"  readonly>
                    <input class="qsd" type="hidden" value="" id="lan" name="lan"  readonly>
  
      <button type="submit"class="formbold-btn">Login</button>
            <button type="Reset" class="formbold-btn" >Reset</button>

     </form>    
  </div>
                    </div>
      
            <div class="footer-text">
            <center>	<script  src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBOU-GKNx-YL5o-b8cvlqgyn0rso6iQtUk&callback=showlocation"
                type="text/javascript"></script></center>
        </div>                    
<h2 class="contact-us">Contact Us</h2>
    <section id="contact">
  <div class="container">
    
    <div class="contact-info">
      <div class="social-media">
        <h3>Follow Us</h3>
        <ul>
          <li><a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i> Facebook</a></li>
          <li><a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i> Twitter</a></li>
          <li><a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i> Instagram</a></li>
          <li><a href="https://linkedin.com" target="_blank"><i class="fab fa-linkedin"></i> LinkedIn</a></li>
        </ul>
      </div>
      
      <div class="useful-links">
        <h3>Useful Links</h3>
        <ul>
          <li><a href="/about-us">About Us</a></li>
          <li><a href="/faq">FAQ</a></li>
          <li><a href="/terms">Terms & Conditions</a></li>
          <li><a href="/privacy-policy">Privacy Policy</a></li>
        </ul>
      </div>
      
      <div class="services">
        <h3>Our Services</h3>
        <ul>
          <li><a href="/services/web-design">Web Design</a></li>
          <li><a href="/services/seo">SEO Services</a></li>
          <li><a href="/services/mobile-app">Mobile App Development</a></li>
          <li><a href="/services/cloud">Cloud Solutions</a></li>
        </ul>
      </div>
    </div>
  </div>
</section>



                    <script src="js/main.js"></script>
</body>
</html>