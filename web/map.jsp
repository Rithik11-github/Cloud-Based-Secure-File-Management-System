

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset=utf-8>
        <meta name="viewport" content="width=620">
        <title>View Geo-Location</title>
        <link rel="stylesheet" href="css/html5demos.css">
        <script src="js/h5utils.js"></script></head>
    <script language="javascript">
        document.onmousedown = disableclick;
        status = "Right Click Disabled";
        function disableclick(event)
        {
            if (event.button == 2)
            {
                alert("hai");
                return false;
            }
        }
    </script>

    <body>
        <%
            String lat = request.getParameter("lat");
            String lng = request.getParameter("long");

        %>
        <section id="wrapper">
            <div id="carbonads-container"><div class="carbonad"><div id="azcarbon"></div><script type="text/javascript">var z = document.createElement("script");
                z.type = "text/javascript";
                z.async = true;
                z.src = "http://engine.carbonads.com/z/14060/azcarbon_2_1_0_VERT";
                var s = document.getElementsByTagName("script")[0];
                s.parentNode.insertBefore(z, s);</script></div></div>
            <header>
                <h1>geolocation</h1>
            </header>
            <meta name="viewport" content="width=620" />

            <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
            <article>
                <p>Finding your location: <span id="status">checking...</span></p>
            </article>
            <script>
                var lati = '<%=lat%>';
                var long = '<%=lng%>';
                function success(position) {
                    var s = document.querySelector('#status');

                    if (s.className == 'success') {
                        // not sure why we're hitting this twice in FF, I think it's to do with a cached result coming back    
                        return;
                    }

                    s.innerHTML = "found you!";
                    s.className = 'success';

                    var mapcanvas = document.createElement('div');
                    mapcanvas.id = 'mapcanvas';
                    mapcanvas.style.height = '500px';
                    mapcanvas.style.width = '800px';

                    document.querySelector('article').appendChild(mapcanvas);

                    var latlng = new google.maps.LatLng(lati, long);
                    //alert(position.coords.latitude);
                    //alert(position.coords.longitude);
                    var myOptions = {
                        zoom: 15,
                        center: latlng,
                        mapTypeControl: false,
                        navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    };
                    var map = new google.maps.Map(document.getElementById("mapcanvas"), myOptions);

                    var marker = new google.maps.Marker({
                        position: latlng,
                        map: map,
                        title: "You are here! (at least within a " + position.coords.accuracy + " meter radius)"
                    });
                }

                function error(msg) {
                    var s = document.querySelector('#status');
                    s.innerHTML = typeof msg == 'string' ? msg : "failed";
                    s.className = 'fail';

                    // console.log(arguments);
                }

                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(success, error);
                } else {
                    error('not supported');
                }

            </script><a id="html5badge" href="http://www.w3.org/html/logo/">

            </a>   
        </section>
        <script src="js/prettify.packed.js"></script>
        <script>
                var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
                document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
        </script>
        <script>
            try {
                var pageTracker = _gat._getTracker("UA-1656750-18");
                pageTracker._trackPageview();
            } catch (err) {
            }</script>
    </body>
</html>