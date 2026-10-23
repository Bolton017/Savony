<%-- 
    Author     : Safidy
--%>
<%@page import="fabrication.FabricationFilleCpl2"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.Calendar"%>

<%
try{    
    FabricationFilleCpl2 mvt = new FabricationFilleCpl2();
    String nomTable = "FABRICATIONFILLECPL2";
    mvt.setNomTable(nomTable);
    
    String listeCrt[] = {"id","idIngredientslib","daty"};
    String listeInt[] = {"daty"};
    String[] pourcentage = {};
    String[] colGr = {"idIngredientslib"};
    String[] colGrCol = {};
    //String somDefaut[] = {"qte", "puTotal", "puRevient"};
    String somDefaut[] = {"qte","revient"};
    
    PageRechercheGroupe pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String apreswhere = ""; 
    Calendar calendar = Calendar.getInstance();
    int month = calendar.get(Calendar.MONTH) + 1; // January is 0
    int year = calendar.get(Calendar.YEAR);
    if(request.getParameter("daty1") == null || request.getParameter("daty2") == null){
        apreswhere = " and daty <= '"+utilitaire.Utilitaire.dateDuJour()+"' and daty >= '"+String.format("01/%02d/%04d", month, year)+"'";
    }
    pr.setAWhere(apreswhere);
    pr.getFormu().getChamp("daty1").setDefaut(String.format("01/%02d/%04d", month, year));
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idIngredientslib").setLibelle("Ingredients");
    pr.setNpp(500);
    pr.setApres("fabrication/analyseFabrication-details.jsp");
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
        <h1>Analyse Details Fabrication</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=fabrication/analyseFabrication-details.jsp" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <ul>
            <li><strong>La premi&egrave;re ligne repr&eacute;sente la somme des quantit&eacute;s.</strong> </li>
            <li><strong>La deuxi&egrave;me ligne repr&eacute;sente la somme des revients .</strong></li>
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