<%-- 
    Document   : as-produits-saisie
    Created on : 1 déc. 2016, 10:39:11
    Author     : Joe
--%>
<%@page import="mg.allosakafo.produits.Produits"%>
<%@page import="user.*"%> 
<%@ page import="bean.TypeObjet" %>
<%@page import="affichage.*"%>
<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Produits  a = new Produits();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));    
    
    affichage.Champ[] liste = new affichage.Champ[1];
    
    TypeObjet op = new TypeObjet();
    op.setNomTable("as_typeproduit");
    liste[0] = new Liste("typeproduit", op, "VAL", "id");
    
    pi.getFormu().changerEnChamp(liste);
    
    pi.getFormu().getChamp("typeproduit").setLibelle("Type");
    pi.getFormu().getChamp("designation").setType("textarea");
    
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
    <h1>Enregistrer produit</h1>
    <!--  -->
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="starticle" id="starticle">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="produits/as-produits-saisie.jsp">
    <input name="classe" type="hidden" id="classe" value="mg.allosakafo.produits.Produits">
    </form>
</div>