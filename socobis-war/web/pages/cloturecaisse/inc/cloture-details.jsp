<%--
    Document   : vente-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>


<%@page import="vente.VenteDetailsLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="caisse.ClotureCaisseFille" %>


<%
    try{
        ClotureCaisseFille t = new ClotureCaisseFille();
        t.setNomTable("CLOTURECAISSEFILLE_CPL");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "caisseLib", "montantTheorique", "montant", "ecart"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idCloture='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id", "Caisse","Montant th&eacuteorique","Montant r&eacute;el","&Eacute;cart"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        ClotureCaisseFille[] liste=(ClotureCaisseFille[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>

    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

