// $button から Channelオブジェクトを生成し、オブジェクトにON・OFF状態をもつ
// .my-channel-wrap 内に .my-channel-button, .my-channel-balloon をもつ想定
var MyChannel = {
  Channel : function($button){
    this.creatorId = $button.attr("data-creatorid");
    this.switch = $button.attr("data-switch");
    this.$buttons = [];
    this.$balloons = [];
  },
  channelsByCreatorId : {},
  buttonText : {on : "", off : ""},
  buttonClass : {on : "on", off : "off"},
  buttonClasses : ["on", "off"],
  balloonText : {on : "Myチャンネル解除", off : "Myチャンネル登録", nologin : "ログインして登録"},
  nextSwitch : {on : "off", off : "on"},
  build : function($channelWrap, $parents){
    if (typeof $channelWrap === "undefined"){ $channelWrap = $(".my-channel-wrap"); }
    var userLogin = $("#user-data").data("login");

    $channelWrap.each(function(){
      var $wrap = $(this);
      var $button = $wrap.find(".my-channel-button");
      var $balloon = $wrap.find(".my-channel-balloon");
      var channel = MyChannel.channelsByCreatorId[$button.attr("data-creatorid")];
      if ( typeof channel === "undefined" ){
        channel = new MyChannel.Channel($button);
        MyChannel.channelsByCreatorId[channel.creatorId] = channel;
      }
      channel.$buttons.push($button);
      channel.$balloons.push($balloon);
      channel.reflesh({login : userLogin});
    });

    MyChannel.setEvent($parents);
  },
  setEvent : function($parents){
    $parents.off("click.channelUpdate").off("mouseover.showBalloon").off("mouseleave.hideBalloon");

    $parents.on("click.channelUpdate", ".my-channel-button", function(e){
      e.preventDefault();
      // MyChannelオブジェクト取得
      var channel = MyChannel.channelsByCreatorId[$(this).attr("data-creatorid")];
      if ( typeof channel === "undefined" ){ return false; }
      channel.update();
    });

    $parents.on("mouseover.showBalloon", ".my-channel-button", function(){
      $(this).parent(".my-channel-wrap").find(".my-channel-balloon").show();
    });

    $parents.on("mouseleave.hideBalloon", ".my-channel-button", function(){
      $(this).parent(".my-channel-wrap").find(".my-channel-balloon").hide();
    });
  }
};

MyChannel.Channel.prototype = {
  update : function(){
    this.reflesh({switch : "next"});
    if ( typeof MyChannel.postUrl === "undefined" ) { MyChannel.postUrl = $("#user-data").attr("data-mychannel-url"); }
    $.ajax({
      type : "POST",
      url : MyChannel.postUrl,
      data : {creatorid : this.creatorId, switch : this.switch}
    }).done(function(data){
      if ( typeof data.url === "string" ){
        window.location.href = data.url;
      }
    });
  },
  reflesh : function(option){
    var switch_type = this.switch;
    if ( option.switch === "next" ){
      switch_type = this.nextSwitch();
    }
    var switchClassName = MyChannel.buttonClass[switch_type];
    var buttonText = MyChannel.buttonText[switch_type];
    var balloonText = MyChannel.balloonText[switch_type];
    if ( option.login === false ){ balloonText = MyChannel.balloonText["nologin"]; }

    $.each( this.$buttons, function(){
      var $button = this;
      $button.attr("data-switch", switch_type);
      $button.removeClass(MyChannel.buttonClasses.join(" ")).addClass(switchClassName).text(buttonText);
    });

    $.each( this.$balloons, function(){
      $(this).text(balloonText);
    });
    this.switch = switch_type;
  },
  nextSwitch : function(){
    return MyChannel.nextSwitch[this.switch];
  }
};
