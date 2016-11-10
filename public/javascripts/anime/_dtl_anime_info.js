$(function(){
  if( typeof MyChannel !== "undefined" ) {
    MyChannel.build(undefined, $(document));
  }
	var characters = $('.cast-list');
	var songs = $('.song-list');
	var staffs = $('.staff-list');
	var plusMinusButton = $('.dtl-info-plus-minus');
  plusMinus.initialize(characters, songs, staffs);
  plusMinusButton.on('click', function(e){
    e.preventDefault();
    $this = $(this);
    if ($this.hasClass(plusMinus.plus)){
      plusMinus.toShowEntirely($this);
    }else if ($this.hasClass(plusMinus.minus)){
      plusMinus.toHidePartially($this);
    }
  });
});
