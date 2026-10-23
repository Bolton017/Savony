<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Graphe" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="stat.EtatStockProduitFini" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="paie.analyse.AnalyseEffectifPersonnel" %>
<%@ page import="paie.categorie.CategoriePaie" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="bean.TypeObjet" %>


<% try{
    AnalyseEffectifPersonnel bdc = new AnalyseEffectifPersonnel();
    String listeCrt[] = {"idCategorie","idDepartement"};
    String listeInt[] = {};
    String libEntete[] = {};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/employe/analyse/effectif-personnel.jsp");

    Liste[] dropDowns = new Liste[2];
    CategoriePaie m = new CategoriePaie();
    m.setNomTable("CATEGORIE_PAIE");
    dropDowns[0] = new Liste("idCategorie", m, "val", "id");
    dropDowns[1] = new Liste("idDepartement", new TypeObjet("DEPARTEMENT"), "val", "id");

    pr.getFormu().changerEnChamp(dropDowns);

    pr.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);


    String titreGraph = "Graphique";
%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Répartition des Effectifs du Personnel</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <div class="row mt-4" style="margin-top: 20px;">
            <div class="col-md-12 mb-4">
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
        String colAbs1 = "sexe";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "sexe", "nombre")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese", "");
        g1.setCouleurs(ConstanteAsync.couleurs);
        g1.setBgCouleurs(ConstanteAsync.couleurs);
        g1.setTypeGraphe("bar");
        out.println(g1.getHtml("ctx1"));
    }catch(Exception e){

        e.printStackTrace();
    }
%>
