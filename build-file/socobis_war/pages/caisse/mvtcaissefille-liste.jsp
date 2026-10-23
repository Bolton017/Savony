<%@page import="caisse.MouvementCaisseFille"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
try {
    MouvementCaisseFille t = new MouvementCaisseFille();
    t.setNomTable("mouvementcaisse");

    String listeCrt[] = {"reference", "designation", "credit"};
    String listeInt[] = {};
    String libEntete[] = {"id", "reference", "designation", "credit"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if (request.getParameter("idmvtcaissemere") != null) {
        pr.setApres("caisse/mvtcaisse-fiche-mf.jsp&id=" + request.getParameter("idmvtcaissemere"));
        pr.setAWhere(" and idmvtcaissemere='" + request.getParameter("idmvtcaissemere") + "'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"Id", "R&eacute;f&eacute;rence", "D&eacute;signation", "Montant"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPageOnglet());
        } else {
    %>
        <div style="text-align: center;">
            <h4>Aucune donn&eacute;e trouv&eacute;e</h4>
        </div>
    <%
        }
    %>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
}
%>
