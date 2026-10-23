<%-- 
    Document   : prevision-non-regle
    Created on : 29 ao�t 2024, 11:42:51
    Author     : Estcepoire
--%>

<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@page import="user.*"%>

<%

    try{
        PrevisionComplet prev = new PrevisionComplet();
        prev.setNomTable("Prevision_COMPLET_CPL_NR");
        String[] intervalles = {"daty"};
        String[] criteres = {"id", "designation", "daty", "compte"};
        String[] libEntete = {"ID", "daty", "designation", "compte",  "debit", "credit", "effectifDebit", "effectifCredit", "depenseEcart", "recetteEcart"};
        String[] libEnteteAffiche = {"id","Date", "D&eacute;signation", "Compte", "D&eacute;pense", "Recette", "D&eacute;pense effective", "Recette effective", "&Eacute;cart d&eacute;pense", "&Eacute;cart recette"};
        PageRecherche pr = new PageRecherche( prev, request, criteres, intervalles, 3, libEntete, libEntete.length );

        pr.setTitre("Liste des Previsions");
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        pr.setApres("prevision/prevision-non-regle.jsp");
        String[] colSomme = {"debit", "credit", "effectifDebit","effectifCredit"};
        pr.creerObjetPage(libEntete, colSomme);

        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("daty1").setLibelle("Date Debut");
        pr.getFormu().getChamp("daty2").setLibelle("Date Fin");
        pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");

        //Definition des lienTableau et des colonnes de lien
        String lienTableau[] = {pr.getLien() + "?but=prevision/prevision-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String idMvtCaisse = request.getParameter("idMvtCaisse");
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>

    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="filtre">
            <%
                String libelles[]={" ","Nombre", "Somme des D&eacute;penses", "Somme des Recettes", "Somme des D&eacute;penses effectives", "Somme des Recettes effectives"};
                pr.getTableauRecap().setLibeEntete(libelles);
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <form action="<%= pr.getLien()%>?but=prevision/apresLiaisonMvtCaisse.jsp" method="post">
            <input type="hidden" name="idMvtCaisse" value="<%=idMvtCaisse%>" >
            <input type="hidden" name="lien" value="<%=pr.getLien()%>">
            <%
                //out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <%
                out.println(pr.getTableauRecap().getHtml());%>
            <br>
            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
                out.println(pr.getBasPage());
            %>
        </form>
    </section>

</div>


<% }catch(Exception e){
    e.printStackTrace();
}
%>


