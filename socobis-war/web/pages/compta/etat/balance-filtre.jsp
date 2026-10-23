<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@page import="utilitaire.Utilitaire"%> 
<%@page import="bean.CGenUtil" %> 
<%@page import="bean.TypeObjet" %> 

<%
    String lang = String.valueOf(session.getAttribute("lang"));
    String[] mots = {"Generer etats", "Exercice", "Type de compte", "Type etat", "Mois debut", "Mois fin", "Du compte", "Au compte", "Balance comparative", "Afficher"};
    String[] ret = Utilitaire.transformerLangue(mots, lang);

    TypeObjet typeCompte, lsTypeCompte[];
    typeCompte = new TypeObjet();
    typeCompte.setNomTable("compta_type_compte");
    lsTypeCompte = (TypeObjet[]) CGenUtil.rechercher(typeCompte, null, null, "");
    
    
    String today = Utilitaire.dateDuJour();
    String todayIso = today;
    if (today.contains("/")) {
        String[] parts = today.split("/");
        todayIso = parts[2] + "-" + parts[1] + "-" + parts[0]; 
    }
%>

<script>

    var dataComptes = [];

    function chargerListeComptes() {
        $.ajax({
            url: '<%= request.getContextPath() %>/CompteServlet?action=getComptes',
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                dataComptes = data;
                initAutocompleteCompte('plage1');
                initAutocompleteCompte('plage2');
            },
            error: function(xhr, status, error) {
                console.error("Erreur lors du chargement des comptes: ", error);
            }
        });
    }
