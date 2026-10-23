<%@page import="calculBesoin.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="fabrication.Of" %>

<%
    try {
        ResultatBesoinsParMatiere t = new ResultatBesoinsParMatiere();

        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"idMatiere", "idMatiereLib", "quantiteBesoins", "quantiteEnStock", "quantiteNecessaire", "uniteLib", "pu"};

        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));

        pr.setLien((String) session.getValue("lien"));
        pr.setNpp(50);
        pr.creerObjetPage(libEntete, null);

        // Libellés affichés
        String[] libEnteteAffiche = {
                "ID Mati&egrave;re",
                "Mati&egrave;re",
                "Quantit&eacute; besoins",
                "Quantit&eacute; en stock",
                "Quantit&eacute; n&eacute;cessaire",
                "Unit&eacute;",
                "Prix unitaire"
        };
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

        String id = request.getParameter("id");
        Of besoin = (Of) new Of().getById(id, null, null);
        ResultatBesoinsParMatiere[] data = besoin.getBesoinsParMatiere(null);

        pr.getTableau().setData(data);
        pr.getTableau().transformerDataString();

        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idMatiere"};
        String attLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setAttLien(attLien);
        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %>
    <center><h4>Aucune donnée trouvée</h4></center>
    <%
        }
    %>
</div>

<%= pr.getModalHtml("modalContent") %>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>