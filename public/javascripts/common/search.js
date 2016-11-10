$(function(){
  $("#search-form").on("submit", function(){
    var key = $("li button.active").attr("data-key");
    $("#hidden_key").val(key);
    return;
  });
});