function normaliserTexte(txt) {
        return txt.toUpperCase().normalize('NFD').replace(/[̀-ͯ]/g, '');
    }
    function initAutocompleteCompte(idinput) {
        $('#' + idinput).autocomplete({
            source: function (request, response) {
                var term = normaliserTexte(request.term);
                var matches = $.map(dataComptes, function (acItem) {
                    if (normaliserTexte(acItem.label).indexOf(term) !== -1 ||
                        normaliserTexte(acItem.value).indexOf(term) !== -1) {
                        return acItem;
                    }
                });
                response(matches.slice(0, 10));
            },
            minLength: 0,
            select: function (e, ui) {
                $('#' + idinput).val(ui.item.value); 
                return false;
            },
            change: function (e, ui) {
                var currentVal = $('#' + idinput).val();
                $('#' + idinput).val(currentVal.trim());
            }
        });
    }


    function ecranBalanceCompteGeneral() {
        var date1, date2, plage1, plage2, exercice, typecompte, url, typeetat, balanceCompa, etat, lettrage;

        typeetat = $('#typeetat').val();
        exercice = $('#exercice').val();
        typecompte = $('#typecompte').val();
        etat = $('#etat').val();
        lettrage = $('#lettrage').val();
        plage1 = $('#plage1').val();
        plage2 = $('#plage2').val();
        balanceCompa = $('#balanceCompa').val();

        // Si Grand Livre → on prend dateDebut / dateFin
        if (typeetat == '2') {
            date1 = $('#dateDebut').val();
            date2 = $('#dateFin').val();
        } else {
            date1 = $('#mois1').val();
            date2 = $('#mois2').val();
        }

        if (date1 != '' && date2 != '') {
            if (typeetat == '1') { // Balance générale
                if (balanceCompa != null && balanceCompa >= 1900) {
                    url = 'compta/etat/balanceCompa-compta-general-corrige.jsp?moisDebut=' + date1 + '&moisFin=' + date2 + '&debutCompte=' + plage1 + '&finCompte=' + plage2 + '&exercice=' + exercice + '&typeCompte=' + typecompte + '&etat=' + etat + '&balanceCompa=' + balanceCompa;
                }
                if(typecompte =='2'){
                     url = 'compta/etat/balance-compta-auxiliaire-corrige.jsp?moisDebut=' + date1 + '&moisFin=' + date2 + '&debutCompte=' + plage1 + '&finCompte=' + plage2 + '&exercice=' + exercice + '&typeCompte=' + typecompte + '&etat=' + etat;
                } 
                else {
                    url = 'compta/etat/balance-compta-general-corrige.jsp?moisDebut=' + date1 + '&moisFin=' + date2 + '&debutCompte=' + plage1 + '&finCompte=' + plage2 + '&exercice=' + exercice + '&typeCompte=' + typecompte + '&etat=' + etat;
                }
                window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
            }

            if (typeetat == '2') { // Grand Livre
            console.log("plage 1 ="+plage1);
            console.log("plage 2 ="+plage2);
                if (plage1 != '' && plage2 != '') {
                    url = 'compta/etat/grand-livre-compte.jsp?dateDebut=' + date1 + '&dateFin=' + date2 + '&compteDebut=' + plage1 + '&compteFin=' + plage2 + '&exercice=' + exercice + '&typeCompte=' + typecompte + '&etat=' + etat + '&lettrage=' + lettrage;
                    window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
                } else {
                    alert('Champ compte manquant.');
                }
            }
           
        } else {
            alert('Champ date manquant.');
        }
    }

    // Transformation dynamique des champs Mois -> Date
    $(document).ready(function () {
        chargerListeComptes();
        $("#typeetat").change(function () {
            var val = $(this).val();

            if (val == "2") { // Grand Livre
                $("#blocLettrage").show();
                $("#lettrage").val("2");

                $("#blocMois1").html(`
                    <label for="dateDebut">Date début</label>
                    <input type="date" id="dateDebut" name="dateDebut" class="form-control" value="<%=todayIso%>">
                `);

                $("#blocMois2").html(`
                    <label for="dateFin">Date fin</label>
                    <input type="date" id="dateFin" name="dateFin" class="form-control" value="<%=todayIso %>">
                `);


            } else {
                 $("#blocLettrage").hide();
                 $("#lettrage").val("0");
                 $("#typecompte option[value='3']").show();
                // Restaurer Mois début
                $("#blocMois1").html(`
                    <label for="mois1"><%=ret[4]%></label>
                    <select name="mois1" id="mois1" class="form-control">
                        <option value="1">Janvier</option>
                        <option value="2">Fevrier</option>
                        <option value="3">Mars</option>
                        <option value="4">Avril</option>
                        <option value="5">Mai</option>
                        <option value="6">Juin</option>
                        <option value="7">Juillet</option>
                        <option value="8">Aout</option>
                        <option value="9">Septembre</option>
                        <option value="10">Octobre</option>
                        <option value="11">Novembre</option>
                        <option value="12">Decembre</option>
                    </select>
                `);

                // Restaurer Mois fin
                $("#blocMois2").html(`
                    <label for="mois2"><%=ret[5]%></label>
                    <select name="mois2" id="mois2" class="form-control">
                        <option value="1">Janvier</option>
                        <option value="2">Fevrier</option>
                        <option value="3">Mars</option>
                        <option value="4">Avril</option>
                        <option value="5">Mai</option>
                        <option value="6">Juin</option>
                        <option value="7">Juillet</option>
                        <option value="8">Aout</option>
                        <option value="9">Septembre</option>
                        <option value="10">Octobre</option>
                        <option value="11">Novembre</option>
                        <option value="12" selected >Decembre</option>
                    </select>
                `);
            }
        });
    });
</script>

