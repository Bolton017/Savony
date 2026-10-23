<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-04-29
  Time: 22:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="affichage.PageRecherche"%>
<%@ page import="fabrication.BcGroupeIng" %>

<% try{
    BcGroupeIng t = new BcGroupeIng();
    t.setNomTable("BC_GROUPE_ING");
    String listeCrt[] = {"libelleProduit", "qteOfRestante"};
    String listeInt[] = {"qteOfRestante"};
    String libEntete[] = {"produit", "libelleProduit", "qteOfRestante"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des commandes");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("fabrication/ordre-fabrication-multiple.jsp");
    pr.getFormu().getChamp("qteOfRestante1").setLibelle("Quantit&eacute; min");
    pr.getFormu().getChamp("qteOfRestante2").setLibelle("Quantit&eacute; max");
    pr.getFormu().getChamp("libelleProduit").setLibelle("Produit");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=fabrication/inc/detail-bc.jsp"};
    String colonneLien[] = {"produit"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("fabrication/inc/detail-bc.jsp&produit=");
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"ID Produit", "Nom", "Quantit&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    //Variables de navigation
    String butApresPost = "fabrication/ordre-fabrication-fiche.jsp";
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <form class='container' action="<%=pr.getLien()%>?but=apres-fabrication-multiple.jsp" method="post" >
            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
                out.println(pr.getBasPage());
            %>
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        </form>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>

