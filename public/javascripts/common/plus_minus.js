var plusMinus = {
  plus: 'dtl-info-plus',
  minus: 'dtl-info-minus',
  showEntirelyText:'<li class="show-more" style="float:right;text-align:right;background-color:#fff;">....</li>',
  initialize: function($characters, $songs, $staffs){
    if ($characters.attr('data-count') > 6){
      $characters.addClass(plusMinus.plus);
      var castList = $characters.closest('div').siblings('ul');
      var castListToHide = castList.children('li:gt(5)');
      castListToHide.hide();
      castList.append(plusMinus.showEntirelyText);
    }
    if ($staffs.attr('data-count') > 6){
      $staffs.addClass(plusMinus.plus);
      var stafftList = $staffs.closest('div').siblings('ul');
      var stafftListToHide = stafftList.children('li:gt(5)');
      stafftListToHide.hide();
      stafftList.append(plusMinus.showEntirelyText);
    }
    if ($songs.attr('data-count') > 2){
      $songs.addClass(plusMinus.plus);
      var songList = $songs.closest('div').siblings('ul');
      var songListToHide = songList.children('li:gt(1)');
      songListToHide.hide();
    }
  },
  toShowEntirely: function($targetAttribute){
    var targetList = $targetAttribute.closest('div').siblings('ul');
    var targetToShow = targetList.children('li');
    targetToShow.fadeIn(100);
    if (! $targetAttribute.hasClass('song-list')){
    targetList.find('li:last').addClass('hide-more').removeClass('show-more');
    }
    $targetAttribute.addClass(plusMinus.minus).removeClass(plusMinus.plus);
  },
  toHidePartially: function($targetAttribute){
    var targetList = $targetAttribute.closest('div').siblings('ul');
    var targetElement = targetList.children('li');
    if($targetAttribute.hasClass('song-list')){
      var targetToHide = targetElement.filter(':gt(1)');
    } else {
      var targetToHide = targetElement.filter(':gt(5)');
    }
    targetToHide.fadeOut(100);
    if (! $targetAttribute.hasClass('song-list')){
      targetList.find('li:last').addClass('show-more').removeClass('hide-more');
    }
    $targetAttribute.addClass(plusMinus.plus).removeClass(plusMinus.minus);
  }
}
