$(function(){
  $("#commit").on("click", function(){
    $comment = $("#comment");
    var content = $comment.val();
    var tid = parseInt($comment.attr("data-tid"), 10);
    var token = $("*[name=authenticity_token]").val();
    $.ajax({
      type: "POST",
      data: {
        tid : tid,
        content: content,
        authenticity_token : token
      },
      url: $("#comment-form").attr("action"),
      statusCode: {
        404: function(){
          alert("投稿に失敗しました。コメントは2000文字以内で入力してください。");
        },
        500: function(){
          alert("システムエラーです。更新した後にお試しください。");
        }
      }
    }).done(function(data){
      $("#thread").empty().append(data);
      $comment.val("");
    }).fail(function(){
        alert("エラーです。");
    });
    return false;
  });
});