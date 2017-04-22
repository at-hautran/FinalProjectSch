(function($){
  console.log($(".form-group"))
  function floatLabel(inputType){
    alert($(inputType));
    console.log($(".floatLabel"));
    $(inputType).each(function(){
      var $this = $(this);
      alert("a");
      // on focus add cladd active to label
      $this.focus(function(){
        $this.next().addClass("active");
      });
      //on blur check field and remove class if needed
      $this.blur(function(){
        if($this.val() === '' || $this.val() === 'blank'){
          $this.next().removeClass();
        }
      });
    });
  }
  // just add a class of "floatLabel to the input field!"
  floatLabel(".floatLabel");
})(jQuery);