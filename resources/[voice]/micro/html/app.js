window.addEventListener('message', function(e) {
    $("#chuchotement").stop(false, true);
    $("#normal").stop(false, true);
    $("#crie").stop(false, true);

    if (e.data.type == 'IconChuchotement' && e.data.toggle == true){
        $("#chuchotement").css('display', 'flex');
    } else {
        $("#chuchotement").css('display', 'none');
      }
      if (e.data.type == 'IconNormal' && e.data.toggle == true){
        $("#normal").css('display', 'flex');
    } else {
        $("#normal").css('display', 'none');
      }
      if (e.data.type == 'IconCrie' && e.data.toggle == true){
        $("#crie").css('display', 'flex');
    } else {
        $("#crie").css('display', 'none');
      }
});