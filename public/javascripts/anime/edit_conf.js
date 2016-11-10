$(function(){
  $("#commit").on("click", function(){
    if ( !confirm("編集します。よろしいですか？") ) { return false; }
  });
});