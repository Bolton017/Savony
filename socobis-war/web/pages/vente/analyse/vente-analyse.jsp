<%--
    Document   : as-commande-analyse
    Created on : 30 d�c. 2016, 04:57:15
    Author     : Joe
--%>
<%@page import="utils.ConstanteAsync"%>
<%@page import="vente.VenteDetailsLib"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.Calendar"%>
<%@page import="magasin.Magasin"%>
<%@ page import="produits.CategorieIngredient" %>
<%--<%@ page import="annexe.TypeProduit" %>--%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="java.util.LinkedHashMap" %>

<%
    try {
        VenteDetailsLib mvt = new VenteDetailsLib();
        String nomTable = "VenteDetCalcRemGloVise";
        //t.setNomTable("VenteDetCalcRemGloVise");
        mvt.setNomTable(nomTable);

        String listeCrt[] = {"daty","idDevise","idDeviseLib","idCategorieLib","idProduitLib","idMagasin","idCategorie" , "idPoint", "idPointLib", "idprovince", "idprovincelib"};
        String listeInt[] = {"daty"};
        String[] pourcentage = {};
        String[] colGr = {"idProduitLib"};
        String[] colGrCol = {"idprovincelib"};
//    String somDefaut[] = {"qte", "puTotal", "puRevient"};
        String somDefaut[] = {"qte","montantTTCAr","montantRevient","margeBrute"};

        PageRechercheGroupe pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
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

        pr.getFormu().getChamp("daty1").setDefaut(debutSem);
        pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty1").setLibelle("Date Min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        pr.getFormu().getChamp("idCategorieLib").setVisible(false);
        pr.getFormu().getChamp("idDeviseLib").setVisible(false);
//        pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
//        pr.getFormu().getChamp("typeProduitLib").setVisible(false);

        String pageTitle = "Analyse des ventes selon le chiffre d'affaires";
        String grouperParam = request.getParameter("grouper");
        affichage.Champ[] liste =null;
        if (grouperParam != null) {
            liste = new affichage.Champ[2];
            liste[0] = new Liste("iddevise",new caisse.Devise(),"val","id");
            if (grouperParam.equals("idCategorieLib")) {
                pageTitle = "Analyse des ventes par cat&eacute;gorie";
                CategorieIngredient cat= new CategorieIngredient();
                liste[1] = new Liste("idCategorie", cat, "VAL", "id");
                pr.getFormu().getChamp("idMagasin").setVisible(false);
            }
            if (grouperParam.equals("idMagasinLib")) {
                pageTitle = "Analyse des ventes par magasin";
                Magasin magasin = new Magasin();
                magasin.setNomTable("magasin2");
                liste[1] = new Liste("idMagasin",magasin,"val","id");
                pr.getFormu().getChamp("idCategorie").setVisible(false);
            }

//            if (grouperParam.equals("typeProduitLib")) {
//                pageTitle = "Analyse des ventes par type produit";
//                TypeProduit tp = new TypeProduit();
//                tp.setNomTable("TYPE_PRODUIT");
//                liste[1] = new Liste("typeProduit",tp,"val","id");
//            }

            if (grouperParam.equals("idprovincelib")) {
                pageTitle = "Analyse des ventes par zone";
                TypeObjet pro = new TypeObjet();
                pro.setNomTable("PROVINCE");
                liste[1] = new Liste("idprovince",pro,"val","id");
            }



            if (grouperParam.equals("idProduitLib")) {
                pageTitle = "Analyse des ventes par Produit";
                TypeObjet p = new TypeObjet();
                p.setNomTable("point");
                liste[1] = new Liste("idPoint",p,"val","id");
            }

        }else{
            liste = new affichage.Champ[1];
            liste[0] = new Liste("iddevise",new caisse.Devise(),"val","id");
            pr.getFormu().getChamp("idCategorie").setVisible(false);
            pr.getFormu().getChamp("idMagasin").setVisible(false);
        }
        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pr.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");
        pr.getFormu().getChamp("idDevise").setLibelle("Devise");
        pr.getFormu().getChamp("idPoint").setLibelle("Point");
        pr.getFormu().getChamp("idPointLib").setVisible(false);
//        pr.getFormu().getChamp("typeProduit").setLibelle("Type produit");

        pr.getFormu().getChamp("idPoint").setVisible(false);
//        pr.getFormu().getChamp("typeProduit").setVisible(false);
        pr.getFormu().getChamp("idProvince").setVisible(false);

        pr.setNpp(500);
        String apres = "vente/vente-analyse.jsp";
        String daty1,daty2;
        if(request.getParameter("daty1") == null || request.getParameter("daty2") == null){
            daty2 = utilitaire.Utilitaire.dateDuJour();
            daty1 = debutSem;
        }else{
            daty1=request.getParameter("daty1");
            daty2=request.getParameter("daty2");
        }
        LinkedHashMap<String, String[]> rubriquesAnalyse = new LinkedHashMap<>();
        rubriquesAnalyse.put("Produit", new String[]{
                "idProduitLib",
                "idCategorieLib",
//                "typeProduitLib",
                "idModeleLib",
                "idCategorieModelLib",
                "idSousCategorieLib",
                "pointure"
        });
        rubriquesAnalyse.put("Finance", new String[]{"qte", "montantTTCAr", "montantRevient", "montanttotal","margeBrute"});
        rubriquesAnalyse.put("Zone", new String[]{"idprovincelib", "idPointLib","idMagasinLib"});
        rubriquesAnalyse.put("Autre", new String[]{"idDeviseLib","daty", "libelle_mois", "annee","idclientlib"});

        String[] colonnesSommeAutorisees = {
                "qte",  "montantTTCAr", "puRevient", "montanttotal"
        };
        pr.setRubriquesAnalyse(rubriquesAnalyse);
        //pr.setColonnesSommeAutorisees(colonnesSommeAutorisees);
        pr.setColonnesSommeAutorisees(somDefaut);
        pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=vente/vente-details-liste.jsp&daty1="+daty1+"&daty2="+daty2);
        String type = request.getParameter("grouper");
        String titre = "Analyse des ventes par chiffre d'affaires";
        String desce = "Analyse des ventes par chiffre d'affaires";
        if (type != null && !type.trim().isEmpty()) {
            if(type.compareToIgnoreCase("idMagasinLib")==0){
                titre = "Analyse des ventes par magasin";
                desce = "Analyse des ventes par magasin";
            }
            if(type.compareToIgnoreCase("idCategorieLib")==0){
                titre = "Analyse des ventes par cat&eacute;gorie";
                desce = "Analyse des ventes par cat&eacute;gorie";
            }
//            if(type.compareToIgnoreCase("typeProduitLib")==0){
//                titre = "Analyse des ventes par type produit";
//                desce = "Analyse des ventes par type produit";
//                pr.getFormu().getChamp("idCategorie").setVisible(false);
//            }
            if(type.compareToIgnoreCase("idPointLib")==0){
                titre = "Analyse des ventes par point";
                desce = "Analyse des ventes par point";
                pr.getFormu().getChamp("idCategorie").setVisible(false);
            }
            if(type.compareToIgnoreCase("idprovincelib")==0 || type.compareToIgnoreCase("idprovince")==0){
                titre = "Analyse des ventes par zone";
                desce = "Analyse des ventes par zone";
                pr.getFormu().getChamp("idCategorie").setVisible(false);
            }
            apres += "&grouper="+type ;
        }
        pr.setApres(apres);



%>
<div class="content-wrapper">
    <section class="content-header">
        <h1 id="page-title"><%= pageTitle %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%=apres%>" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <ul>
            <li>La premi&egrave;re ligne correspond &agrave; la quantit&eacute;</li>
            <li>La deuxi&egrave;me ligne correspond au montant total</li>
        </ul>
        <%
            String lienTableau[] = {};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(somDefaut);%>
        <br>
        <%
            out.println(pr.getHtmlWithEvaluation(ConstanteAsync.API_URL, ConstanteAsync.API_KEY, titre, desce));
            out.println(pr.getTableauRecap().getHtml());
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<%
    }
%>
<%--<script>--%>
<%--    function changerDesignation() {--%>
<%--        document.analyse.submit();--%>
<%--    }--%>
<%--    $(document).ready(function() {--%>
<%--        $('.box table tr').each(function() {--%>
<%--            $(this).find('td:last, th:last').hide();--%>
<%--        });--%>
<%--    });--%>
<%--    function alignTableCells() {--%>
<%--        const tbody = document.querySelector('tbody');--%>
<%--        if (!tbody) return;--%>

<%--        const rows = tbody.querySelectorAll('tr');--%>

<%--        rows.forEach((row) => {--%>
<%--            const cells = row.querySelectorAll('td');--%>
<%--            if (cells.length > 0) {--%>
<%--                cells[0].style.textAlign = 'center';--%>
<%--                cells[0].style.verticalAlign = 'middle';--%>
<%--            }--%>
<%--            if (cells.length > 1) {--%>
<%--                cells[1].style.textAlign = 'right';--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>
<%--    document.addEventListener('DOMContentLoaded', alignTableCells);--%>
<%--</script>--%>
