$(function(){
  $('#start_on').datepicker({
    dateFormat: 'yy/mm/dd',
    changeYear: true,
    changeMonth: true
  });
  $('#finish_on').datepicker({
    dateFormat: 'yy/mm/dd',
    changeYear: true,
    changeMonth: true
  });
  $("#conf").on("click", function(){
    var title = $("#title").val();
    var kana = $("#kana").val();
    var animemo = $("#animemo").val();
    var comment = $("#comment").val();
    if (!title) { alert("タイトルが入力されていません。"); return false; }
    if (title.length > 200) { alert("タイトルは200文字以内で入力ください。"); return false; }
    if (!kana) { alert("かなが入力されていません。"); return false; }
    if (kana.length > 200) { alert("かなは200文字以内で入力ください。"); return false; }
    if (animemo && animemo.length > 5000){ alert("アニメモは5000文字以内で入力ください。"); return false; }
    if (!comment){ alert("コメントは必ず入力ください。"); return false; }
    if (comment.length > 200){ alert("コメントは200文字以内で入力ください。"); return false; }
  });
});