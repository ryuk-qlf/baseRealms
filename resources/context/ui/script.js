$(document).ready(function() {
    var documentWidth = document.documentElement.clientWidth;
    var documentHeight = document.documentElement.clientHeight;
    var cursor = $('#cursorPointer');
    var cursorX = documentWidth / 2;
    var cursorY = documentHeight / 2;
    var idEnt = 0;

    function UpdateCursorPos() {
        $('#cursorPointer').css('left', cursorX);
        $('#cursorPointer').css('top', cursorY);
    }

    function triggerClick(x, y) {
        var element = $(document.elementFromPoint(x, y));
        element.focus().click();
        return true;
    }

    window.addEventListener('message', function(event) {
        // Crosshair

        if (event.data.crosshair == true) {
            $(".crosshair").addClass('fadeIn');
        }
        if (event.data.crosshair == false) {
            $(".crosshair").removeClass('fadeIn');
        }

        // Menu

        if (event.data.action == 'setItems') {
            $(".menu-cartes").html("");
            $.each(event.data.itemList, function(index, item) {
                $(".menu-cartes").append('<li><a id="card-'+ index +'"class="card"><span class="emoji"><i class="fas fa-credit-card"></i></span><span class="text">Compte '+ item.account +'</span></a></li>');
                $('.card-' + index).data('cardData', item);
            });
        }

        if (event.data.menu == 'vehicule') {
            $(".crosshair").addClass('active');
            $(".menu-vehicule").addClass('fadeIn');
            idEnt = event.data.idEntity;
        }
        if (event.data.menu == 'joueur') {
            $(".crosshair").addClass('active');
            $(".menu-joueur").addClass('fadeIn');
            idEnt = event.data.idEntity;
        }
        if (event.data.menu == 'infoply') {
            $(".crosshair").addClass('active');
            $(".menu-infoply").addClass('fadeIn');
            idEnt = event.data.idEntity;
        }
        if (event.data.menu == 'bmx') {
            $(".crosshair").addClass('active');
            $(".menu-bmx").addClass('fadeIn');
            idEnt = event.data.idEntity;
        }
        if (event.data.menu == 'paiement') {
            $(".crosshair").addClass('active');
            $(".menu-paiement").addClass('fadeIn');
            idEnt = event.data.idEntity;
        }
        if (event.data.menu == 'cartes') {
            $(".crosshair").addClass('active');
            $(".menu-cartes").addClass('fadeIn');
            idEnt = event.data.idEntity;
        }
        if ((event.data.menu == false)) {
            $(".crosshair").removeClass('active');
            $(".menu").removeClass('fadeIn');
            idEnt = 0;
        }

        if (event.data.type == "click") {
            triggerClick(cursorX - 1, cursorY - 1);
        }
    });

    $(document).mousemove(function(event) {
        cursorX = event.pageX;
        cursorY = event.pageY;
        UpdateCursorPos();
    });

    // Début Buttons
    // Début Buttons
    // Début Buttons

    $('.openCoffre').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/openCoffre', JSON.stringify({
            id: idEnt
        }));
        $(this).find('.text').text($(this).find('.text').text() == 'Ouvrir le coffre' ? 'Fermer le coffre' : 'Ouvrir le coffre');
    });
    

    $('.Cartes').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/Cartes', JSON.stringify({
            id: idEnt
        }));
    });

    $('.card').on('click', function(e) {
        e.preventDefault();
        cardData = $(this).data("card");
        console.log(cardData)
        $.post('http://context/UseCard', JSON.stringify({
            card: cardData
        }));
    });


    $('.openCapot').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/openCapot', JSON.stringify({
            id: idEnt
        }));
        $(this).find('.text').text($(this).find('.text').text() == 'Ouvrir le capot' ? 'Fermer le capot' : 'Ouvrir le capot');
    });

    $('.ReportPlayer').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/ReportPlayer', JSON.stringify({
            idply: idEnt
        }));
    });

    $('.IdPlayer').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/IdPlayer', JSON.stringify({
            idply: idEnt
        }));
    });

    $('.UseKey').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/UseKey', JSON.stringify({
            id: idEnt
        }));
    });

    $('.EtatVehicle').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/EtatVehicle', JSON.stringify({
            id: idEnt
        }));
    });

    $('.TrainerJoueur').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/TrainerJoueur', JSON.stringify({
            id: idEnt
        }));
    });

    $('.MettreDansVeh').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/MettreDansVeh', JSON.stringify({
            id: idEnt
        }));
    });

    $('.SortirDuVeh').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/SortirDuVeh', JSON.stringify({
            id: idEnt
        }));
    });

    $('.FouillerJoueur').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/FouillerJoueur', JSON.stringify({
            id: idEnt
        }));
    });

    $('.RamasserBmx').on('click', function(e) {
        e.preventDefault();
        $.post('http://context/RamasserBmx', JSON.stringify({
            id: idEnt
        }));
    });

    // Fin Buttons
    // Fin Buttons
    // Fin Buttons

    $('.crosshair').on('click', function(e) {
        e.preventDefault();
        $(".crosshair").removeClass('fadeIn').removeClass('active');
        $(".menu").removeClass('fadeIn');
        $.post('http://context/disablenuifocus', JSON.stringify({
            nuifocus: false
        }));
    });
    $(document).keypress(function(e) {
        if (e.which == 101) { // if "E" is pressed
            $(".crosshair").removeClass('fadeIn').removeClass('active');
            $(".menu").removeClass('fadeIn');
            $.post('http://context/disablenuifocus', JSON.stringify({
                nuifocus: false
            }));
        }
    });

});