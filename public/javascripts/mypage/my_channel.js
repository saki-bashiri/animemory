$(function(){
  MyChannel.build(undefined, $(".my-channel-box"));

  $("#search-button").on("click", function(e){
    e.preventDefault();
    $.ajax({
      data : {q : $("#search-text").val() },
      url : $(this).attr("data-url"),
      type : "POST"
    }).done(function(html){
      $("#search-result").empty().append(html);
      if ( typeof MyChannel !== "undefined" ){
        var $channelWrap = $("#search-result .my-channel-wrap");
        MyChannel.build($channelWrap, $("#search"));
      }
    });
  });
});
