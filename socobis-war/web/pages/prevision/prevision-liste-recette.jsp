<%-- 
    Document   : prevision-liste-recette
    Created on : 28 août 2024, 16:58:43
    Author     : Mendrika
--%>

<%@page import="user.UserEJB"%>
<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

    try{
        PrevisionComplet prev = new PrevisionComplet();
        prev.setNomTable("PREVISION_COMPLET_CPL_REC");
        String[] intervalles = {"daty"};
        String[] criteres = {"id", "designation", "daty"};
        String[] libEntete = {"id", "daty", "designation", "credit", "effectifCredit", "recetteEcart"};
        String[] libEnteteAffiche = {"R&eacute;f&eacute;rence","Date", "D&eacute;signation", "Pr&eacute;vision", "Effectif", "&Eacute;cart"};
        PageRecherche pr = new PageRecherche( prev, request, criteres, intervalles, 3, libEntete, libEntete.length );
    
        pr.setTitre("Liste des Pr&eacute;visions de recettes");
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
    
        pr.setApres("prevision/prevision-liste-recette.jsp");
        String[] colSomme = {"credit", "effectifCredit"};
        pr.creerObjetPage(libEntete, colSomme);

        
        Map<String,String> lienTab=new HashMap();
        lienTab.put("modifier",pr.getLien() + "?but=prevision/prevision-modif.jsp");  
        pr.getTableau().setLienClicDroite(lienTab);
        
        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("daty1").setLibelle("Date D&eacute;but");
        pr.getFormu().getChamp("daty2").setLibelle("Date Fin");
        pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");


        //Definition des lienTableau et des colonnes de lien
        String lienTableau[] = {pr.getLien() + "?but=prevision/prevision-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        pr.getFormu().setAnotherButton("" +
        "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=prevision/previsionRecette-saisie.jsp&currentMenu=MENUDYN0020008\">\n" +
        "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une pr&eacute;vision de recette</a>"
        );
%>  


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
                String libelles[] = {" ", "Nombre", "Somme des pr&eacute;visions", " Somme des effectifs"};
                pr.getTableauRecap().setLibeEntete(libelles);
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>


<% }catch(Exception e){
    e.printStackTrace();
}
%>


