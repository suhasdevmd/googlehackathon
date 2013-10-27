<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>

<title>Maps</title>

<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
<meta charset="utf-8">
<link href="/maps/documentation/javascript/examples/default.css"
	rel="stylesheet">

<style>
html,body,#map-canvas {
	height: 100%;
	margin: 0px;
	padding: 0px
}

#panel {
	position: absolute;
	top: 5px;
	left: 50%;
	margin-left: -180px;
	z-index: 5;
	background-color: #fff;
	padding: 5px;
	border: 1px solid #999;
}
</style>

<script
	src="https://maps-api-ssl.google.com/maps/api/js?key=AIzaSyDKV2SLtHMiVMjB4vAD0W56UmlviLfR1XU&sensor=false">
	
</script>

<!--<script
	src="http://maps.googleapis.com/maps/api/js?key=AIzaSyDKV2SLtHMiVMjB4vAD0W56UmlviLfR1XU&sensor=false">
	
</script>
-->
<!--<script
	src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
-->
<script>

	var ltt=12.9667, lgt=77.5667, zoom=2, input, KeyWord, action=100;
	var mapOptions;
	var map;
	var geocoder;
	var marker;
	
	
	
	function perfomActionCommands(){
		input = document.getElementById('keyWord').value;
		//alert("input = "+input);
		
		keyWord = input.split(" ")[0];
		action = input.split(" ")[1];
		
		alert("keyword="+keyWord);
		alert("action="+action); 
		
		if(keyWord == "left"){
			
			calcDistanceLeft(ltt,lgt,action);
			mapOptions.setCenter(new google.maps.LatLng(ltt, lgt))
			
		}else if(keyWord == "right"){
			
			calcDistanceRight(ltt,lgt,action);
			
		}else if(keyWord == "up"){
			
			calcDistanceUp(ltt,lgt,action);
			
		}else if(keyWord == "down"){
			
			calcDistanceDown(ltt,lgt,action);
			
		}else if(keyWord == "zoom"){
			if(action == "in"){
				zoom = zoom + 2;
				map.setZoom(zoom);
			}else{
				zoom = zoom - 2;
				map.setZoom(zoom);
			}
		}
		else if(keyWord == "type"){
			if(action == "terrain"){
				map.setMapTypeId(google.maps.MapTypeId.TERRAIN);
			}if(action == "hybrid"){
				map.setMapTypeId(google.maps.MapTypeId.HYBRID);
			}if(action == "satellite"){
				map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
			}if(action == "road"){
				map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
			}
		}else if(keyWord == "locate"){
			codeAddress(action);
		}
		
		
		
		else {
			alert("Invalid command. Please Follow the general template");	
		}
		//initialize();
	}

	function calcDistanceLeft(ltt,lgt,action){
		//public LatLng translateCoordinates(final double distance, final LatLng origpoint, final double angle) {
	    
			alert("ltt="+ltt+"lgt="+lgt);
			
		var distanceNorth = Math.sin(90) * action *1000;
        var distanceEast = Math.cos(90) * action *1000;
 
        
        var earthRadius = 6371000;
 
        var newLat = ltt + (distanceNorth / earthRadius) * 180 / Math.PI;
        var newLon = lgt + (distanceEast / (earthRadius * Math.cos(newLat * 180 / Math.PI))) * 180 / Math.PI;
	        
	        ltt = newLat;
	        lgt = newLon;
	        zoom =15;
	        
	        alert("ltt="+ltt+"lgt="+lgt);
	        
	        
	        mapOptions = {
	    			zoom : zoom,
	    			center : new google.maps.LatLng(newLat, newLon),
	    			mapTypeId : google.maps.MapTypeId.ROADMAP
	    		};
	        
	        
			//initialize()
	}
		
	function codeAddress(address) {
	    //var address = document.getElementById("address").value;
	    
	    alert(address);
	    
	    geocoder.geocode( { 'address': address}, function(results, status) {
	      if (status == google.maps.GeocoderStatus.OK) {
	    	
	        map.setCenter(results[0].geometry.location);
	        marker.setMap(null);
	        marker = new google.maps.Marker({
	            map: map,
	            position: results[0].geometry.location
	        });
	      } else {
	        alert("Geocode was not successful for the following reason: " + status);
	      }
	    });
	    
	    //initialize();
	  }
	
	function changeTer(){
		map.setMapTypeId(google.maps.MapTypeId.TERRAIN);
	}
	
	function changeHyb(){
		map.setMapTypeId(google.maps.MapTypeId.HYBRID);
	}
	
	function changeSat(){		
		map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
	}
	
	function changeRoad(){	
		map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
	}
	

	function initialize() {

		/* var ltt=document.getElementById('lat').value;
		var lgt=document.getElementById('longi').value;

	
		ltt=12.77;
		lgt=77.65; */
		
		//alert("ltt="+ltt+"lgt="+lgt);
		
		geocoder = new google.maps.Geocoder();
		
		
		mapOptions = {
			zoom : zoom,
			center : new google.maps.LatLng(ltt, lgt),
			mapTypeId : google.maps.MapTypeId.ROADMAP
		};

		map = new google.maps.Map(document.getElementById('map-canvas'),
				mapOptions);

		//var ic = new google.maps.MarkerImage();
		var val= ' Suhas '; 
		
		var contentString = '<p><b>IIITB</b>, also referred to as'+val+' <b>IIIT Bangalore</b></p> ' +
        '<img src="images/test.jpg" alt="Sample" width="100px" height="50px"/>';
		
      var infowindow = new google.maps.InfoWindow({
          content: contentString,
          maxWidth: 200
      });
		
		
		
		marker = new google.maps.Marker( {
			position : map.getCenter(),
			map : map,
			title : 'Google hackathon'
		});

		google.maps.event.addListener(map, 'center_changed', function() {
			// 3 seconds after the center of the map has changed, pan back to the
				// marker.
				window.setTimeout(function() {
					map.panTo(marker.getPosition());
				}, 300000);
			});

		google.maps.event.addListener(marker, 'click', function() {
			//infowindow.open(map,marker);
			//map.setZoom(8);
			//map.setCenter(marker.getPosition());
		});
	}

	google.maps.event.addDomListener(window, 'load', initialize);
</script>
</head>
<body onload="initialize()">

	<s:label value="Latitude"></s:label>
	<s:property value="latitude" />
	<s:label value="Longitude"></s:label>
	<s:property value="longitude" />

	<!--<s:set var="la" value="latitude" id="latt" name="la"/>
<s:set var="lo" value="longitude" id="longg" name="lo"/>

-->


	<s:hidden id="lat" name="lat" value="%{latitude}" />
	<s:hidden id="longi" name="longi" value="%{longitude}" />




	<div id="panel">
		<input type="text" id="keyWord" x-webkit-speech
			onchange="perfomActionCommands()" />

	</div>

	<div id="map-canvas" style="height: 450px; width: 550px;"></div>


</body>
</html>