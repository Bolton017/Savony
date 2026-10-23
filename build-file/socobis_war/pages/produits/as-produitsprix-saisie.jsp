<%-- 
    Document   : as-produits-saisie
    Created on : 1 d�c. 2016, 10:39:11
    Author     : Joe
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="mg.allosakafo.produits.*"%>
<%@page import="user.*"%> 
<%@ page import="bean.TypeObjet" %>
<%@page import="affichage.*"%>
<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    ProduitsPrix  a = new ProduitsPrix();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));    
    
    affichage.Champ[] liste = new affichage.Champ[1];
    
    TypeObjet op = new TypeObjet();
    op.setNomTable("as_typeproduit");
    liste[0] = new Liste("typeproduit", op, "VAL", "id");
    
    pi.getFormu().changerEnChamp(liste);
    
    pi.getFormu().getChamp("typeproduit").setLibelle("Type");
    pi.getFormu().getChamp("designation").setType("textarea");
    pi.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
    pi.getFormu().getChamp("dateapplication").setLibelle("Date d'application");
    pi.getFormu().getChamp("dateapplication").setDefaut(""+Utilitaire.dateDuJourSql());
    pi.getFormu().getChamp("observation").setType("textarea");
    pi.getFormu().getChamp("photo").setPhoto(true);
    pi.getFormu().getChamp("calorie").setDefaut("1");
    pi.getFormu().getChamp("calorie").setAutre("readonly");
    pi.getFormu().getChamp("calorie").setLibelle("Disponibilit&eacute;");
    
    
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1>Enregistrer produit</h1>
    <!--  -->
    <form action="../UploadDownloadFileServlet?dossier=produit" method="post" name="starticle" id="starticle" enctype="multipart/form-data">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="produits/as-produitsprix-saisie.jsp">
    <input name="classe" type="hidden" id="classe" value="mg.allosakafo.produits.ProduitsPrix">
    </form>
</div>
<%}catch(Exception e){
    e.printStackTrace();
}%>