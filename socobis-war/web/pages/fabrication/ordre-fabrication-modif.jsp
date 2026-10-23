<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="annexe.Produit" %>
<%@ page import="fabrication.Of" %>
<%@ page import="fabrication.OfFille" %>
<%@ page import="annexe.Produit" %>
<%@ page import="fabrication.Of" %>
<%@ page import="fabrication.OfFille" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%
    //Variable de navigation
    String classeMere = "fabrication.Of";
    String classeFille = "fabrication.OfFille";
    String butApresPost = "fabrication/ordre-fabrication-fiche.jsp";
    String colonneMere = "idMere";
    //Definition de l'affichage
    String id = request.getParameter("id");
    Of  mere = new Of();
    mere.setNomTable("Ofab");
    OfFille fille = new OfFille();
    fille.setNomTable("OfFille");
    fille.setIdMere(id);
    OfFille[] details = (OfFille[])CGenUtil.rechercher(fille, null, null, "");  
    PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), details.length);
    //Information globale
    pi.setLien((String) session.getValue("lien"));
      pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute; par");
        pi.getFormu().getChamp("lancePar").setPageAppelCompleteInsert("annexe.Point", "id", "POINT", "annexe/point/point-saisie.jsp", "id;val");
        pi.getFormu().getChamp("cible").setLibelle("Cible");
        pi.getFormu().getChamp("cible").setPageAppelCompleteInsert("annexe.Point", "id", "POINT", "annexe/point/point-saisie.jsp", "id;val");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("besoin").setDefaut(Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(Utilitaire.dateDuJour(),7)));
        Liste[] listeDeroulante=new Liste[2];
        listeDeroulante[0]=new Liste("lancePar",new bean.TypeObjet("POINT"),"val","id");
        listeDeroulante[1]=new Liste("cible",new bean.TypeObjet("POINT"),"val","id");
        listeDeroulante[1].setDefaut("PNT000084");
        pi.getFormu().changerEnChamp(listeDeroulante);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormufle().getChamp("idIngredients_0").setLibelle("Ingr&eacute;dients");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("idunite_0").setLibelle("Unit&eacute;");
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("libelle").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("datybesoin").getListeChamp(),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),"readonly");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idIngredients").getListeChamp(), "produits.IngredientsLib", "id", "as_ingredients_lib", "unite","idunite");
    //Preparer affichage
         pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
    
%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1>Modification Ordre de Fabrication</h1>
    <!--  -->
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post" >
        <%
            
             pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            pi.getFormufle().makeHtmlInsertTableauIndex();
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
                        <input name="acte" type="hidden" id="nature" value="updateInsert">
                        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
                        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
                        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
                        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=details.length%>">
                        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">  
    </form>

</div>