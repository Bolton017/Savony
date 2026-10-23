<%--
    Document   : as-produits-liste
    Created on : 1 d�c. 2016, 10:39:44
    Author     : Joe
--%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="produits.Ingredients"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="produits.IngredientsLib" %>
<%@ page import="rapprochement.ReleverLib" %>
<%@ page import="utilitaire.Utilitaire" %>

<%
    try
    {
        ReleverLib rl = new ReleverLib();

        String listeCrt[] = {"id", "idcaisse" ,"daty"};
        String listeInt[] = {"daty"};
        String libEntete[] = {"id", "daty", "idcaisselib","datyDebut","datyFin","etatlib"};


        PageRecherche pr = new PageRecherche(rl, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.getFormu().getChamp("idcaisse").setLibelle("Banque");

        affichage.Champ[] liste = new affichage.Champ[1];

        TypeObjet ob = new TypeObjet();
        ob.setNomTable("CAISSEBANQUE");
        liste[0] = new Liste("idcaisse", ob, "val", "id");
        pr.getFormu().changerEnChamp(liste);

        pr.getFormu().getChamp("idcaisse").setLibelle("banque");
        pr.getFormu().getChamp("daty1").setLibelle("Date Min");
        pr.getFormu().getChamp("daty2").setLibelle("Date Max");
        pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

        pr.setApres("rapprochement/liste-relever.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        String[] libEnteteAffiche = {"ID", "Date (import/saisie)", "Banque","P&eacute;riode d&eacute;but","P&eacute;riode fin","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<script>
    function changerDesignation() {
        document.incident.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des relev&eacute;s</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=rapprochement/liste-relever.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

        </form>
        <%  String lienTableau[] = {pr.getLien() + "?but=rapprochement/fiche-relever.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%

            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());

        %>
    </section>
</div>
<%
    }
    catch (Exception e)
    {
        e.printStackTrace();
    }
%>

