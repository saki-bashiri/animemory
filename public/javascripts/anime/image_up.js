$(function(){
  $("#image-progress").hide();
  var url = $('#upload').attr("data-url");
  var myDropzone = new Dropzone("#upload", {
    url: url,
    method: 'post',
    parallelUploads: 20,
    maxThumbnailFilesize: 1,
    maxFilesize: 1,
    accept: function(file, done){
      $("#image-progress").text("アップロード中です");
      $("#image-progress").show();
      done();
    },
    clickable: true
    //thumbnailWidth: 100,
    //thumbnailHeight: 100
  });
  myDropzone.options.previewTemplate  = '<div class="preview file-preview" style="float:left;">' +
    '  <div class="details"></div>' +
    ' <div class="filename" style="display:none;"><span></span></div>' +
    ' <div class="progress"><span class="load"></span><span class="upload"></span></div>' +
    '  <div class="success-message"><span></span></span></div>' +
    '  <div class="error-message"><span></span></div>' +
    '  <div class="color"></div>' +
    '</div>';

  myDropzone.on("success", function(file, data, xhr){
    $("#image-progress").text(data.message);
  });

  //dragover時の挙動
  myDropzone.on("dragover",function(){
  });
});
