<%--
    Document   : achat-analyse-fournisseur
    Created on : 5 ao�t 2024, 14:26:09
    Author     : soama
--%>

<%@page import="faturefournisseur.FactureFournisseurCpl"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.Calendar"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="maintenance.configuration.Entite" %>

<%
    try{
        FactureFournisseurCpl mvt = new FactureFournisseurCpl();
        String nomTable = "FACTUREFOURNISSEURAVECMACHINE";
        mvt.setNomTable(nomTable);

        String listeCrt[] = {"id","daty","idDevise","idFournisseurLib","idObjetLib","idEntite"};
        String listeInt[] = {"daty"};
        String[] pourcentage = {};
        String[] colGr = {"idObjetLib"};
        String[] colGrCol = {"idDevise"};
        //String somDefaut[] = {"qte", "puTotal", "puRevient"};
        String somDefaut[] = {"montantttc"};

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

        Liste[] liste = new Liste[1];
        Entite c = new Entite();
        liste[0] = new Liste("idEntite",c,"val","id");
        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(LocalDate.now().minusDays(7))));
        pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty1").setLibelle("Date Min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        pr.getFormu().getChamp("idFournisseurLib").setLibelle("Fournisseur");
        pr.getFormu().getChamp("idObjetLib").setLibelle("Machine");
        pr.getFormu().getChamp("idDevise").setLibelle("Devise");
        pr.getFormu().getChamp("idEntite").setLibelle("Cat&eacute;gorie");
        pr.setNpp(500);
        pr.setApres("maintenance/analyse/depense-machine.jsp");
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
        <h1>Analyse Achat Fournisseur</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=maintenance/analyse/depense-machine.jsp" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <!--        <ul>
                    <li>La premiere ligne correspond au quantite</li>
                    <li>La 2e ligne correspond au montant TTC total</li>
                </ul>-->
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
