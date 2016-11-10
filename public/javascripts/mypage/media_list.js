$(function(){
  var anchors = $(".media-list-area-anchors");
  var anchorsShow = $(".media-list-area-anchors-show");
  anchors.hide();

  anchorsShow.on("mouseenter", function(){
    anchors.stop().fadeIn(100);
  });
  anchorsShow.on("mouseleave", function(){
    anchors.stop().fadeOut(100);
  });

  var token = $("#authenticity_token").attr("data-token");
  $(".media-select").on("click", function(){
    var $this = $(this);
    var action = $this.attr("data-select") === "1" ? "delete" : "select";
    $.ajax({
      url : "/mypage/media_select",
      type : "POST",
      data : {mid : $this.attr("data-mid"), type : action , token : token }
    }).done(function(data){
      var currentSelect = data.type === "selected" ? "1" : "0";
      var currentSelectName = data.type === "selected" ? "選択済" : "未選択";
      $this.attr("data-select", currentSelect).text(currentSelectName);
      if (data.type === "selected"){
        $this.closest('li').addClass('selected')
      }else{
        $this.closest('li').removeClass('selected')
      }
    });
    return false;
  });

  $("#next-button").on("click", function(){
    var url = $(this).attr("data-url");
    window.location.href = url;
  });
});
