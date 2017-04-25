$(document).ready(function(){
  var arrayArticles = gon.rooms;
  $('.autocomplete').autocomplete({
    lookup: arrayArticles,
    onSelect: function (suggestion) {
      $(this).val(suggestion.data);
    }
  });
});

