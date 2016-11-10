$(function(){
  var $setting = $("#setting");
  var $linkSet = $('.mypage-link-set li a');
  var $currentAction = $('.mypage-link-set').attr("data-action");

  switch($currentAction){
    case 'media_list':
      $('.mypage-link-set > ul > li:nth-child(1)').addClass('active');
    break;
    case 'my_channel':
      $('.mypage-link-set > ul > li:nth-child(1)').addClass('active');
    break;
    case 'can_watch':
      $('.mypage-link-set li:nth-child(2)').addClass('active');
    break;
    case 'favo':
      $('.mypage-link-set li:nth-child(3)').addClass('active');
		break;
    case 'watched':
      $('.mypage-link-set li:nth-child(4)').addClass('active');
		break;
    case 'watching':
      $('.mypage-link-set li:nth-child(5)').addClass('active');
    break;
    case 'notice':
      $('.mypage-link-set li:nth-child(6)').addClass('active');
    break;
    case 'index':
      $('.mypage-link-set li:nth-child(7)').addClass('active');
    break;
  }

  $linkSet.on('mouseover', function(){
    var $this = $(this);
    if ($this.parent('li').hasClass('active')){
      $this.siblings('span').text("表示中");
    }
    $this.siblings('span').stop().fadeIn(100);
  });
  
  $linkSet.on('mouseleave', function(){
    $(this).siblings('span').stop().fadeOut(100);
  });

  $('#setting > a:first-child').on("click", function(e){
    e.preventDefault();
  });

  $setting.on("mouseover", function(){
    $("#setting-list").show();
    $('.mypage-link-set > ul > li:first-child > a > span').addClass('setting-active');
  });

  $setting.on("mouseleave", function(){
    $("#setting-list").hide();
    $('.mypage-link-set > ul > li:first-child > a > span').removeClass('setting-active');
  });
});
