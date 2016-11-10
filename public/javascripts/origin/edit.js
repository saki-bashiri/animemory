$(function(){
  $("#select-animes").sortable({
    connectWith: ["#source-animes"]
  });
  $("#source-animes").sortable({
    connectWith: ["#select-animes"]
  });
});