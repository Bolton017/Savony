<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="production.ObjectifProductionLib" %>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>

<% try{ 
    ObjectifProductionLib o = new ObjectifProductionLib();
    o.setNomTable("objectifproductionlib");
    String[] listeCrt = {"id","idProduitLib","unite"};
    String[] listeInt = {};
    String[] libEntete = {"id","idProduitLib","qte","uniteLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des objectif du production");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("production/objectifProduction-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    Liste[] liste = new Liste[1];
    TypeObjet unite = new TypeObjet();
    unite.setNomTable("as_unite");
    liste[0] = new Liste("unite", unite, "val", "id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Produit","Quantit&eacute;","Unit&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=production/objectifProduction-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
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
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

