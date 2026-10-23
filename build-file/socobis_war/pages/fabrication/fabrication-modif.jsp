<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="annexe.Produit" %>
<%@ page import="fabrication.Fabrication" %>
<%@ page import="fabrication.FabricationFille" %>
<%@ page import="utilitaire.Utilitaire" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = u = (UserEJB) session.getValue("u");
        String classeMere = "fabrication.Fabrication",
                classeFille = "fabrication.FabricationFille",
                titre = "Modification Fabrication",
			    redirection = "fabrication/fabrication-fiche.jsp";
        String colonneMere = "idMere";

        Fabrication mere = new Fabrication();
        FabricationFille fille = new FabricationFille();

        fille.setIdMere(request.getParameter("id"));
        FabricationFille[] details = (FabricationFille[]) CGenUtil.rechercher(fille, null, null, "");
        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), details.length);
        pi.setLien((String) session.getValue("lien")); 

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
        //listeDeroulante[1].setDefaut("PNT000084");
        //pi.getFormu().getChamp("idOf").setPageAppelComplete("fabrication.Of","id","Ofab");
        pi.getFormu().getChamp("idOffille").setLibelle("Ordre de fabrication associ&eacute;");
        pi.getFormu().getChamp("idOffille").setAutre("readonly");
        pi.getFormu().changerEnChamp(listeDeroulante);
        pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute; par");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("besoin").setVisible(false);
        pi.getFormu().getChamp("idOf").setVisible(false);
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
        pi.preparerDataFormu();

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post" >
        <%
            
             pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div style="text-align: center;">
        </div>
        <%
            pi.getFormufle().makeHtmlInsertTableauIndex();
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="updateInsert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=details.length%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        <input name="nomtable" type="hidden" id="nomtable" value="FabricationFille">
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
