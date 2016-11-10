$(function(){
  var ignoreActions = ['media_list', 'register', 'edit'];
  var dataAction = $('.layout-header-form').attr('data-action');
  var ignoreAction = $.inArray(ignoreActions);
  if (ignoreAction === -1){
    $(".swrfixed").swrfixed({
      bottom: 200
    });
  }
  
  $("#search-form").on("submit", function(){
    var key = $("li button.active").attr("data-key");
    $("#hidden_key").val(key);
    return;
  });
});
