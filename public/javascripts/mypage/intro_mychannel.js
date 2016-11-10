$(function(){
	var finishedText = 'アニメモリ初回設定が完了しました。【利用開始】ボタンからマイページに行きましょう。';
	var finishedTextSub = '※ My!チャンネル以外にも視聴管理に便利な機能がいっぱい！';
  MyChannel.build(undefined, $(".my-channel-list"));
  $('.popular-creator ul li button').on('click', function(){
  	var startAnimemory = $('#start-animemory');
    startAnimemory.find('span').hide();
    startAnimemory.find('a').fadeIn('slow');
    $('.step2').removeClass('active');
    startAnimemory.addClass('active');

    var explanation = $('.explanation');
    explanation.find('h4').text('アニメモリ初回設定完了');
    explanation.find('.main-explanation').text(finishedText);
    explanation.find('.sub-explanation').text(finishedTextSub);
    $('.link-to-mypage').fadeIn('slow');
  });
});