<div class="content-wrapper">
    <h1 class="box-title"><%=ret[0]%></h1>
    <div class="row">
        <div class="col-md-12 cardradius">
            <div class="input-container">
                <!-- Exercice -->
                <div class="form-input">
                    <label class="input-label" for="exercice"><%=ret[1]%></label>
                    <span class="d-flex gap-2">
                        <input type="text" id="exercice" name="exercice" class="form-control"
                               value="<%= Utilitaire.getAnneeEnCours()%>">
                    </span>
                </div>

                <!-- Type compte -->
                <div class="form-input">
                    <label class="input-label" for="typecompte"><%=ret[2]%></label>
                    <span class="d-flex gap-2">
                        <select name="typecompte" id="typecompte" class="form-control">
                            <option value="1">Général</option>
                            <option value="3">Analytique</option>
                            <option value="2">Auxilliaire</option>
                        </select>
                    </span>
                </div>

                <!-- Type état -->
                <div class="form-input">
                    <label class="input-label" for="typeetat">Type d'&eacute;tat</label>
                    <span class="d-flex gap-2">
                        <select name="typeetat" id="typeetat" class="form-control">
                            <option value="1">Balance</option>
                            <option value="2">Grand Livre</option>
                        </select>
                    </span>
                </div>

                <!-- Etat -->
                <div class="form-input">
                    <label class="input-label" for="etat">Etat</label>
                    <span class="d-flex gap-2">
                        <select name="etat" id="etat" class="form-control">
                            <option value="0">Tous</option>
                            <option value="11">Visee</option>
                            <option value="1">Non Visee</option>
                        </select>
                    </span>
                </div>

                
                <!-- Mois début -->
                <div class="form-input" id="blocMois1">
                    <label class="input-label" for="mois1">Mois de d&eacute;but</label>
                    <span class="d-flex gap-2">
                        <select name="mois1" id="mois1" class="form-control">
                            <option value="1">Janvier</option>
                            <option value="2">Fevrier</option>
                            <option value="3">Mars</option>
                            <option value="4">Avril</option>
                            <option value="5">Mai</option>
                            <option value="6">Juin</option>
                            <option value="7">Juillet</option>
                            <option value="8">Aout</option>
                            <option value="9">Septembre</option>
                            <option value="10">Octobre</option>
                            <option value="11">Novembre</option>
                            <option value="12">Decembre</option>
                        </select>
                    </span>
                </div>

                <!-- Mois fin -->
                <div class="form-input" id="blocMois2">
                    <label class="input-label" for="mois2">Mois de fin</label>
                    <span class="d-flex gap-2">
                        <select name="mois2" id="mois2" class="form-control">
                            <option value="1">Janvier</option>
                            <option value="2">Fevrier</option>
                            <option value="3">Mars</option>
                            <option value="4">Avril</option>
                            <option value="5">Mai</option>
                            <option value="6">Juin</option>
                            <option value="7">Juillet</option>
                            <option value="8">Aout</option>
                            <option value="9">Septembre</option>
                            <option value="10">Octobre</option>
                            <option value="11">Novembre</option>
                            <option value="12" selected>Decembre</option>
                        </select>
                    </span>
                </div>

                <!-- Du compte -->
                <div class="form-input">
                    <label class="input-label" for="plage1"><%=ret[6]%></label>
                    <span class="d-flex gap-2">
                        <input id="plage1" name="plage1" class="form-control" type="text" />
                    </span>
                </div>

                <!-- Au compte (Input unique fusionné) -->
                <div class="form-input">
                    <label class="input-label" for="plage2"><%=ret[7]%></label>
                    <span class="d-flex gap-2">
                        <input id="plage2" name="plage2" class="form-control" type="text" />
                    </span>
                </div>

                <!-- Balance comparative -->
                <div class="form-input">
                    <label class="input-label" for="balanceCompa"><%=ret[8]%></label>
                    <span class="d-flex gap-2">
                        <input id="balanceCompa" name="balanceCompa" class="form-control" type="number"/>
                    </span>
                </div>
                
                <!-- Lettrage -->
                <div class="form-input" id="blocLettrage" style="display:none;">
                    <label class="input-label" for="lettrage">Lettrage</label>
                    <span class="d-flex gap-2">
                        <select name="lettrage" id="lettrage" class="form-control">
                            <option value="2">Non Lettr&eacute;</option>
                            <option value="1">Lettr&eacute;</option>
                        </select>
                    </span>
                </div>

            </div>
            <div class="box-footer borderless nopadding" style="margin-top: 1rem;">
                <button type="button" class="btn btn-primary pull-right" style="margin-right: 0;" onclick="ecranBalanceCompteGeneral()"><%=ret[9]%></button>
            </div>
        </div>
    </div>
</div>
