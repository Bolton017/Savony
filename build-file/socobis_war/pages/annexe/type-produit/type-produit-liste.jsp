<%-- 
    Document   : type-produit-recherche
    Created on : 26 janv. 2024, 10:25:56
    Author     : Angela
--%>




<%@page import="annexe.TypeProduit"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>

<% try{ 
    TypeProduit t = new TypeProduit();
    t.setNomTable("Type_Produit");
    String listeCrt[] = {"id", "val","desce"};
    String listeInt[] = {};
    String libEntete[] = {"id", "val", "desce"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des types de produit");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("annexe/type-produit/type-produit-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=annexe/type-produit/type-produit-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);


    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=annexe/type-produit/type-produit-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence", "D&eacute;signation", "Description"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=annexe/type-produit/type-produit-saisie.jsp&currentMenu=MNDN000000021111121\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un type de produit</a>"
    );
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



