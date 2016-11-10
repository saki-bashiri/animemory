var EpisodeMemory = {
  // 初期動作
  init : function($buttons){
    $buttons.each(function(){
      var $this = $(this);
      var epid = $this.attr("data-epid");
      var memory = EpisodeMemory.epidMemory[epid];
      if ( typeof memory !== "undefined" ) {
        memory.$buttons.push($this);
      } else {
        memory = new EpisodeMemory.memory($this);
      }
      EpisodeMemory.epidMemory[epid] = memory;
    });
    EpisodeMemory.setEvents($buttons);
  },
  // epid: memories の連想配列
  epidMemory : {},
  // epid ごとの状態管理
  memory : function($button){
    this.epid = parseInt( $button.attr("data-epid") , 10);
    this.currentWatch = $button.attr("data-watch");
    // 画面上にあるボタン群
    this.$buttons = this.$buttons || [ $button ];
  },
  // イベントはここでセット
  setEvents : function($buttons){
    // ボタンクリック時の挙動
    $(document).on("click", $buttons.selector, function(){
      var memory = EpisodeMemory.epidMemory[ parseInt($(this).attr("data-epid"), 10) ];
      if (typeof memory === "undefined") { return false; }

      EpisodeMemory.changeStatus(memory); // 通信前にステータス変えてしまう
      EpisodeMemory.ajaxPost(memory);
    });

    $(document).on("mouseover", $buttons.selector, function(){
      $(this).parent(".episode-memory-box").find(".episode-memory-balloon").stop().fadeIn(100);
    });

    $(document).on("mouseleave", $buttons.selector, function(){
      var memory = EpisodeMemory.epidMemory[ parseInt($(this).attr("data-epid"), 10) ];
      if (typeof memory === "undefined") { return false; }
      $(this).parent(".episode-memory-box").find(".episode-memory-balloon").stop().fadeOut(100);
    });
  },
  // memoryのステータスを変える
  changeStatus : function(memory){
    var nextWatchName = memory.nextWatchName();
    var watchBalloonName = memory.watchBalloonName();
    memory.currentWatch = memory.nextWatch();
    var watchKeys = JSON.parse($("#episode-memory-data").attr("data-watch-keys"));
    // ボタンの状態も同期
    $.each(memory.$buttons, function(){
      this.removeClass( watchKeys.join(" ") ).addClass(memory.currentWatch).attr("data-watch", memory.currentWatch).text(nextWatchName);
      this.parent(".episode-memory-box").find(".episode-memory-balloon").text( watchBalloonName );
    });
  },
  // ajax通信
  ajaxPost : function(memory){
    $.ajax({
      url : $("#episode-memory-data").attr("data-url"),
      type : "POST",
      data : {epid : memory.epid, watch : memory.currentWatch}
    });
  }
};
// memoryにメソッド定義
EpisodeMemory.memory.prototype = {
  nextWatch :  function(){
    var nextWatch = JSON.parse($("#episode-memory-data").attr("data-next-watch"));
    return nextWatch[this.currentWatch ];
  },
  nextWatchName : function(){
    var watchName = JSON.parse($("#episode-memory-data").attr("data-watch-name"));
    return watchName[ this.nextWatch() ];
  },
  watchBalloonName : function(){
    var watchBalloonName = JSON.parse($("#episode-memory-data").attr("data-watch-balloon"));
    return watchBalloonName[this.nextWatch() ];
  }
}
$(function(){
  $(document).on("click", ".nologin-episode-watch", function(){
    window.location.href = $(this).attr("data-url");
    return false ;
  });
});
