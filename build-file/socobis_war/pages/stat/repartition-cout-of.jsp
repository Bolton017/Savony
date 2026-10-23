<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Graphe" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="stat.*" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    RepartitionCoutOF bdc = new RepartitionCoutOF();
    String listeCrt[] = {"idMere"};
    String listeInt[] = {};
    String libEntete[] = {};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
//    pr.setAWhere(" order by moisint asc ");
    pr.getFormu().getChamp("idMere").setPageAppelComplete("fabrication.Of","id","Ofab","","");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stat/repartition-cout-of.jsp");

    pr.getFormu().getChamp("idMere").setLibelle("ID Ordre de Fabrication");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String valId = pr.getFormu().getChamp("idMere").getValeur();

    String titreGraph = "Statistique pour OF :";

    if (valId != null && !valId.trim().isEmpty()) {
        titreGraph += valId;
    }
%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Graphe en fromage - Répartition % coûts OF</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <div class="row mt-4" style="margin-top: 20px;">
            <div class="col-md-6 col-md-offset-3 mb-4">
                <div class="card h-100" style="
                        border-radius: 10px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        border: 1px solid #e0e0e0;
                        background-color: white;
                        padding: 1em">
                    <div class="card-body">
                        <h5 class="card-title text-center"><%= titreGraph %></h5>
                        <canvas id="pie"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </section>

</div>
<%
        String colAbs1 = "categorieingredient";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "categorieingredient", "montantsortie")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "pie", "");
        g1.setTypeGraphe("pie");
        out.println(g1.getHtml("ctx1"));
    }catch(Exception e){

        e.printStackTrace();
    }
%>
