<%@page import="fabrication.FabricationFilleCpl2"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.Calendar"%>
<%@ page import="produits.AnalyseCarte" %>

<%
    try{
        AnalyseCarte mvt = new AnalyseCarte();
        String nomTable = "ANALYSE_CARTE";
        mvt.setNomTable(nomTable);

        String listeCrt[] = {"vehicule"};
        String listeInt[] = {};
        String[] pourcentage = {};
        String[] colGr = {"vehicule"};
        String[] colGrCol = {};
        //String somDefaut[] = {"qte", "puTotal", "puRevient"};
        String somDefaut[] = {"entree","sortie"};

        PageRechercheGroupe pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String apreswhere = "";
        Calendar calendar = Calendar.getInstance();
        int month = calendar.get(Calendar.MONTH) + 1; // January is 0
        int year = calendar.get(Calendar.YEAR);

        pr.setNpp(500);
        pr.setApres("carteCarburant/analyse-vehicule.jsp");
        pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=");
%>
<script>
    function changerDesignation() {
        document.analyse.submit();
    }
    $(document).ready(function() {
        $('.box table tr').each(function() {
            $(this).find('td:last, th:last').hide();
        });
    });
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Montant Carte par vehicule</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=fabrication/analyseFabrication-details.jsp" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <ul>
            <li><strong>La premi&egrave;re ligne repr&eacute;sente la somme des entr&eacute;es.</strong> </li>
            <li><strong>La deuxi&egrave;me ligne repr&eacute;sente la somme des sorties .</strong></li>
        </ul>
        <%
            String lienTableau[] = {};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(somDefaut);%>
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