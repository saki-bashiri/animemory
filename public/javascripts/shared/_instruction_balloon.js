$(function(){
  
  $('.favo').on("mouseenter", function(){
    var DisplayTarget = $(this).closest('li').find('.instruction-balloon');
    DisplayTarget.text("お気に入りに登録").stop().fadeIn(150);
  });

  $('.favo').on("mouseleave", function(){
    var DisplayTarget = $(this).closest('li').find('.instruction-balloon');
    DisplayTarget.stop().fadeOut(150);
  });
  
  $('.watch-status').on("mouseenter", function(){
    var DisplayTarget = $(this).closest('li').find('.instruction-balloon');
    DisplayTarget.text("みてるアニメに登録").stop().fadeIn(150);
  });

  $('.watch-status').on("mouseleave", function(){
    var DisplayTarget = $(this).closest('li').find('.instruction-balloon');
    DisplayTarget.stop().fadeOut(150);
  });

});
