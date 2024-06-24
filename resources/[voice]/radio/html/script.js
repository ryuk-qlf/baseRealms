let resourceName = 'radio'

$(function(){
    let radioOpen = false
    window.addEventListener('message', (event) => {
        if (event.data.type == 'showradio'){
            radioOpen = !radioOpen
            if (event.data.toggle === true) {
                $('.radioUI').show()
            } else {
                $('.radioUI').hide()
            }
        } else if (event.data.type === 'setFrequence'){
            $('.radioState').html(event.data.data)
        } else if (event.data.type === 'showIconsRadioOn') {
            $('#radioHZ').show()
            $('#radioNetwork').show()
        } else if (event.data.type === 'showMuteIcon'){
            if (event.data.toggle) {
                $('#radioMute').show()
                $('#radioRec').hide()
            } else {
                $('#radioRec').show()
                $('#radioMute').hide()
            }
        }
    });

    window.addEventListener('keydown', (e) => {
        if (e.keyCode == 80) {
            $.post('https://radio/closeRadio')
        }
    })

});

$('#radioManual').click(() => {
    $.post(`https://${resourceName}/requestFreq`)
})

$('#radioButtonMute').click(() => {
    $.post(`https://${resourceName}/muteRadio`)
})

$("#radioToggle").click(() => {
    $('.radioState').html('')
    $('#radioRec').hide()
    $('#radioMute').hide()
    $('#radioHZ').hide()
    $('#radioNetwork').hide()
    $.post(`https://${resourceName}/offRadio`)
})

$('#radioUP').click(() => {
    $.post(`https://${resourceName}/volumeUp`)
})

$('#radioDown').click(() => {
    $.post(`https://${resourceName}/volumeDown`)
})

window.addEventListener('message', function(e) {
    $("#container").stop(false, true);
    if (e.data.type == 'IconRadio'){
        if (e.data.toggle === true) {
            $("#container").css('display', 'none');
        } else {
            $("#container").css('display', 'flex');
        }
    }
});