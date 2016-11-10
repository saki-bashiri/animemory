var Mymemory = {
  // 初期動作
  init : function($buttons, $watches, $favorites, $watchBalloons, $favoriteBalloons, $watchNoLogin, $favoriteNoLogin){
    Mymemory.setConst($buttons, $watches, $favorites, $watchBalloons, $favoriteBalloons);
    if ( Mymemory.$data.attr("data-user-login") !== "true" ) {
      Mymemory.setNoLoginEvents($watchNoLogin, $favoriteNoLogin);
      return false;
    }

    $buttons.each(function(){
      var $this = $(this);
      var $watch = $this.find(Mymemory.watchSelector);
      var $favorite = $this.find(Mymemory.favoriteSelector);
      var aid = parseInt($this.attr("data-aid"), 10);
      var memory = Mymemory.aidMemory[aid];
      if ( typeof memory === "undefined" ) { memory = new Mymemory.memory($this, $watch, $favorite); }
      memory.$boxes.push($this);
      memory.$favorites.push($favorite);
      memory.$watches.push($watch);
      Mymemory.aidMemory[aid] = memory;
    });
    Mymemory.setEvents($watches, $favorites);
  },
  // { aid => [memory, memory, ...] } の連想配列
  aidMemory : {},
  // aid ごとの状態管理
  memory : function($box, $watch, $favorite){
    this.aid = parseInt( $box.attr("data-aid") , 10);
    this.currentFavorite = $favorite.attr("data-favorite");
    this.currentWatch = $watch.attr("data-watch");
    // 画面上にあるボタン群
    this.$watches = [];
    this.$favorites = [];
    this.$boxes = [];
  },
  setConst : function($buttons, $watches, $favorites, $watchBalloons, $favoriteBalloons){
    $watchBalloons.hide();
    $favoriteBalloons.hide();
    Mymemory.boxSelector = $buttons.selector;
    Mymemory.watchSelector = $watches.selector;
    Mymemory.favoriteSelector = $favorites.selector;
    Mymemory.watchBalloonSelector = $watchBalloons.selector;
    Mymemory.favoriteBallonSelector = $favoriteBalloons.selector;
    Mymemory.$data = $("#mymemory-data");
  },
  boxSelector : "",
  watchSelector : "",
  favoriteSelector : "",
  watchBalloonSelector : "",
  favoriteBallonSelector : "",
  $data : undefined,
  // イベントはここでセット
  setEvents : function($watches, $favorites){
    // ボタンクリック時の挙動
    $(document).on("click", $watches.selector, function(){
      var memory = Mymemory.aidMemory[ parseInt($(this).attr("data-aid"), 10) ];
      if (typeof memory === "undefined") { return false; }

      Mymemory.changeWatchStatus(memory); // 通信前にステータス変えてしまう
      Mymemory.ajaxWatchPost(memory);
      return false;
    });

    $(document).on("click", $favorites.selector, function(){
      var memory = Mymemory.aidMemory[ parseInt($(this).attr("data-aid"), 10) ];
      if (typeof memory === "undefined") { return false; }

      Mymemory.changeFavoriteStatus(memory); // 通信前にステータス変えてしまう
      Mymemory.ajaxFavoritePost(memory);
      return false;
    });

    $(document).on("mouseenter", $watches.selector, function(){
      $(this).parent(Mymemory.boxSelector).find(Mymemory.watchBalloonSelector).stop().fadeIn(100);
    });

    $(document).on("mouseleave", $watches.selector, function(){
      $(this).parent(Mymemory.boxSelector).find(Mymemory.watchBalloonSelector).stop().fadeOut(100);
    });

    $(document).on("mouseenter", $favorites.selector, function(){
      $(this).parent(Mymemory.boxSelector).find(Mymemory.favoriteBallonSelector).stop().fadeIn(100);
    });

    $(document).on("mouseleave", $favorites.selector, function(){
      $(this).parent(Mymemory.boxSelector).find(Mymemory.favoriteBallonSelector).stop().fadeOut(100);
    });
  },
  setNoLoginEvents : function($watchNoLogin, $favoriteNoLogin){
    $(document).on("mouseenter", $watchNoLogin.selector, function(){
      console.log($(this));
      $(this).parent(Mymemory.boxSelector).find(Mymemory.watchBalloonSelector).stop().fadeIn(100);
    });
    $(document).on("mouseleave", $watchNoLogin.selector, function(){
      $(this).parent(Mymemory.boxSelector).find(Mymemory.watchBalloonSelector).stop().fadeOut(100);
    });
    $(document).on("mouseenter", $favoriteNoLogin.selector, function(){
      $(this).parent(Mymemory.boxSelector).find(Mymemory.watchBalloonSelector).stop().fadeIn(100);
    });
    $(document).on("mouseleave", $favoriteNoLogin.selector, function(){
      $(this).parent(Mymemory.boxSelector).find(Mymemory.watchBalloonSelector).stop().fadeOut(100);
    });
  },
  // memoryのステータスを変える
  changeWatchStatus : function(memory){
    var nextWatchName = memory.nextWatchName();
    var watchBalloonName = memory.watchBalloonName();
    memory.currentWatch = memory.nextWatch();
    var watchKeys = JSON.parse(Mymemory.$data.attr("data-watch-keys"));

    $.each(memory.$watches, function(){ // ボタンの状態も同期
      this.removeClass( watchKeys.join(" ") ).addClass(memory.currentWatch).attr("data-watch", memory.currentWatch).text(nextWatchName);
      this.parent(Mymemory.boxSelector).find(Mymemory.watchBalloonSelector).text( watchBalloonName );
    });
  },
  changeFavoriteStatus : function(memory){
    memory.currentFavorite = memory.nextFavorite();
    var favoriteKeys = JSON.parse(Mymemory.$data.attr("data-favorite-keys"));

    $.each(memory.$favorites, function(){ // ボタンの状態も同期
      this.removeClass( favoriteKeys.join(" ") ).addClass(memory.currentFavorite).attr("data-favorite", memory.currentFavorite);
      this.parent(Mymemory.boxSelector).find(Mymemory.favoriteBallonSelector).text(memory.nextFavoriteName());
    });
  },
  // ajax通信
  ajaxWatchPost : function(memory){
    $.ajax({ url : Mymemory.$data.attr("data-watch-url"),
      type : "POST", data : {aid : memory.aid, watch : memory.currentWatch} });
  },
  ajaxFavoritePost : function(memory){
    $.ajax({ url : Mymemory.$data.attr("data-favorite-url"),
      type : "POST", data : {aid : memory.aid, favorite : memory.currentFavorite} });
  }
};
// memoryにメソッド定義
Mymemory.memory.prototype = {
  nextWatch :  function(){
    return JSON.parse(Mymemory.$data.attr("data-next-watch"))[ this.currentWatch ];
  },
  nextWatchName : function(){
    return JSON.parse(Mymemory.$data.attr("data-watch-name"))[ this.nextWatch() ];
  },
  nextFavorite : function(){
    return JSON.parse(Mymemory.$data.attr("data-next-favorite"))[ this.currentFavorite ];
  },
  nextFavoriteName : function(){
    return JSON.parse(Mymemory.$data.attr("data-favorite-name"))[ this.nextFavorite() ];
  },
  watchBalloonName : function(){
    return JSON.parse(Mymemory.$data.attr("data-watch-balloon-name"))[ this.nextWatch() ];
  }
}
