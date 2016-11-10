$(function(){
  $(document).on("click", "#more-load", function(){
    var $this = $(this);
    $.ajax({
      url : $this.attr("data-url"),
      type: "POST",
      data : { offset : $this.attr("data-offset") }
    }).done(function(data){
      $this.after(data);
      $this.remove();
    });
    return false;
  });
})