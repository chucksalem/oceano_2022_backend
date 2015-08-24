$(function(){
  var chocolat = $('#image-lightbox').Chocolat().data('chocolat');

  $(".open-lightbox").on("click", function(e) {
    e.preventDefault();
    chocolat.api().open();
  });

});