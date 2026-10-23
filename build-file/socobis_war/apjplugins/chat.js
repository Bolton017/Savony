var $messages = $('.messages-content'),
    d, h, m;

let nomTable;
let dateDebutRep;
let dateFinRep;
let valiny
let galloisReponse;
let type;
let prompt;
let query;
let cols;
const baseUrl = window.location.origin;
let iaResp;
let jsonResp;
let datyFiltre;
let deb;
let fin;
let donneesSaisie;
let grouper;
let file;
let id;
let isError = false;
$(window).load(function() {
    $messages.mCustomScrollbar();
    firstMessage();
});

function updateScrollbar() {
    $messages.mCustomScrollbar("update").mCustomScrollbar('scrollTo', 'bottom', {
        scrollInertia: 10,
        timeout: 0
    });
}

function setDate(){
    d = new Date()
    if (m != d.getMinutes()) {
        m = d.getMinutes();
        $('<div class="timestamp">' + d.getHours() + ':' + m + '</div>').appendTo($('.message:last'));
    }
}

async function transcriptionMessage(demande){
    const formData = new FormData();
    formData.append("message", demande);
    if (file) {
        formData.append("file", file);
    }
    return $.ajax({
        url: baseUrl+"/savonnerie/query-generator",
        type: "POST",
        data: formData,
        processData: false,
        contentType: false,
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        success: function(jsonResponse) {
            if(jsonResponse.value && jsonResponse.value !== "" && jsonResponse.value =="error")
            {
                isError = true;
                valiny = jsonResponse.url;
            }
            else if(jsonResponse.value && jsonResponse.value !== "" && jsonResponse.value =="ocr")
            {
                console.log("heooooo");
                window.location.href = baseUrl+jsonResponse.url;
                console.log("tao tsy lasa");
            }
            else{
                console.log("ty no valiny " + jsonResponse);
                console.log("Response: ", JSON.stringify(jsonResponse, null, 2));
                console.log(jsonResponse.type)
                nomTable = jsonResponse.nomTable;
                dateDebutRep = jsonResponse.date1;
                dateFinRep = jsonResponse.date2;
                type = jsonResponse.type;
                query = jsonResponse.requeteSql;
                jsonResp = jsonResponse.responseJson;
                iaResp = jsonResponse.iaResp;
                datyFiltre = jsonResponse.datyFiltre;
                deb = jsonResponse.deb;
                fin = jsonResponse.fin;
                grouper = jsonResponse.grouper;
                prompt = demande;
                donneesSaisie = jsonResponse.donnees;
                id = jsonResponse.id;
                console.log("ok mety "+prompt);
            }
        },
        error: function(xhr, status, error) {
            valiny = "Une erreur s'est produite, veuillez réessayer";
            console.error("An error occurred: " + error);
        },
    });
}

async function responseHandler(){
    return $.ajax({
        url: baseUrl+"/savonnerie/response-generator",
        type: "POST",
        dataType: 'json',
        data : {
            nomTable: nomTable,
            dateDebut: dateDebutRep,
            dateFin: dateFinRep,
            type: type,
            requeteSql: query,
            prompt: prompt,
            jsonResp : jsonResp,
            iaResp : iaResp,
            datyFiltre : datyFiltre,
            deb : deb,
            fin : fin,
            grouper :grouper,
            dataSaisie : JSON.stringify(donneesSaisie, null, 2),
            baseUrl : baseUrl,
            id:id,

        },
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        success: function(response) {

            if(response.value && response.value !== "" && response.value =="error")
            {
                isError = true;
                valiny = response.url;
            }
            else {
                console.log("sur? "+ response);
                valiny = response;
                console.log("huhuhu");
                console.log(valiny.value);
                if(valiny.value == "action"){
                    window.location.href = baseUrl+valiny.url;
                }
            }
        },
        error: function(xhr, status, error) {
            valiny = "Une erreur s'est produite, veuillez réessayer";
            console.error("An error occurred: " + error);
        },
    });
}

