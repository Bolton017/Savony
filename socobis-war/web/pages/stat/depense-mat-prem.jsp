<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Graphe" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="stat.StatDepenseMatPrem" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="utils.ConstanteAsync" %>

<% try{
    StatDepenseMatPrem bdc = new StatDepenseMatPrem();
    String listeCrt[] = {"id","annee"};
    String listeInt[] = {};
    String libEntete[] = {};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
//    pr.setAWhere(" order by moisint asc ");
//    pr.getFormu().getChamp("id").setPageAppelComplete("produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE","","");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stat/depense-mat-prem.jsp");

    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pr.getFormu().getChamp("id").setLibelle("Mati&egrave;re");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String anneeActuel = Utilitaire.getAnneeEnCours();
    String valAnnee = pr.getFormu().getChamp("annee").getValeur();
    String valId = pr.getFormu().getChamp("id").getValeur();
    String anneeTitre = (valAnnee != null && !valAnnee.trim().isEmpty()) ? valAnnee : anneeActuel;

    String titreGraph = "Statistique dépense en matière par mois pour l'année " + anneeTitre;

    if (valId != null && !valId.trim().isEmpty()) {
        titreGraph += " pour Id = " + valId + " et l'année" + anneeTitre;
    }
    pr.getFormu().getChamp("annee").setDefaut(anneeTitre);
    String description = "Statistique dépense en matière par mois pour l'année " + anneeTitre;
%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Statistique dépense en matière par mois</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getHtmlWithEvaluation(ConstanteAsync.API_URL, ConstanteAsync.API_KEY, titreGraph, description));
            %>
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <div class="row mt-4" style="margin-top: 20px;">
            <div class="col-md-4 mb-4" style="width: 60%">
                <div class="card h-100" style="
                        border-radius: 10px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        border: 1px solid #e0e0e0;
                        background-color: white;
                        padding: 1em">
                    <div class="card-body">
                        <h5 class="card-title text-center"><%= titreGraph %></h5>
                        <canvas id="graph_cheese"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </section>

</div>
<%
        String colAbs1 = "mois";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "mois", "depense")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese", "");
        g1.setTypeGraphe("bar");
        out.println(g1.getHtml("ctx1"));
    }catch(Exception e){

        e.printStackTrace();
    }
%>
