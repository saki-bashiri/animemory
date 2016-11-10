$(function(){
  $("#commit").on("click", function(){
    if ( $("#password").val() === ""){
      alert("パスワードを入力してください。");
      return false;
    }
    return confirm("本当に退会してよろしいですか？");
  });
});