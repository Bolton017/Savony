<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="maintenance.travaux.OrdreTravaux" %>
<%@ page import="maintenance.travaux.OrdreTravauxFille" %>
<%@ page import="maintenance.planning.DemandeTravauxCpl" %>

<%
    try{
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        OrdreTravaux mere = new OrdreTravaux();
        OrdreTravauxFille fille = new OrdreTravauxFille();
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("lancePar").setVisible(false);

        pi.getFormu().getChamp("cible").setLibelle("Cible");
        pi.getFormu().getChamp("cible").setVisible(false);
//        pi.getFormu().getChamp("cible").setPageAppelComplete("magasin.Magasin", "id", "MAGASINPOINT");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("besoin").setLibelle("Date de besoin");
        pi.getFormu().getChamp("besoin").setDefaut(Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(Utilitaire.dateDuJour(),7)));
        pi.getFormu().getChamp("besoin").setAutre("onChange='completeDate()'");
//        Liste[] listeDeroulante=new Liste[1];
//        listeDeroulante[0]=new Liste("cible",new bean.TypeObjet("MAGASIN2"),"val","id");
//        pi.getFormu().changerEnChamp(listeDeroulante);
        pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute; par");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().setNbColonne(2);
        pi.getFormu().getChamp("idBc").setLibelle("Num&eacute;ro de bon de commande : ");
        pi.getFormu().getChamp("idBc").setVisible(false);

        DemandeTravauxCpl demandeTravaux = new DemandeTravauxCpl();
        if (request.getParameter("idDemande")!=null){
            demandeTravaux = (DemandeTravauxCpl) demandeTravaux.getById(request.getParameter("idDemande"),"DemandeTravaux_Cpl",null);
            pi.getFormu().getChamp("lancePar").setDefaut(demandeTravaux.getIdEntite());
            pi.getFormu().getChamp("idBc").setDefaut(demandeTravaux.getId());
            pi.getFormu().getChamp("libelle").setDefaut("Ordre de travaux suivant la demande "+demandeTravaux.getId());
            pi.getFormu().getChamp("remarque").setDefaut(demandeTravaux.getDescription());
            OrdreTravauxFille [] ordreTravauxFilles = new OrdreTravauxFille[1];
            ordreTravauxFilles[0] = new OrdreTravauxFille();
            ordreTravauxFilles[0].setIdIngredients(demandeTravaux.getIdMachine());
            ordreTravauxFilles[0].setRemarque(demandeTravaux.getIdMachineLib());
            pi.setDefautFille(ordreTravauxFilles);
            pi.getFormu().getChamp("besoin").setDefaut(Utilitaire.datetostring(demandeTravaux.getDateBesoin()));
        }

        pi.getFormufle().getChamp("idIngredients_0").setLibelle("&Eacute;l&eacute;ment");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("idunite_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("libelle_0").setLibelle("Libell&eacute;");

        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
//        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("remarque").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("qte").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("libelle").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("datybesoin").getListeChamp(),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),"readonly");
        affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("qte").getListeChamp(),"1");

        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idIngredients").getListeChamp(), "maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE_LIB","","");

        String[] colOrdre = {"daty", "cible", "remarque", "libelle", "besoin", "idBc","lancePar","etat"};
        pi.getFormu().setOrdre(colOrdre);
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "maintenance.travaux.OrdreTravaux";
        String classeFille = "maintenance.travaux.OrdreTravauxFille";
        String butApresPost = "maintenance/travaux/Otravaux-fiche.jsp";
        String colonneMere = "idMere";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
        String titre="Saisie d'un ordre de travaux";
        if(request.getParameter("acte")!=null){
            titre = "Modification d'un ordre de travaux";
        }
%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1><%=titre%></h1>
    <!--  -->
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
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

    function completeMachineLib(machineLib){
        document.getElementById("idIngredients_0libelle").value = machineLib;
    }

    document.addEventListener('DOMContentLoaded', function() {
        <%
            if (request.getParameter("idDemande")!=null){
        %>
        completeMachineLib('<%=demandeTravaux.getIdMachineLib()%>');
        <%
            }
        %>
    });
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

