<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@page import="user.*"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>

<%

    try{
        PrevisionComplet prev = new PrevisionComplet();
        prev.setNomTable("PREVISION_COMPLET_CPL");
        String[] intervalles = {"daty"};
        String[] criteres = {"id", "designation", "daty", "compte"};
        String[] libEntete = {"id", "daty", "designation", "compte",  "debit", "credit", "effectifDebit", "effectifCredit", "depenseEcart", "recetteEcart"};
        String[] libEnteteAffiche = {"id","Date", "D&eacute;signation", "Compte", "D&eacute;pense", "Recette", "D&eacute;pense Effective", "Recette Effective", "&Eacute;cart de d&eacute;pense", "&Eacute;cart de recette"};
        PageRecherche pr = new PageRecherche( prev, request, criteres, intervalles, 3, libEntete, libEntete.length );
    
        pr.setTitre("Liste des Pr&eacute;visions");
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
    
        pr.setApres("prevision/prevision-liste.jsp");
        String[] colSomme = {"debit", "credit", "effectifDebit","effectifCredit"};
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
        "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=prevision/prevision-saisie.jsp&currentMenu=MENUDYN0020001\">\n" +
        "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une pr&eacute;vision</a>"
        );
%>  


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
                String libelles[]={" ","Nombre", "Somme des D&eacute;penses", "Somme des Recettes", "Somme des D&eacute;penses effectives", "Somme des Recettes effectives"};
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

