<%-- 
    Document   : as-produits-modif
    Created on : 2 oct. 2019, 09:47:29
    Author     : Notiavina
--%>
<%@page import="mg.allosakafo.produits.ProduitsPrix"%>
<%@page import="mg.allosakafo.produits.Produits"%>
<%@ page import="user.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        Produits  a = new Produits();

        PageUpdate pi = new PageUpdate(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        UserEJB u = (UserEJB) session.getAttribute("u");

        affichage.Champ[] liste = new affichage.Champ[1];

        TypeObjet op = new TypeObjet();
        op.setNomTable("as_typeproduit");
        liste[0] = new Liste("typeproduit", op, "VAL", "id");

        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("typeproduit").setLibelle("Type");
        pi.getFormu().getChamp("designation").setType("textarea");
        pi.getFormu().getChamp("calorie").setLibelle("Disponibilit�");
        pi.getFormu().getChamp("photo").setPhoto(true);
        pi.getFormu().getChamp("idIngredient").setVisible(false);
        //pi.getFormu().getChamp("pa").setVisible(false);
        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1 class="box-title">Modification produits</h1>
    <form action="../UpdateUploadDownloadFileServlet?dossier=produit" method="post" name="appro" id="appro" enctype="multipart/form-data">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="acte" value="update">
        <input name="bute" type="hidden" id="bute" value="produits/as-produits-fiche.jsp&id=<%=request.getParameter("id")%>">
        <input name="classe" type="hidden" id="classe" value="mg.allosakafo.produits.Produits">
    </form>
</div>
<%} catch(Exception ex){
    ex.printStackTrace();
}%>
