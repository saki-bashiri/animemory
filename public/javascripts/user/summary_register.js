$(function(){
  $("#source").sortable({
    connectWith: ["#summary"]
  });
  $("#summary").sortable({
    connectWith: ["#source"]
  });
});