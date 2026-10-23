function initAutocomplete(num, champData) {
    let autocompleteTriggered = false;

    const basePrefix = champData.nom.replace(/\d+$/, ''); // Ex: "idProduit_0" → "idProduit_"
    const baseId = `${basePrefix}${num}`;
    const libelleId = `#${baseId}libelle`;
    const hiddenId = `#${baseId}`;
    const searchBtnId = `#${baseId}searchBtn`;
    const separator = ";";

    const nomTable = champData.ac_nomTable;
    const classeMapping = champData.ac_classeMapping;
    const champRetourSep = champData.champRetour || ";";
    const champRetourMapping = (champData.champRetourMapping || "").split(separator).map(id => id.replace(/_\d+/, `_${num}`));

    $(libelleId).autocomplete({
        source: function(request, response) {
            $(hiddenId).val('');
            if (autocompleteTriggered) {
                fetchAutocomplete(
                    request,
                    response,
                    "null",
                    champData.ac_valeur || "id",
                    "null",
                    nomTable,
                    classeMapping,
                    "true",
                    champRetourSep,
                    champData.ac_aWhere || "null"
                );
            }
        },
        select: function(event, ui) {
            $(libelleId).val(ui.item.label);
            $(hiddenId).val(ui.item.value);
            $(hiddenId).trigger('change');
            $(this).autocomplete('disable');

            const valeursRetour = (ui.item.retour || "").split(separator);
            for (let i = 0; i < champRetourMapping.length; i++) {
                const idChamp = `#${champRetourMapping[i]}`;
                const valeur = valeursRetour[i] || '';
                $(idChamp).val(valeur);
            }

            autocompleteTriggered = false;
            return false;
        }
    }).autocomplete('disable');

    $(libelleId).keydown(function(event) {
        if (event.key === 'Tab') {
            event.preventDefault();
            autocompleteTriggered = true;
            $(this).autocomplete('enable').autocomplete('search', $(this).val());
        }
    });

    $(libelleId).on('input', function() {
        $(hiddenId).val('');
        autocompleteTriggered = false;
        $(this).autocomplete('disable');
    });

    $(searchBtnId).click(function() {
        autocompleteTriggered = true;
        $(libelleId).autocomplete('enable').autocomplete('search', $(libelleId).val());
    });
}

function add_line_tab(champ){
    let champData = JSON.parse(champ);
    const champAvecAutocomplete = champData.filter(obj => obj.autocompleteDynamique === true);

    var lastTr = $("#ajout_multiple_ligne tr:last");
    var lastId = lastTr.attr('id');
    var indiceOld = lastId ? parseInt(lastId.split('-')[2]) : 0;
    var indiceNew = indiceOld + 1;

    var firstElement = lastTr.html();

    var newElem = firstElement
        .replace(new RegExp('_' + indiceOld + '\\b', 'g'), '_' + indiceNew)               // _9 → _10
        .replace(new RegExp('\\(' + indiceOld + '\\)', 'g'), '(' + indiceNew + ')')       // (9) → (10)
        .replace(new RegExp('checkbox' + indiceOld + '\\b', 'g'), 'checkbox' + indiceNew) // checkbox9 → checkbox10
        .replace(new RegExp('delete_line\\(' + indiceOld + '\\)', 'g'), 'delete_line(' + indiceNew + ')') // delete_line(9)
        .replace(new RegExp('value="' + indiceOld + '"', 'g'), 'value="' + indiceNew + '"'); // value="9" in checkbox

    newElem = newElem
        .replace(/_\d+/g, '_' + indiceNew)           // tous les "_<n>"
        .replace(/\(\d+\)/g, '(' + indiceNew + ')')  // tous les "(<n>)"
        .replaceAll(indiceNew + "" + indiceNew, indiceNew)
        .replaceAll(indiceNew + "" + indiceNew + "" + indiceNew, indiceNew)
        .replaceAll(indiceNew + "" + indiceNew + "" + indiceNew + "" + indiceNew, indiceNew);

    // ligne vaovao
    $("#ajout_multiple_ligne").append("<tr id='ligne-multiple-" + indiceNew + "'>" + newElem + "</tr>");

    // compteur vaovao
    $("#nombreLigne").val(indiceNew + 1);


    console.log(champAvecAutocomplete);
    const champAuto = champAvecAutocomplete.reduce((acc, champ) => {
        if (!acc.map.has(champ.ac_classeMapping)) {
            acc.map.set(champ.ac_classeMapping, true);
            acc.result.push(champ);
        }
        return acc;
    }, { map: new Map(), result: [] }).result;

    if (Array.isArray(champAuto) && champAuto.length > 0) {
        champAuto.forEach(champ => {
            initAutocomplete(indiceNew, champ);
        });
    }
}

function delete_line(lineId) {
    var taille = $("#ajout_multiple_ligne tr").length;
    if(taille>=2){
        var ligne = document.getElementById('ligne-multiple-' + lineId);
        if(ligne) {
            ligne.remove();
            var newCount = $("#ajout_multiple_ligne tr").length;
            $("#nombreLigne").val(newCount);
        }
    }
}

function add_line_tabs(champ) {
    for (let i = 0; i < 10; i++) {
        add_line_tab(champ);
    }
}