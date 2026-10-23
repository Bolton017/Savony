<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="produits.IngredientsLib" %>
<%@ page import="maintenance.ressources.IngredientMaintenanceLib" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>

<%
    try
    {
        IngredientMaintenanceLib t = new IngredientMaintenanceLib();
        String listeCrt[] = {"id","libelle", "marqueObjet","etatObjet","qualiteObjet","localisationObjetLib"};
        String listeInt[] = {};
        String libEntete[] = {"id","libelle","idlignelib","qualiteObjetLib","etatObjetLib","localisationObjetLib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Liste des machines");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("maintenance/ressources/machine/machine-liste.jsp");
        pr.getFormu().getChamp("id").setLibelle("R&eacute;f&eacute;rence");
        pr.getFormu().getChamp("libelle").setLibelle("libell&eacute;");
        pr.getFormu().getChamp("MarqueObjet").setLibelle("Marque");
        // pr.getFormu().getChamp("modeleObjet").setLibelle("Mod&egrave;le");
        pr.getFormu().getChamp("localisationObjetLib").setLibelle("Local");
        // pr.getFormu().getChamp("numeroSerieObjet").setLibelle("Num&eacute;ro de s&eacute;rie");
        // pr.getFormu().getChamp("referenceObjet").setLibelle("R&eacute;f&eacute;rence");
        String apreswhere = " and idEntite = '"+ConstanteMaintenance.ENTITE_MACHINE + "'";
        pr.setAWhere(apreswhere);
        Liste[] liste = new Liste[2];

        TypeObjet qlt = new TypeObjet();
        qlt.setNomTable("QUALITESOBJETMAINTENANCE");
        liste[0] = new Liste("qualiteObjet", qlt, "val", "id");

        TypeObjet etat = new TypeObjet();
        etat.setNomTable("ETATOBJETMAINTENANCE");
        liste[1] = new Liste("etatObjet", etat, "val", "id");
        pr.getFormu().getChamp("EtatObjet").setLibelle("&Eacute;tat");

        pr.getFormu().changerEnChamp(liste);

        pr.getFormu().getChamp("qualiteObjet").setLibelle("Qualit&eacute;");
        pr.getFormu().getChamp("etatObjet").setLibelle("&Eacute;tat de la machine");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        String lienTableau[] = {pr.getLien() + "?but=maintenance/ressources/machine/machine-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        String libEnteteAffiche[] = {"R&eacute;f&eacute;rence", "Description","Ligne","Qualit&eacute;","&Eacute;tat","Local"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            pr.getFormu().setAnotherButton(
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/ressources/machine/machine-saisie.jsp&currentMenu=MENDYN1764608553286867\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir dune machine</a>"
        );
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
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
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




