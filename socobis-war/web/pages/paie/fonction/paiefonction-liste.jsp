<%-- 
    Document   : paiefonction
    Created on : 21 d�c. 2020, 15:07:50
    Author     : Lenovo
--%>

<%@page import="paie.edition.PaieFonction"%>
<%@page import="affichage.Liste"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="affichage.PageRecherche"%>

<% 
    try{
    PaieFonction dr = new PaieFonction();
    String nomTable = "paie_fonctionlibelle";

    if (request.getParameter("table") != null && request.getParameter("table").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("table");
    }
    dr.setNomTable(nomTable);

    String listeCrt[] = {"id", "val", "desce", "idgroupefonction"};
    String listeInt[] = {""};
    String libEntete[] = {"id", "val", "desce", "idgroupefonction"};
    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("val").setLibelle("Code Fonction");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    pr.getFormu().getChamp("idgroupefonction").setLibelle("Groupe fonction");
//    pr.getFormu().getChamp("idtypedebauche").setLibelle("Cause de d&eacute;part");
    pr.setApres("paie/fonction/paiefonction-liste.jsp");
        
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);%>
        pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/fonction/paiefonction-saisie.jsp&currentMenu=MD000000030012\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir une fonction" +
            "                </a>"
    );

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des fonctions</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/fonction/paiefonction-liste.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <%  String lienTableau[] = {pr.getLien() + "?but=paie/fonction/paiefonction-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"ID", "Code Fonction", "Description", "Groupe fonction"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<% } catch(Exception e) { e.printStackTrace();}%>