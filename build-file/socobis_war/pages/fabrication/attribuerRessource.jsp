<%@page import="user.*"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@ page import="fabrication.*" %>
<%@ page import="bean.TypeObjet" %>

<%
    try{
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Fabrication mere = new Fabrication();
        RessourceParFabrication fille = new RessourceParFabrication();
        String nomtable = "ressourceParFabrication";
        fille.setNomTable(nomtable);
        int nombreLigne = 10;
        RessourceParFabrication[] rfille = null;
        String idFab = request.getParameter("idFab");
        if(idFab!=null && !idFab.isEmpty()){
            Fabrication comm = new Fabrication();
            comm.setId(idFab);
            rfille = comm.genererAttribution(null);
            if(rfille!=null && rfille.length>0){
                nombreLigne = rfille.length + 3;
            }
        }

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().setNbColonne(2);

        Liste[] liste = new Liste[2];

        TypeObjet poste = new TypeObjet("Poste");
        liste[0] = new Liste("idPoste",poste,"val","id");

        TypeObjet qualification = new TypeObjet("QUALIFICATION_PAIE");
        liste[1] = new Liste("idQualification",qualification,"val","id");
        liste[0].setDeroulanteDependante(liste[0], "idPoste", "onchange");


        pi.getFormufle().changerEnChamp(liste);

        pi.getFormufle().getChamp("idFabrication_0").setLibelle("Fabrication");
        pi.getFormufle().getChamp("idRessource_0").setLibelle("Ressource");
        pi.getFormufle().getChamp("idQualification_0").setLibelle("Classification");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("idPoste_0").setLibelle("Poste");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idFabrication"),"fabrication.Fabrication","id","FABRICATIONCPL","","");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idRessource").getListeChamp(), "paie.log.LogPersonnel","id","log_personnel_v2", "","");
        if(rfille!=null && rfille.length>0){
            pi.setDefautFille(rfille);
        }
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "fabrication.Fabrication";
        String classeFille = "fabrication.RessourceParFabrication";
        String butApresPost = "fabrication/fabrication-fiche.jsp&id="+idFab+"&tab=inc/fabrication-ressource";
        String colonneMere = "idFabrication";

        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1>Saisie Ressource</h1>
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
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomtable %>">
        <input name="taille" type="hidden" id="taille" value="<%= nombreLigne %>">
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

