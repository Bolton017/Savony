<%--
    Document   : produit-fiche
    Created on : 21 mars 2024, 09:44:57
    Author     : Angela
--%>

<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    TypeObjet t = new TypeObjet();
    t.setNomTable("poste");
    String listeCrt[] = {"id", "val","desce"};
    String listeInt[] = {};
    String libEntete[] = {"id", "val", "desce"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des postes");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("annexe/poste/poste-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=annexe/poste/poste-modif.jsp");
    lienTab.put("supprimer",pr.getLien() + "?but=apresTarif.jsp&id=" + pr.getFormu().getChamp("id").getValeur()+"&acte=delete&bute=annexe/poste/poste-liste.jsp&classe="+t.getClass().getName()+"");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=annexe/poste/poste-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "D&eacute;signation", "Description"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=annexe/poste/poste-saisie.jsp&currentMenu=MNDN000000011061117\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un poste</a>"
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