async function resendMessage(){
    return $.ajax({
        url: baseUrl+"/savonnerie/response-formattor",
        type: "GET",
        data: {message:valiny.value,prompty:prompt},
        xhrFields: {
            withCredentials: true
        },
        crossDomain: true,
        success: function(response) {
            console.log("bello " + response.response);
            galloisReponse = response.response;
        },
        error: function(xhr, status, error) {
            valiny = "Une erreur s'est produite, veuillez réesayer";
            console.error("An error occurred: " + error);
        },
    });
}

async function processMessage(msg) {
    try {
        isError = false;
        $('.message-input').val(null);
        const transcr = await transcriptionMessage(msg);
        if(!isError && file==null){
            const respHandl = await responseHandler();
        }
        updateScrollbar();
        //const reponse = await resendMessage();
    } catch (e){
        console.log(e)
    }
}

async function insertMessage() {
    file = $('#fileInput')[0].files[0];
    msg = $('.message-input').val();
    if ($.trim(msg) == '') {
        return false;
    }
    $('<div class="message message-personal">' + msg + '</div>').appendTo($('.mCSB_container')).addClass('new');
    setDate();
    await processMessage(msg);
    realMessage();
}

$('.message-submit').click(function() {
    insertMessage();
    updateScrollbar();
});

$(window).on('keydown', function(e) {
    if (e.which == 13) {
        insertMessage();
        updateScrollbar();
        return false;
    }
})

function firstMessage(){
    $('.message.loading').remove();
    $('<div class="message new"><figure class="avatar"><img src="/savonnerie/assets/img/logo_A.png" /></figure>' + "Bienvenue sur Async, je suis votre assistant virtuel, comment puis-je vous aider" + '</div>').appendTo($('.mCSB_container')).addClass('new');
    setDate();
    updateScrollbar();
}

function realMessage() {
    if ($('.message-input').val() != '') {
        return false;
    }
    $('<div class="message loadingChat new"><figure class="avatar"><img src="/savonnerie/assets/img/logo_A.png" /></figure><span></span></div>').appendTo($('.mCSB_container'));
    updateScrollbar();

    setTimeout(function() {
        $('.message.loadingChat').remove();
        if(valiny.value != null){
            $('<div class="message new"><figure class="avatar"><img src="/savonnerie/assets/img/logo_A.png" /></figure>' + valiny.value + '</div>').appendTo($('.mCSB_container')).addClass('new');
            setDate();
            updateScrollbar();
            const utterance = new SpeechSynthesisUtterance(valiny.value);

            // Optionnel : vous pouvez définir la langue ou la voix ici
            utterance.lang = 'fr-FR';  // Langue française
            utterance.pitch = 1;  // Ajuster la tonalité si nécessaire
            utterance.rate = 1;   // Ajuster la vitesse de la parole si nécessaire

            // Lire le message
            setTimeout(() => {
                window.speechSynthesis.speak(utterance);
            }, 500);
        }
        if (valiny.url && valiny.url !== "")  {
            valiny.url = baseUrl+valiny.url;
            $('<div class="message new"><figure class="avatar"><img src="/savonnerie/assets/img/logo_A.png" /></figure>'+ '<a href="' + valiny.url + '">' +'Voir les détails' + '</a>' + '</div>').appendTo($('.mCSB_container')).addClass('new');
            setDate();
            updateScrollbar();
        }
        else if(valiny.value == null && valiny.url == null) {
            $('<div class="message new"><figure class="avatar"><img src="/savonnerie/assets/img/logo_A.png" /></figure>' + valiny + '</a>' + '</div>').appendTo($('.mCSB_container')).addClass('new');
            setDate();
            updateScrollbar();
        }
        setDate();
        updateScrollbar();
    }, 1000 + (Math.random() * 20) * 100);

}