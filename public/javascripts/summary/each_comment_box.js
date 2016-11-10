$(function() {
  $(".pencil_wrap").off("click");
  $(".pencil_wrap").on("click", function(){
    $(this).siblings(".am-each-comment").toggle('fast');
    return false;
  });
  $(".each-comment-form").on("click", "form .am_comment_submit", function(){
    var $button = $(this);
    var $form = $button.parent("form");
    $.ajax({
      url: "/summary/ajax_post_summary_comments",
      type: "GET",
      data:{
        summary_id: $(this).siblings(".summary_id").attr("value"),
        content_id: $(this).siblings(".content_id").attr("value"),
        content: $(this).siblings(".comment_content").val()
      },
      beforeSend: function(xhr, settings) {
        $button.attr('disabled', true);
      },
      complete: function(xhr, textStatus) {
        $button.attr('disabled', false);
      },
      success: function(result, textStatus, xhr) {
        $button.closest(".am-each-comment-box").html(result);
        $form[0].reset();
      },
      error: function(xhr, textStatus, error) {
        alert('コメントを投稿できませんでした。');
      }
    });
    return false;
  });
});