$('select').select2({
  minimumResultsForSearch: -1
});

$('.header-nav__button i').click(function(){
  $('body').addClass('show-nav');
  $('nav').animate({left: '0px'});
});

$('.overview').click(function(){
  $('body').removeClass('show-nav');
  $('nav').animate({left: '-170px'});
});

$('#export, #import, #details').on('scroll', function(e) {
  if (this.scrollTop > 80) {
    $('.ship-map').addClass('fixed-ship__map');
  } else {
    $('.ship-map').removeClass('fixed-ship__map');
  }
})

$('.map-fab').click(function(){
	$('.ship-map').fadeToggle()
	$(this).find('i').toggleClass('fas fa-times')
})