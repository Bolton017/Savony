<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="rapport.mapping.CRContentLib" %>

<% try{
    CRContentLib crContentLib = new CRContentLib();

    String listeCrt[] = {"id","titre","paragraphe","mapping", "vue", "graphe"};
    String listeInt[] = {};
    String libEntete[] = {"id","titre","paragraphe","mapping","vue","grapheLib"};
    PageRecherche pr = new PageRecherche(crContentLib, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    Liste[] listes = new Liste[1];
    listes[0] = new Liste("graphe");

    String[] aff = {"Oui", "Non"};
    String[] val = {"1", "0"};

    listes[0].ajouterValeur(val, aff);

    pr.setTitre("Liste des Contenus");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("rapport/configuration/cr/contenus/config-contenus-liste.jsp");
    pr.getFormu().changerEnChamp(listes);

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=rapport/configuration/cr/contenus/config-contenus.jsp&acte=update");
    pr.getTableau().setLienClicDroite(lienTab);

    String lienTableau[] = {pr.getLien() + "?but=rapport/configuration/cr/contenus/config-contenus-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Titre","Paragraphe","Mapping","Vue","Graphe"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>