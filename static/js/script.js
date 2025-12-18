$(document).ready(function() {
  $("a").on('click', function(event) {
    if (this.hash !== "") {
      event.preventDefault();
      var hash = this.hash;
      $('html, body').animate({
        scrollTop: $(hash).offset().top
      }, 800, function(){
        window.location.hash = hash;
      });
    }
  });

  if (localStorage.getItem('splashShown') !== 'true') {
    $('#splash-screen').show();

    setTimeout(function() {
      $('#splash-screen').addClass('fade-out');
      setTimeout(function() {
        $('#splash-screen').remove();
      }, 1000);

      localStorage.setItem('splashShown', 'true');
    }, 5000); 
  } else {
    $('#splash-screen').hide();
  }

  const hero = $('.hero');
    const images = [
      '/static/uploads/images/bupatiwakil.jpg',
      '/static/uploads/images/hero.jpg',
      '/static/uploads/images/heroo.jpg',
      '/static/uploads/images/ukacraft.jpeg',
      '/static/uploads/images/crepes.jpeg'
    ];
    let currentImageIndex = 0;

    function changeBackground() {
      hero.css('background-image', `url('${images[currentImageIndex]}')`);
      currentImageIndex = (currentImageIndex + 1) % images.length;
    }

    setInterval(changeBackground, 4000);

    changeBackground();

  const menuToggle = document.getElementById('menu-toggle');
    const sidebar = document.getElementById('sidebar');

    menuToggle.addEventListener('click', function() {
      sidebar.classList.toggle('show');
      menuToggle.classList.toggle('menu-toggle-active')
    });
});

