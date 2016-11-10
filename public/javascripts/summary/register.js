var Wiki = {
  insert_color: function(color){
    Wiki.insert("color", color);
  },
  insert_size: function(size){
    if (parseInt(size) > 100 || parseInt(size) < 0){ return false }
    Wiki.insert("size", size);
  },
  insert: function(tag, data){
    var selecting = $(".selected").selection();
    var tagText = "[" + tag + ":" + data + " " + selecting + "]"
    $(".selected").selection('insert', {text: '[' + tag + ':' + data + ' ', mode: 'before'})
      .selection('insert', {text: ']', mode: 'after'});
  }
};

$(function(){
  $("#source").sortable({
    cursor: "move",
    opacity: 0.7,
    connectWith: ["#summary, #image-source"],
    receive: function(event, ui){
      var $content = $(ui.item).find(".content");
      var text = $content.text().replace(/(\r|\n|\r\n)/g, "<br>");
      var div = $("<div>").addClass("content").html(text);
      $("#source li.image_source .am-summary-main-img").remove();
      $content.after(div);
      $content.remove();
    }
  });
  $("#image-source").sortable({
    cursor: "move",
    opacity: 0.7,
    connectWith: ["#summary, #image-source, #source"],
    receive: function(event, ui){
      var $content = $(ui.item).find(".content");
      var text = $content.text().replace(/(\r|\n|\r\n)/g, "<br>");
      var div = $("<div>").addClass("content").html(text);
      $("#image-source li.image_source .am-summary-main-img").remove();
      $content.after(div);
      $content.remove();
    }
  });
  $("#summary").sortable({
    connectWith: ["#source, #image-source"],
    cursor: "move",
    opacity: 0.7,
    receive: function(event, ui){
      var $content = $(ui.item).find(".content");
      if (!$content){
        return false;
      }else{
        $(".am-white-space").remove();
        if ( ($("#summary li.image_source").size() !== 0) && ($("#summary li:first-child").hasClass('image_source')) ){
          $("#summary li.image_source:not(first-child)").find(".am-summary-main-img").remove();
          $("#summary li.image_source:first-child").append('<span class="am-summary-main-img">メイン</span>');
        }else{
          $("#summary li.image_source:not(first-child) .am-summary-main-img").remove();
        }
      }
      var text = $content.html().replace(/<br>/g, "\n");
      var textArea = $("<textarea>").attr("name", "summary[][content]").addClass("content wiki-text").html(text);

      var newLine = text.split("\n").length;
      var textsOfEachLine = text.split("\n");
      lineWithTextsMoreThan38 = 0;
      $.each(textsOfEachLine, function(index, element){ 
        if (element.length > 40){
         lineWithTextsMoreThan38 += 1;
        }
      });
      if ((newLine + lineWithTextsMoreThan38) < 6){
        textArea.attr({rows: newLine + lineWithTextsMoreThan38});
      }else{
        textArea.attr({rows: 6});
      }

      var imageInput = $("<input>").attr("type", "hidden").attr("name", "summary[][image_ids][]").val("");
      $content.after(imageInput).after(textArea);
      $content.remove();
    },
    stop: function(){
      var summaryEle = $("#summary li");
      if (summaryEle.size() === 0) {
        $("#summary").append('<li class="am-white-space">ここにドラッグ＆ドロップしてね</li>');
      }else{
        if ( ($("#summary li.image_source").size() !== 0) && ($("#summary li:first-child").hasClass('image_source')) ){
          $("#summary li.image_source:not(first-child)").find(".am-summary-main-img").remove();
          $("#summary li.image_source:first-child").append('<span class="am-summary-main-img">メイン</span>');
        }else{
          $("#summary li.image_source:not(first-child)").find(".am-summary-main-img").remove();
        }
      }
      if ($("#source li.am-white-space,#image-source li.am-white-space").size() > 0){
        $("#source li.am-white-space,#image-source li.am-white-space").remove();
      }
    }
  });

  if ( ($("#summary li.image_source").size() !== 0) && ($("#summary li:first-child").hasClass('image_source')) ){
    $("#summary li.image_source:not(first-child)").find(".am-summary-main-img").remove();
    $("#summary li.image_source:first-child").append('<span class="am-summary-main-img">メイン</span>');
  }else{
    $("#summary li.image_source:not(first-child)").find(".am-summary-main-img").remove();
  }
  if ($("#summary li").size() === 0){
    $("#summary").append('<li class="am-white-space">ここにドラッグ＆ドロップしてね</li>');
  }

  var windowWidth = $(window).width();
  var mainEleWidth = $(".am-summary-instruction-contents").width()
  var sideSpaceWidth = (windowWidth - mainEleWidth) / 2 ;
  var toolBoxPosition = sideSpaceWidth + mainEleWidth + 10 + "px" ;
  $(".am-wiki-buttons-wrap, .am-wiki-buttons-wrap-below").css("left", toolBoxPosition);

  // 確認画面へ
  $("#conf").on("click", function(){
    if ($("#title").val().length === 0){
      alert("タイトルを入力してください");
      return false;
    }
    if ( $("#summary .content").size() === 0 ){
      alert("まとめを作ってください。");
      return false;
    }
  });

  $("#right").on("focus", ".wiki-text", function(){
    $(".wiki-text").removeClass("selected");
    $(this).addClass("selected");
  });

  // color button クリックされた時
  $(".wiki-buttons").on("click", ".color-button", function(){
    var color = $(this).attr("data-color");
    Wiki.insert_color(color);
    return false;
  });
  // size button クリックされた時
  $(".wiki-buttons").on("click", ".size-button", function(){
    var size = $(this).parents(".wiki-buttons").find(".wiki-size").val();
    if (typeof size !== 'undefined'){ Wiki.insert_size(size); }
    return false;
  });

  var offset = $("#right").offset();
  $(window).scroll(function(){
    if ($(window).scrollTop() > offset.top) {
      $("#right").stop().css({
        marginTop: $(window).scrollTop() - offset.top
      });
    } else {
      $("#right").stop().css({
        marginTop: 0
      });
    }
  });

  var windowHeight = $(window).height() - 90 + 'px';
  $('.am-drag-and-drop').css({'height':windowHeight, 'max-height': windowHeight});

  // how_to を出す
  $('#am-howto-link').on('click', function(){
      winOpen(this.href, 400, 407);
      return false;
  });

  // 画像を更新
  $("#image-refresh").on("click", function(){
    $.ajax({
       url : $(this).attr("data-url"),
       data : {aid : $(this).attr("data-aid")},
       type : "GET",
    }).done(function(data){
      $("#image-source").empty().append(data);
    });
    return false;
  });
});
function winOpen(url, width, height) {
  window.open(url, '_blank', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, width=' + width + ', height=' + height);
}

