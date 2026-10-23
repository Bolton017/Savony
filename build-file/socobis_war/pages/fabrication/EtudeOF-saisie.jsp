<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="fabrication.EtudeOfFille" %>
<%@ page import="fabrication.EtudeOf" %>

<%
    try{
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        EtudeOf mere = new EtudeOf();
        EtudeOfFille fille = new EtudeOfFille();
        int nombreLigne = 10;
        EtudeOfFille[] ofille = null;

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute;e Par");
        pi.getFormu().getChamp("cible").setLibelle("Cible");
        pi.getFormu().getChamp("cible").setPageAppelComplete("magasin.Magasin", "id", "MAGASINPOINT");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("besoin").setLibelle("Date de besoin");
        pi.getFormu().getChamp("besoin").setDefaut(Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(Utilitaire.dateDuJour(),7)));
        pi.getFormu().getChamp("besoin").setAutre("onChange='completeDate()'");
        Liste[] listeDeroulante=new Liste[2];
        listeDeroulante[0]=new Liste("cible",new bean.TypeObjet("MAGASIN2"),"val","id");
        listeDeroulante[1]=new Liste("lancePar",new bean.TypeObjet("MAGASIN2"),"val","id");
        pi.getFormu().changerEnChamp(listeDeroulante);
        pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute; par");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().setNbColonne(2);
        pi.getFormu().getChamp("idBc").setVisible(false);

        pi.getFormufle().getChamp("idIngredients_0").setLibelle("Produits");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("idunite_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("libelle_0").setLibelle("D&eacute;signation");

        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
        //affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("libelle").getListeChamp(),false);

        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("datybesoin").getListeChamp(),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),"readonly");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idIngredients").getListeChamp(), "produits.IngredientsLib", "id", "AS_INGREDIENTS_PRODUIT_FINIE", "unite","idunite");
        String[] colOrdre = {"daty", "cible", "remarque", "libelle", "besoin", "idBc","lancePar","etat"};
        pi.getFormu().setOrdre(colOrdre);
        String[] colOrdreF = {"idIngredients", "libelle", "qte", "idunite", "remarque"};
        pi.getFormufle().setColOrdre(colOrdreF);
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "fabrication.EtudeOf";
        String classeFille = "fabrication.EtudeOfFille";
        String butApresPost = "fabrication/EtudeOF-fiche.jsp";
        String colonneMere = "idMere";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
        String titre="Saisie d'un etude d'ordre de fabrication";
        if(request.getParameter("acte")!=null){
            titre = "Modification d'un etude d'ordre de fabrication";
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
        <input name="nomtable" type="hidden" id="nomtable" value="EtudeOfFille">
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

