<%-- 
    Document   : as-produits-liste
    Created on : 1 d�c. 2016, 10:39:44
    Author     : Joe
--%>
<%@page import="mg.allosakafo.produits.ProduitsTypeLibelle"%>
<%@page import="service.AlloSakafoService"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="mg.allosakafo.produits.ProduitsLibelle"%>
<%@page import="affichage.PageRecherche"%>

<% 
    try{
    ProduitsTypeLibelle lv = new ProduitsTypeLibelle();
    lv.setNomTable("PRODUITSLIST_LIB");
    lv.setNomtableCompte("DISPONIBILITE_PRODUIT");
    String listeCrt[] = {"nom","designation", "typeproduit","calorie"};
    String listeInt[] = null;
    String libEntete[] = {"id", "nom", "typeproduit", "calorie", "poids", "pu", "prixl","revientpoint","revientcentral","revient","taux"};  

    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("calorie").setLibelle("Dispo");

  affichage.Liste[] liste = new affichage.Liste[1];
    liste[0] = new Liste("calorie");
    String affiche[] = {"Disponible","Indisponible"};
    String valeur[] = {"DISPONIBLE","INDISPONIBLE"};
    liste[0].setValeurBrute(affiche);
    liste[0].setColValeurBrute(valeur);
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("calorie").setLibelle("Disponibilit�");
    pr.setAWhere(" and idpoint like '"+session.getAttribute("restaurant")+"'");

    pr.setApres("produits/as-produits-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>
<script>
    function changerDesignation() {
        document.incident.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste produits</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=produits/as-produits-liste.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

        </form>
        <%  String lienTableau[] = {pr.getLien() + "?but=produits/as-produits-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"Id", "Nom", "Type produit", "Disponibilite", "Poids", "Prix normal", "Prix Lounge","Revient point","Revient central","Revient","Taux"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());

        %>
    </section>
</div>
    <%}catch(Exception e){e.printStackTrace();}%>