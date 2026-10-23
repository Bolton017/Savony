

<%@page import="faturefournisseur.As_BonDeLivraison_Fille_Cpl"%>
<%@ page import="affichage.*" %>

<%
    try {
        String lien = (String) session.getValue("lien");
        As_BonDeLivraison_Fille_Cpl t = new As_BonDeLivraison_Fille_Cpl();
        t.setNomTable("rapprochement_bf_fournisseur");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","produit", "produitlib", "unitelib",  "quantite","qteEntree","resteAEntrer"};

        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien(lien);
        String id =request.getParameter("id");
        if(id != null) {
            pr.setAWhere(" and numbl='"+id+"'");
        }
        String[] colSomme = null;
        pr.setNpp(100);
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"R&eacute;f&eacute;rence", "ID Produit", "Produit", "Unit&eacute;", "Quantit&eacute;", "Quantit&eacute; entr&eacute;e", "Reste &agrave; entrer"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

        String[] colLien = new String[] {"produit"};
        String[] link = new String[] {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String[] attLien = new String[] {"id"};

        pr.getTableau().setColonneLien(colLien);
        pr.getTableau().setLien(link);
        pr.getTableau().setAttLien(attLien);

        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
    <div class="box-footer">

    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

