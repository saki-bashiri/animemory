$(function(){
  $(".am-sp-new-summary").on("click", "#am-sp-more-new-summaries", function(){
    var $more = $(this);
    var offset = parseInt( $more.attr("data-offset"), 10);
    $.ajax({
      type: "GET",
      data: {offset : offset},
      url: "/smartphone/ajax_get_summaries"
    }).done(function(data){
      $more.before(data);
      $more.attr("data-offset", offset + 1);
    });
    return false;
  });
});
