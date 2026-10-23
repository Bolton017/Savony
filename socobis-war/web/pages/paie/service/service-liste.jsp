<%@page import="affichage.PageRecherche"%>
<%@page import="paie.log.LogService"%>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    String nomtable = "LOG_SERVICE_LIB";
    LogService t = new LogService();
    t.setNomTable(nomtable);

    String listeCrt[] = {"id", "libelle", "code_service", "libelleDirection"};
    String listeInt[] = {};
    String libEntete[] = {"id", "libelle", "code_service", "libelleDirection"};

    String pageListe = "paie/service/service-liste.jsp";
    String pageFiche = "paie/service/service-fiche.jsp";

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des Services");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres(pageListe);

    Liste[] liste = new Liste[1];
    TypeObjet r = new TypeObjet();
    r.setNomTable("LOG_DIRECTION");
    liste[0] = new Liste("libelleDirection", r,"val", "val");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("code_service").setLibelle("Code Service");
    pr.getFormu().getChamp("LIBELLEDIRECTION").setLibelle("Direction Rattach&eacute;e");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=" + pageFiche};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Libell&eacute;", "Code Service", "Direction Rattach&eacute;e"};
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
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>

