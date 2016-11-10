$(function(){
  $wiki = $(".wiki");
  $wiki.each(function(){
    $(this).css("color", $(this).attr("data-color"));
    $(this).css("font-size", parseInt( $(this).attr("data-size"), 10) );
  });
});
