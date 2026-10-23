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

    function ecranBilan() {
        var annee,typeetat;
        typeetat = $('#typeetat').val();
        annee = $('#annee').val();
        if(annee!='' && annee>0){
            if (typeetat=='1'){
                url = 'compta/bilan/bilanActif.jsp?typeetat=' + typeetat +'&annee=' + annee;
                window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
            }
            else if(typeetat=='2'){
                url = 'compta/bilan/bilanPassif.jsp?typeetat=' + typeetat +'&annee=' + annee;
                window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
            }
            else if(typeetat=='3'){
                url = 'compta/bilan/compteResultat.jsp?typeetat=' + typeetat +'&annee=' + annee;
                window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
            }

        } else {
            alert('Champ date manquant.');
        }
    }

</script>
<style>
    .col-md-12.cardradius{
        margin-top: 0px;
    }
</style>
<div class="content-wrapper" style="padding: 15px">
    <h1 class="box-title">&Eacute;tats Financiers</h1>
    <div class="col-md-12 cardradius">
        <div class="input-container">
            <div class="form-input">
                <label multi-lang="" class="input-label" for="typeetat">Type &Eacute;tat</label>
                <span class="d-flex gap-2">
                    <select name="typeetat" id="typeetat" class="form-control">
                        <option value="1">Bilan Actif</option>
                        <option value="2">Bilan Passif</option>
                        <option value="3">Compte de R&eacute;sultat</option>
                    </select>
                </span>
            </div>
            <div class="form-input">
                <label multi-lang="" class="input-label" for="annee">Ann&eacute;e</label>
                <span class="d-flex gap-2">
                    <input type="text" id="annee" name="annee" class="form-control" value="<%= Utilitaire.getAnneeEnCours()%>">
                </span>
            </div>
            <div class="box-footer borderless nopadding w-100" style="margin-top: 1rem;">
                    <a class="btn btn-primary pull-right" type="submit" onclick="ecranBilan()">Afficher</a>
            </div>
        </div>
    </div>
</div>