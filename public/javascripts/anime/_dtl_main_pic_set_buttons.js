$(function(){
  $('div.dtl-main-pic-set-buttons > a:nth-child(1)').on('mouseover', function(){
    $('.explantion-balloon').fadeIn('fast');
  });
  $('div.dtl-main-pic-set-buttons > a:nth-child(1)').on('mouseleave', function(){
    $('.explantion-balloon').fadeOut('fast');
  });
});
