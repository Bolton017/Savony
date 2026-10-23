<%-- 
    Document   : as-commande-analyse
    Created on : 30 d�c. 2016, 04:57:15
    Author     : Joe
--%>
<%@page import="vente.VenteLib"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.Calendar"%>
<%@ page import="faturefournisseur.ModePaiement" %>
<%
try{    
    VenteLib mvt = new VenteLib();
    String nomTable = "VENTE_CPL";
    mvt.setNomTable(nomTable);
    
    String listeCrt[] = {"id","daty","idDevise","idClientLib","idMagasin","modepaiement"};
    String listeInt[] = {"daty"};
    String[] pourcentage = {};
    String[] colGr = {"daty"};
    String[] colGrCol = {"idDevise"};
//    String somDefaut[] = {"qte", "puTotal", "puRevient"};
    String somDefaut[] = {"montanttotal", "montantreste"};
    
    PageRechercheGroupe pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, 2 , somDefaut.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String apreswhere = "";
    String debutSem=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
    if(request.getParameter("daty1")==null&&request.getParameter("daty2")==null)
    apreswhere= "and daty >= TO_DATE('"+debutSem+"','DD/MM/YYYY') and daty <= TO_DATE('"+utilitaire.Utilitaire.dateDuJour()+"','DD/MM/YYYY')";
    Calendar calendar = Calendar.getInstance();
    int month = calendar.get(Calendar.MONTH) + 1; // January is 0
    int year = calendar.get(Calendar.YEAR);
    String order = "";
    if(request.getParameter("order")!=null && request.getParameter("order").compareToIgnoreCase("")!=0){
        order+= (" "+ request.getParameter("order"));
    }
    String[] grouper = new String[1];
    if(request.getParameter("grouper")!=null && request.getParameter("grouper").compareToIgnoreCase("")!=0){
        grouper[0]=request.getParameter("grouper");
        pr.setColGroupeDefaut(grouper);
    }
    pr.setOrdre(order);
    pr.setAWhere(apreswhere);
    Liste[] liste = new Liste[2];
    liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
    ModePaiement mp = new ModePaiement();
    liste[1] = new Liste("modepaiement",mp,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("daty1").setDefaut(debutSem);
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idDevise").setLibelle("Devise");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("modepaiement").setLibelle("Mode paiement");
    pr.setNpp(500);
    pr.setApres("vente/vente-statistique.jsp");
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
    function alignTableCells() {
        const tbody = document.querySelector('tbody');
        if (!tbody) return;

        const rows = tbody.querySelectorAll('tr');

        rows.forEach((row) => {
            const cells = row.querySelectorAll('td');
            if (cells.length > 0) {
                cells[0].style.textAlign = 'center';
                cells[0].style.verticalAlign = 'middle';
            }
            if (cells.length > 1) {
                cells[1].style.textAlign = 'right';
            }
        });
    }
    document.addEventListener('DOMContentLoaded', alignTableCells);
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Analyse des ventes </h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=vente/vente-statistique.jsp" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <ul>
            <li>La premi&egrave;re ligne correspond au somme de montant total</li>
            <li>La deuxi&egrave;me ligne correspond au somme de montant reste</li>
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