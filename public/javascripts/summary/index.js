$(function() {
  $(".am-new-summary-wrap ul li").wrapInner("<span></span>");
  $(".summary-image").colorbox({rel:'image'});

  $("#comment-form").on("submit", function(){
    if ( $("#comment-content").val().length === 0 ){
      alert("コメントを入力してください");
      return false;
    }
  });
  $(".am-each-comment").hide();

  $(".res-comment-content-balloon").hide();
  $("a.res-comment-anchor").on("mouseover", function(){
    $thisBalloon = $(this).parents(".summary-comment").find(".res-comment-content-balloon");
    $thisBalloon.stop().fadeIn(100);
  }).on("mouseleave", function(){
    $thisBalloon = $(this).parents(".summary-comment").find(".res-comment-content-balloon");
    $thisBalloon.stop().fadeOut(100);
  });
  $("a.res-comment-anchor").on("click", function(e){
    e.preventDefault();
    $anchorFragmentLink = $(this).attr("data-summary-content-id");
    fragmentLinkPosition = $("#" + $anchorFragmentLink).offset().top;
    $('html,body').animate({ scrollTop: fragmentLinkPosition - 80}, 'fast');
  });
});
