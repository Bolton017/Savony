<%@page import="transport.Course"%>
<%@page import="transport.CourseFille"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="stock.TransfertStock" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="faturefournisseur.As_BonDeLivraison_Lib" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="vente.As_BondeLivraisonClient_Cpl" %>
<%@ page import="faturefournisseur.As_BonDeLivraison" %>
<%@ page import="utils.ConstanteSocobis" %>

<%
    try{
        // Récupération du parametre acte pour définir si cela est une insertion ou une modification
        String acte = "insert";
      
        // Récupération de la session user
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");

        // Creation des objets mere et fille
        Course mere = new Course();   
        CourseFille fille = new CourseFille();

        // Creation de la page d'insertion multiple
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));

        String ids = request.getParameter("ids");
        String livraison = request.getParameter("livraison");
        if (livraison != null && livraison.startsWith("BLC")) {
            String[] idsValues = request.getParameterValues("ids");
            if (idsValues == null) {
              idsValues = new String[] {livraison};
            }
            CourseFille[] filles = new As_BondeLivraisonClient_Cpl().creeCourseFilles(idsValues, null);
            pi.setDefautFille(filles);
        }
         if (livraison != null && livraison.startsWith("BL")) {
            String[] idsValues = request.getParameterValues("ids");
            if (idsValues == null) {
              idsValues = new String[] {livraison};
            }
            CourseFille[] filles = new As_BonDeLivraison().creeCourseFilles(idsValues, null);
            pi.setDefautFille(filles);
        }
        else if (ids != null && !ids.isEmpty()) {
            String[] listeId = ids.split(";");
            for (int i = 0; i < listeId.length; i++) {
                TransfertStock transfertStock = (TransfertStock) new TransfertStock().getById(listeId[i], "TRANSFERTSTOCK", (Connection) null);
                pi.getFormufle().getChamp("idobjet_" + i).setDefaut(transfertStock.getId());
                pi.getFormufle().getChamp("remarque_" + i).setDefaut(transfertStock.getDesignation());
            }
        }

        pi.getFormu().getChamp("idvehicule").setLibelle("V&eacute;hicule");
//        pi.getFormu().getChamp("idvehicule").setPageAppelComplete("maintenance.ressources.IngredientMaintenance", "id", "AS_INGREDIENT_MAINTENANCE", "id;libelle", "id;libelle");
        pi.getFormu().getChamp("idvehicule").setPageAppelCompleteAWhere("produits.IngredientVente", "id", "AS_INGREDIENTS", "id;libelle", "id;libelle"," and CATEGORIEINGREDIENT = '"+ ConstanteSocobis.categorie_vehicule +"'");
        pi.getFormu().getChamp("idchauffeur").setLibelle("Chauffeur");
        pi.getFormu().getChamp("idchauffeur").setPageAppelComplete("siege.Chauffeur", "id", "CHAUFFEUR", "id;nom", "id;nom");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        
        pi.getFormu().getChamp("etat").setVisible(false);

        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idpersonnel").getListeChamp(), "personnel.LogPersonnel", "id", "LOG_PERSONNEL", "","");
//         affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idobjet").getListeChamp(), "vente.As_BondeLivraisonClient", "id", "AS_BONDELIVRAISON_CLIENT", "","");
        for (int i = 0; i < nombreLigne; i++) {
            pi.getFormufle().getChamp("etat_"+i).setDefaut("1");
        }
        pi.getFormufle().getChamp("idobjet_0").setLibelle("Objet");
        pi.getFormufle().getChamp("datedepart_0").setLibelle("Date de d&eacute;part");
        pi.getFormufle().getChamp("heuredepart_0").setLibelle("Heure de d&eacute;part (h)");
        pi.getFormufle().getChamp("datearrivee_0").setLibelle("Date de d'arriv&eacute;e (h)");
        pi.getFormufle().getChamp("heurearrivee_0").setLibelle("Heure d'arriv&eacute;e");
        pi.getFormufle().getChamp("idpersonnel_0").setLibelle("Personnel");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");

        affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idmere"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("datedepart"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("datearrivee"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("heuredepart"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("heurearrivee"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idpersonnel"), false);
        //Variables de navigation
        String classeMere = "transport.Course";
        String classeFille = "transport.CourseFille";
        String butApresPost = "transport/course-fiche.jsp"; // Page a aller apres saisie
        String colonneMere = "idmere"; // colonne mere de la fille

        //Preparer les affichages
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
       
%>
<div class="content-wrapper">
    <!-- A modifier -->
    <% if (request.getParameter("acte") != null) { %>
        <h1>Modification d'une course</h1>
    <% } else { %>
        <h1>Saisie d'une course</h1>
    <% } %>

    <form  id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" > 
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        
        <input name="acte" type="hidden" id="nature" value="<%=acte%>">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>
        
</div>

<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>

