<%-- 
    Document   : as-commande-analyse
    Created on : 30 d�c. 2016, 04:57:15
    Author     : Joe
--%>
<%@page import="faturefournisseur.*"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="java.util.LinkedHashMap" %>


<%
    try{
        FactureFournisseurDetailsCpl mvt = new FactureFournisseurDetailsCpl();
        String nomTable = "FFFILLECPL_MONTANT";
        mvt.setNomTable(nomTable);

        String listeCrt[] = {"daty","idpointlib"};
        String listeInt[] = {"daty"};
        String[] pourcentage = {};
        String[] colGr = {"idproduitlib"};
        String[] colGrCol = {"idpointlib"};
        //String somDefaut[] = {"qte", "montanttotal"};
        String somDefaut[] = {"qte", "montanttotal"};
        String order = "";

        PageRechercheGroupe pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String apreswhere = "";
        if(request.getParameter("daty1") == null || request.getParameter("daty2") == null){
            apreswhere = "and daty = '"+utilitaire.Utilitaire.dateDuJour()+"'";
        }
        if(request.getParameter("order")!=null && request.getParameter("order").compareToIgnoreCase("")!=0){
            order+= (" "+ request.getParameter("order"));
        }
        pr.setOrdre(order);
        pr.setAWhere(apreswhere);
        pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty1").setLibelle("Date Min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        Liste[] liste = new Liste[1];
        TypeObjet point= new TypeObjet();
        point.setNomTable("POINT");
        liste[0] = new Liste("idpointlib",point,"val","val");
//    TypeObjet cat= new TypeObjet();
//    cat.setNomTable("CATEGORIE");
//    liste[1] = new Liste("idcategorielib",cat,"val","val");
        pr.getFormu().changerEnChamp(liste);
//    pr.getFormu().getChamp("idcategorielib").setLibelle("Cat&eacute;gorie");
        pr.getFormu().getChamp("idpointlib").setLibelle("Magasin");
        pr.setNpp(500);
        pr.setApres("facturefournisseur/achat-analyse.jsp");
        LinkedHashMap<String, String[]> rubriquesAnalyse = new LinkedHashMap<>();

        rubriquesAnalyse.put("Produit", new String[]{
                "idProduitLib",
//                "idProduit",
                "idCategorieLib"
        });

        rubriquesAnalyse.put("Finance", new String[]{
                "qte",
                "pu",
                "montanttotal",
                "remises",
                "tva"
        });

        rubriquesAnalyse.put("Magasin / Point", new String[]{
                "idMagasinLib",
                "idPointLib"
        });

        rubriquesAnalyse.put("Autre", new String[]{
                "daty",
        });


        String[] colonnesSommeAutorisees = {
                "qte",
                "pu",
                "montanttotal",
                "remises",
                "tva"
        };

        pr.setRubriquesAnalyse(rubriquesAnalyse);
        pr.setColonnesSommeAutorisees(colonnesSommeAutorisees);
        pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=facturefournisseur/facturefournisseur-liste.java");
%>
<script>
    function changerDesignation() {
        document.analyse.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Analyse d&apos;Achat par d&eacute;pense</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=facturefournisseur/achat-analyse.jsp" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <ul>
            <li>La premi&egrave;re ligne correspond &agrave; la quantit&eacute;</li>
            <li>La 2&egrave;me ligne correspond au montant total</li>
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