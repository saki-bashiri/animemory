$(function(){
  $('.am-thumbnail').hover(function(){
    $("dl", this).stop().fadeTo("fast", 1).animate({top:'80px'},{queue:false,duration:200});
  }, function() {
    $("dl", this).stop().fadeTo("fast", 1.1).animate({top:'120px'},{queue:false,duration:200});
  });
});

