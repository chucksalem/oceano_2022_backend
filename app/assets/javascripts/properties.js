$(function(){

  $(".fancybox").fancybox();

  $(".fancybox-media").fancybox({
    helpers : {
      media : {}
    }
  });

  $('.open-lightbox').on('click', function(e) {
    e.preventDefault();
    $.fancybox.open($('.fancybox'));
  });


  if($("#map-canvas").length > 0) {
      var lat = $("#map-canvas").data("lat");
      var lon = $("#map-canvas").data("lon");
      var myLatLng = { lat: lat, lng: lon};

      // Create a map object and specify the DOM element for display.
      var map = new google.maps.Map(document.getElementById('map-canvas'), {
        center: myLatLng,
        zoom: 8,
        scrollwheel: false,
        disableDefaultUI: true,
        draggable: false
      });

      var blueDot = {
          path: 'M-50,0a50,50 0 1,0 100,0a50,50 0 1,0 -100,0',
          fillColor: '#4d85bc',
          fillOpacity: 0.8,
          scale: .5,
          strokeWeight: 0
        };

        // Create a marker and set its position.
        var marker = new google.maps.Marker({
          map: map,
          icon: blueDot,
          position: map.getCenter(),
          title: 'Hello World!'
        });
    }

});
