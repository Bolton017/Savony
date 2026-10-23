<%@page import="user.*"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@ page import="fabrication.*" %>
<%@ page import="bean.TypeObjet" %>

<%
    String idFab = request.getParameter("idFab");
    String ficheFab = "fabrication-fiche.jsp?id=" + idFab;
%>

<jsp:include page="<%= ficheFab %>"/>


<%
    try{
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Fabrication mere = new Fabrication();
        HeureSupFabrication fille = new HeureSupFabrication();
        fille.setNomTable("heureSupFabrication_cpl");
        int nombreLigne = 10;
        HeureSupFabricationCPL[] hfille = null;
        if(idFab!=null && !idFab.isEmpty()){
            Fabrication comm = new Fabrication();
            comm.setId(idFab);
            hfille = comm.genererHeureSup(null);
            if(hfille!=null && hfille.length>0){
                nombreLigne = hfille.length + 3;
            }
        }

//        Fabrication fab = mere.genererRessourceFab();
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().setNbColonne(2);

        Liste[] liste = new Liste[1];

        TypeObjet temp = new TypeObjet("HEURESUPTEMPORAIRE");
        liste[0] = new Liste("temporaire",temp,"desce","val");
        pi.getFormufle().changerEnChamp(liste);

//        if (request.getParameter("idFab") != null) {
//            pi.setDefautFille(fab.getFille());
//        }
        pi.getFormufle().getChamp("idRessParFab_0").setLibelle("Ressource Fabrication");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idRessParFab"),"personnel.Personnel","id","PERSONNEL_MATRICULE","","");
        pi.getFormufle().getChamp("heurenormale_0").setLibelle("Heure Normale");
        pi.getFormufle().getChamp("HS_0").setLibelle("Heure Suppl&eacute;mentaire");
        pi.getFormufle().getChamp("MN_0").setLibelle("Majoration Nuit");
        pi.getFormufle().getChamp("JF_0").setLibelle("Jour Feri&eacute;");
        pi.getFormufle().getChamp("IF_0").setLibelle("Indemnit&eacute; de fonction");
        pi.getFormufle().getChamp("HD_0").setLibelle("Heure Dimanche");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Personnel");
        pi.getFormufle().getChamp("idPersonne_0").setLibelle("ID Personnel");
        pi.getFormufle().getChamp("dateFabrication_0").setLibelle("Date de fabrication");
        pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
        pi.getFormufle().getChamp("idQualification_0").setLibelle("Qualification");
        pi.getFormufle().getChamp("montantJF_0").setLibelle("Montant jours f&eacute;ri&eacute;s");
        pi.getFormufle().getChamp("montantHD_0").setLibelle("Montant heures de dimanche");
        pi.getFormufle().getChamp("montantIF_0").setLibelle("Montant Indemnit&eacute; de fonction");
        pi.getFormufle().getChamp("montantIF_0").setLibelle("Montant Indemnit&eacute; de fonction");
        pi.getFormufle().getChamp("temporaire_0").setLibelle("Temporaire");
        pi.getFormufle().getChamp("montantMN_0").setLibelle("Montant majoration nuit");



        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
//        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("temporaire").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("matricule").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("tauxHoraire").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("tauxHoraireEffective").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idFabrication").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("etat").getListeChamp(),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idRessParFab").getListeChamp(),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idPersonne").getListeChamp(),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("remarque").getListeChamp(),"readonly");

        if(hfille!=null && hfille.length>0){
            pi.setDefautFille(hfille);
        }
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "fabrication.Fabrication";
        String classeFille = "fabrication.HeureSupFabrication";
        String butApresPost = "fabrication/fabrication-fiche.jsp&id="+idFab+"&tab=inc/fabrication-hs";
        String colonneMere = "idFabrication";

        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1>Saisie Heure Suppl&eacute;mentaire</h1>
    <!--  -->
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>

        <input name="acte" type="hidden" id="nature" value="insertFille">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
        <input name="idMere" type="hidden" id="idMere" value="<%= idFab %>">
        <input name="nomtable" type="hidden" id="nomtable" value="heureSupFabrication">
    </form>

</div>
<script>
    function completeDate() {

        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){

                $("#besoin").html($('#besoin').val());
                var idDevise = $('#besoin').val();
                $("#datyBesoin_"+iL).val(idDevise);
            };
        }
    }
</script>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

