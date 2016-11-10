$(function(){
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

  var finishedText = '放送局設定が完了しました。【ステップ２】からMy!チャンネル設定画面に行きましょう。';
  var finishedTextSub = '※ My!チャンネル設定をするとお気に入りの声優・制作会社についての新着情報が通知されます';
  $('li span.media a').on('click', function(){
    var toStep2 = $('#to-step-2');
    toStep2.find('span').hide();
    toStep2.find('a').fadeIn('slow');
    $('.step1').removeClass('active');
    toStep2.addClass('active');

    var explanation = $('.explanation');
    explanation.find('h4').text('放送局設定完了');
    explanation.find('.main-explanation').text(finishedText);
    explanation.find('.sub-explanation').text(finishedTextSub);
    $('.button-next').fadeIn('slow');
  });


  $("#next-button").on("click", function(){
    var url = $(this).attr("data-url");
    window.location.href = url;
  });
});
