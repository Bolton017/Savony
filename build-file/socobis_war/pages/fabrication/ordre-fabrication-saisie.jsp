<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="annexe.Produit" %>
<%@ page import="fabrication.Of" %>
<%@ page import="fabrication.OfFille" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="vente.BonDeCommande" %>
<%@ page import="vente.BonDeCommandeFille" %>
<%@ page import="fabrication.OfFilleCpl" %>

<%
    try{
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Of mere = new Of();
        OfFilleCpl fille = new OfFilleCpl();
        fille.setNomTable("OFFILLE_VIDE");
        int nombreLigne = 10;
        OfFille[] ofille = null;
        String idBC = request.getParameter("idBC");
        if(idBC!=null && !idBC.isEmpty()){
            BonDeCommande comm = new BonDeCommande();
            comm.setId(idBC);
            ofille = comm.getBondeCommandeFille();
        }

        
        
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute;e Par");
        //pi.getFormu().getChamp("cible").setLibelle("Cible");
        //pi.getFormu().getChamp("cible").setVisible(false);
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("besoin").setLibelle("Date de besoin");
        pi.getFormu().getChamp("besoin").setDefaut(Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(Utilitaire.dateDuJour(),7)));
        pi.getFormu().getChamp("besoin").setAutre("onChange='completeDate()'");
        Liste[] listeDeroulante=new Liste[2];
        listeDeroulante[0]=new Liste("lancePar",new bean.TypeObjet("MAGASIN2"),"val","id");
        listeDeroulante[1]=new Liste("cible",new bean.TypeObjet("MAGASIN2"),"val","id");
        pi.getFormu().changerEnChamp(listeDeroulante);
        // libelles a reposer APRES changerEnChamp : il ne recopie pas le libelle sur la Liste
        pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute; par");
        pi.getFormu().getChamp("cible").setLibelle("Cible");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().setNbColonne(2);
        //pi.getFormu().getChamp("idBc").setLibelle("Num&eacute;ro de bon de commande : ");
        //pi.getFormu().getChamp("idBc").setDefaut(idBC);
        pi.getFormu().getChamp("idBc").setVisible(false);


        pi.getFormufle().getChamp("idIngredients_0").setLibelle("Produits");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("iduniteLib_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("libelle_0").setLibelle("D&eacute;signation");

        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
        //affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("libelle").getListeChamp(),false);

        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("datybesoin").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("iduniteLib").getListeChamp(),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idBcFille").getListeChamp(),"readonly");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idIngredients").getListeChamp(), "produits.IngredientsLib", "id", "AS_INGREDIENTS_PRODUIT_COMPOSE", "unite;idUnite","iduniteLib;idunite");
        if(ofille!=null && ofille.length>0){
            pi.setDefautFille(ofille);
            pi.getFormu().getChamp("libelle").setDefaut("Ordre de fabrication de "+idBC);
        }
        String[] colOrdre = {"daty", "libelle", "besoin", "lancePar", "cible", "remarque", "idBc", "etat"};
        pi.getFormu().setOrdre(colOrdre);
        String[] colOrdreF = {"idIngredients", "libelle", "qte", "iduniteLib", "idunite", "remarque"};
        pi.getFormufle().setColOrdre(colOrdreF);
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "fabrication.Of";
        String classeFille = "fabrication.OfFille";
        String butApresPost = "fabrication/ordre-fabrication-fiche.jsp";
        String colonneMere = "idMere";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
        String titre="Saisie d'un ordre de fabrication";
        if(request.getParameter("acte")!=null){
            titre = "Modification d'un ordre de fabrication";
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

