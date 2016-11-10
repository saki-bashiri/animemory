$(function(){
  $("#commit").on("click", function(){
    var name = $("#nickname").val();
    if (name.length === 0){
      alert("ニックネームが空です");
    } else if ( name.length > 20 ){
      alert("ニックネームは20文字以内でお願いします");
      return false;
    } else {
      if (!confirm("ニックネームを登録します")){
        return false;
      }
    }
  })
});