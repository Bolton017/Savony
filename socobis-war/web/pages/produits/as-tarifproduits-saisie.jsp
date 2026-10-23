<%-- 
    Document   : as-tarifproduits-saisie
    Created on : 1 déc. 2016, 10:54:29
    Author     : Joe
--%>
<%@page import="mg.allosakafo.produits.TarifProduits"%>
<%@page import="user.*"%> 
<%@ page import="bean.TypeObjet" %>
<%@page import="affichage.*"%>
<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    TarifProduits  a = new TarifProduits();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));    
    
    /*affichage.Champ[] liste = new affichage.Champ[5];
    
    TypeObjet op = new TypeObjet();
    op.setNomTable("TYPEARTICLE");
    liste[0] = new Liste("typearticle", op, "VAL", "id");
    
    pi.getFormu().changerEnChamp(liste);*/
    
    pi.getFormu().getChamp("produit").setPageAppel("choix/listeArticleChoix.jsp");
    pi.getFormu().getChamp("dateapplication").setLibelle("Date d'application");
    pi.getFormu().getChamp("observation").setType("textarea");
    
    /*pi.getFormu().getChamp("code").setLibelle("Code");
    pi.getFormu().getChamp("designation").setLibelle("Libelle");
    pi.getFormu().getChamp("seuil").setLibelle("Seuil");
    pi.getFormu().getChamp("unite").setLibelle("Unité");
    pi.getFormu().getChamp("presentation").setLibelle("Presentation");
    pi.getFormu().getChamp("typearticle").setLibelle("Type");
    pi.getFormu().getChamp("groupee").setLibelle("Groupe");
    pi.getFormu().getChamp("sousgroupe").setLibelle("Sous groupe");
    pi.getFormu().getChamp("chapitre").setLibelle("Chapitre");
    pi.getFormu().getChamp("constante").setLibelle("Constante");*/
    
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1>Enregistrer tarif</h1>
    <!--  -->
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="starticle" id="starticle">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="produits/as-tarifproduits-saisie.jsp">
    <input name="classe" type="hidden" id="classe" value="mg.allosakafo.produits.TarifProduits">
    </form>
</div>