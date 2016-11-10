$(function(){
  var InstructionBalloon = $('.instruction_balloon');
  $Favo = $('.mymemory a');
  $WatchStat = $(".mymemory button");
  // InstructionBalloon.hide();
  
  $Favo.on("mouseover", function(){
  	var This = $(this);
    This.siblings('.instruction_balloon').text("clickして「お気に入り」に登録").stop().fadeIn(100);
  });
  $Favo.on("mouseleave", function(){
  	var This = $(this);
    This.siblings('.instruction_balloon').stop().fadeOut(100);
  });
  
  $WatchStat.on("mouseover", function(){
    var DisplayTarget = $(this).siblings('.instruction_balloon');
    DisplayTarget.text("clickして「みたアニメ」に登録");
    DisplayTarget.stop().fadeIn(100);
  });

  $WatchStat.on("mouseleave", function(){
    var DisplayTarget = $(this).siblings('.instruction_balloon');
    DisplayTarget.stop().fadeOut(100);
  });

});
