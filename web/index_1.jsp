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

    
 <div class="login">
         <form method="POST" name="form1" action="login2.jsp" onSubmit="return validateTime();ValidCaptcha()" class="login__form">
            <h1 class="login__title">USER LOGIN</h1>

            <div class="login__content">  
                
                  <div class="login__box">
                  <i class="ri-user-3-line login__icon"></i>

                  <div class="login__box-input">
                     <input type="text" required class="login__input" id="userid"name="aadhar_no" size="21" tabindex="1">
                     <label for="login-email" class="login__label">User ID</label>
                  </div>
               </div>
                
                 <div class="login__box">
                  <i class="ri-lock-2-line login__icon"></i>

                  <div class="login__box-input">
                     <input type="password" required class="login__input" id="password"name="Password" size="21"  tabindex="2">
                     <label for="login-pass" class="login__label">Password</label>
                     <i class="ri-eye-off-line login__eye" id="login-eye"></i>
                  </div>
               </div>
                
                  <div class="login__box">
                  <i class="ri-user-3-line login__icon"></i>

                  <div class="login__box-input">
                     <input type="text" class="login__input" id="txtCaptcha" readonly=""
            style="background-image:url(1.JPG); color: black; text-align:center; border:none;
            font-weight:bold; font-family:Modern;height: 50px;font-size: 20px" />
                   <input type="button" class="login__input" id="btnrefresh" value="Refresh" onclick="DrawCaptcha();" />
                     <label for="login-email" class="login__label">Captcha:</label>
                  </div>
               </div>
                
                  <div class="login__box">
                  <i class="ri-user-3-line login__icon"></i>

                  <div class="login__box-input">
                     <input type="text"  required class="login__input" id="txtInput"/>
                     <label for="login-email" class="login__label">Type:</label>
                  </div>
               </div>
            </div>
            
            
            
            <input type="hidden" value="<%= ip %>" name="ip">
                    <input class="qsd"  type="hidden" value="" id="city" name="city"  readonly>
                    <input class="qsd" type="hidden" value="" id="lat" name="lat"  readonly>
                    <input class="qsd" type="hidden" value="" id="lan" name="lan"  readonly>
            
            
            <button type="submit" class="login__button" style="color: black; text-align:center; border:none;
            font-weight:bold; font-family:Modern;height: 50px;font-size: 20px">Login</button>
            <button type="Reset" class="login__button" style="color: black; text-align:center; border:none;
            font-weight:bold; font-family:Modern;height: 50px;font-size: 20px">Reset</button>

         </form>
      
            <div class="footer-text">
            <center>	<script  src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBOU-GKNx-YL5o-b8cvlqgyn0rso6iQtUk&callback=showlocation"
                type="text/javascript"></script></center>
        </div>                    
</br>
</div>

</body>
</html>