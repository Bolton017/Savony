<%-- 
    Document   : prevision-liste-depense
    Created on : 28 ao�t 2024, 16:55:05
    Author     : Estcepoire
--%>

<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@page import="user.*"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>

<%

    try{
        PrevisionComplet prev = new PrevisionComplet();
        prev.setNomTable("PREVISION_COMPLET_CPL_DEP");
        String[] intervalles = {"daty"};
        String[] criteres = {"id", "designation", "daty"};
        String[] libEntete = {"id", "daty", "designation", "debit", "effectifdebit","depenseEcart"};
        String[] libEnteteAffiche = {"ID","Date", "D&eacute;signation","Pr&eacute;vision", "Effectif", "&Eacute;cart"};
        PageRecherche pr = new PageRecherche( prev, request, criteres, intervalles, 3, libEntete, libEntete.length );
    
        pr.setTitre("Liste des Pr&eacute;visions de D&eacute;penses");
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
    
        pr.setApres("prevision/prevision-liste-depense.jsp");
        String[] colSomme = {"debit","effectifDebit"};
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
        "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=prevision/previsionDepense-saisie.jsp&currentMenu=MENUDYN0020006\">\n" +
        "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une pr&eacute;vision de d&eacute;pense</a>"
        );
%>  


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
                String libelles[]={" ","Nombre", "Somme des pr&eacute;visions", "Somme des effectifs"};
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


