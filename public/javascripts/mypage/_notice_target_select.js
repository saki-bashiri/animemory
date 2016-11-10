$(function(){
  var selected = $('.notice-target-select').attr('data-selected');
  var target = '.creator' + selected;
  console.log(target);
  if (! selected == ''){
    var selectAll = $('.notice-target-select ul li');
    selectAll.removeClass('active');
    $(target).addClass('active');
  }
});
