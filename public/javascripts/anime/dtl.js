var $favorite    = $(".mymemo-fv");
var $watchStatus = $(".mymemo-wc");
$(function(){
  $(".delete-tag").hide();
  $("#anime-image").on("error", function(){
    var url = $("#js").data("noimage");
    $(this).attr("src", url);
  });
  $("#add-tag").hide();
  $("#addtag-button").on("click", function(){
    $("#add-tag").toggle('fast');
  });
  $("#add-tag-form").on("submit", function(){
    if ( !$("#new-tag").val() ){
      alert("タグを入力してください。");
      return false;
    } else if ( $("#new-tag").val().length > 50 ){
      alert("タグは50文字以内で入力してください。");
      return false;
    }
  });
  $("#deltag-button").on("click", function(){
    $(".delete-tag").toggle('fast');
  });
  $(".delete-tag-btn").on("click", function(){
    if ( confirm("タグを削除していいですか？") ){
      var tagid = $(this).data("id");
      $("#deltag_" + tagid).submit();
    } else {
      return false;
    }
  });
});
