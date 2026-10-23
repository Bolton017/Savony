<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Graphe" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="analyse.AnalyseCpl" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="produits.Critere" %>

<% try{
    String idCritere = request.getParameter("idcritere");

    AnalyseCpl bdc = new AnalyseCpl();
    String listeCrt[] = {"daty","idcritere"};
    String listeInt[] = {"daty"};
    String libEntete[] = {};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("data/evolution-critere.jsp");

    affichage.Champ[] liste = new affichage.Champ[1];

    TypeObjet critere = new TypeObjet();
    critere.setNomTable("critere");
    Liste l1 = new Liste("idcritere", critere, "val", "id");
    liste[0] = l1;

    pr.getFormu().changerEnChamp(liste);

    if (idCritere == null || idCritere.trim().isEmpty() || idCritere.equalsIgnoreCase("*")) {
        Critere[] criteres = (Critere[]) CGenUtil.rechercher(new Critere(), null, null, "");
        if (criteres.length != 0) {
            idCritere = criteres[0].getId();
        }
    }

    pr.getFormu().getChamp("idcritere").setDefaut(idCritere);

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idcritere").setLibelle("Crit&egrave;re");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String titreGraph = "&Eacute;volution des crit&egrave;res";

%>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= titreGraph %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <div class="row m-0">
            <div class="cardradius">
                <canvas id="graph_depense_cat"></canvas>
                <h5 class="card-title text-center"><%= titreGraph %></h5>
            </div>
        </div>
    </section>

</div>
<%
        String colAbs1 = "daty";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "daty", "valeur")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_depense_cat", "");
        g1.setTypeGraphe("line");
        out.println(g1.getHtml("ctx_depense_cat"));
    }catch(Exception e){

        e.printStackTrace();
    }
%>