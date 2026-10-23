<%--
    Document   : achat-analyse-fournisseur
    Created on : 5 ao�t 2024, 14:26:09
    Author     : soama
--%>

<%@page import="faturefournisseur.FactureFournisseurCpl"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.Calendar"%>
<%@ page import="besoin.BesoinFabricationDetailsCPL" %>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // On cherche tous les spans dans les cellules
        document.querySelectorAll('td span').forEach(span => {
            // Si le texte est exactement "1"
            if (span.textContent.trim() === "1") {
                // On remonte jusqu'à la ligne (tr) pour cacher toute la rangée
                let ligne = span.closest('tr');
                if (ligne) {
                    ligne.style.display = 'none';
                }
            }
        });
    });
</script>
<%
    try{
        BesoinFabricationDetailsCPL mvt = new BesoinFabricationDetailsCPL();
//        String nomTable = "BESFABDETRECETTEGBIng";
        String nomTable = "BESFABDETRECETTEGBIngComp";
        mvt.setNomTable(nomTable);

        String listeCrt[] = {"annee","idProduitLib", "mois"};
        String listeInt[] = {""};
        String[] pourcentage = {};
        String[] colGr = {"idProduitLib"};
        String[] colGrCol = {"moisanneeLib", "mois"};
        String somDefaut[] = {"qte"};

        PageRechercheGroupe pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String apreswhere = "";
        Calendar calendar = Calendar.getInstance();
        int month = calendar.get(Calendar.MONTH) + 1;
        int year = calendar.get(Calendar.YEAR);

        affichage.Champ[] liste = new Champ[1];
        Liste mois1 = new Liste("mois");
        mois1.makeListeMois();
        liste[0] = mois1;
        pr.getFormu().changerEnChamp(liste);

        pr.setAWhere(apreswhere);
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        //pr.getFormu().getChamp("idProduitLib").setVisible(false);
        pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
        pr.setNpp(500);
        pr.setOrdre("order by mois asc");
        pr.setApres("besoin/besoinFabrication-liste.jsp");
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
        <h1>Analyse de besoin par mati&egrave;res premi&egrave;res</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=besoin/besoinFabrication-matierepremiere.jsp" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <ul>
            <li>La premi&egrave;re ligne correspond &aacute; la quantit&eacute;</li>
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