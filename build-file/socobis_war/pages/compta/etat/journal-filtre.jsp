<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.CGenUtil" %>
<%@page import="bean.TypeObjet" %>
<%
    String lang = String.valueOf(session.getAttribute("lang"));
    //String[] mots = {"Journal", "Mois", "Annee","Afficher"};
    //String[] ret = Utilitaire.transformerLangue(mots, lang);

    TypeObjet journal, liste[];
    journal = new TypeObjet();
    journal.setNomTable("COMPTA_JOURNAL");
    liste = (TypeObjet[]) CGenUtil.rechercher(journal, null, null, "");
%>
<script>

    function ecranJournaux() {
        var journal, mois, annee;
        journal = $('#journal').val();
        mois = $('#mois').val();
        annee = $('#annee').val();
        if(journal != '' && mois != '' && annee!=''){
            url = 'compta/etat/journal-compta.jsp?journal=' + journal + '&mois=' + mois + '&annee=' + annee;
            window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
        } else {
            alert('Champ date manquant.');
        }
    }

    function focusOut(idinput) {
        var value = $("#" + idinput).val();
        if (value.trim() == "") {
            return;
        } else {
            var temp = value.split(":");
            $("#" + idinput).val(temp[0].trim());
        }
    }

    function findLibelleCompte(idinput) {
        $(document).on('keydown', '#' + idinput, function (e) {
            var keyCode = e.keyCode || e.which;

            if (keyCode == 9 || keyCode == 13) {
                var prest = $('#' + idinput).val();
                if (prest != null && prest.trim() != "") {
                    var temp = prest.split(":");
                    $('#' + idinput).val(temp[0].trim());
                }

            } else {
                var compte = "";
                var data = <%= session.getAttribute("comptaComptes")%>;
                $('#' + idinput).autocomplete({
                    source: function (request, response) {
                        var matches = $.map(data, function (acItem) {
                            if (acItem.toUpperCase().indexOf(request.term.toUpperCase()) === 0) {
                                return acItem;
                            }
                        });
                        response(matches);
                    },
                    minLength: 0,
                    select: function (e, ui) {
                        var selectedObj = ui.item;
                        var prest = selectedObj.value;
                        var temp = prest.split(":");
                        compte = temp[0].trim();
                        $("#" + idinput).val(compte);

                    }
                });
            }
        });
    }
</script>
<div class="content-wrapper" style="padding: 15px">
        <h1 class="box-title">Edition des Journaux
        </h1>

    <div class="row">
        <div class="col-md-12 cardradius">
            <div class="input-container">
                <div class="form-input">
                    <label class="input-label" for="journal">Journal</label>
                    <span class="d-flex gap-2">
                        <select name="journal" id="journal" class="form-control">
                            <% for(TypeObjet temp : liste) { %>
                            <option value="<%= temp.getId() %>"><%= temp.getDesce() %></option>
                            <% } %>
                        </select>
                    </span>
                </div>

                <div class="form-input">
                    <label class="input-label" for="mois">Mois</label>
                    <span class="d-flex gap-2">
                        <select name="mois" id="mois" class="form-control">
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

                <div class="form-input">
                    <label class="input-label" for="annee">Ann&eacute;e</label>
                    <span class="d-flex gap-2">
                        <input type="text" id="annee" name="annee" class="form-control"
                               value="<%= Utilitaire.getAnneeEnCours()%>">
                    </span>
                </div>
            </div>
            <div class="box-footer borderless nopadding" style="margin-top: 1rem;">
                <button type="button" class="btn btn-primary pull-right" style="margin-right: 0;" onclick="ecranJournaux()">Afficher</button>
            </div>
        </div>
    </div>
</div>