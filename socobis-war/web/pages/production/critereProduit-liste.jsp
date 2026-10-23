<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="production.CritereProduitLib" %>

<% try{ 
    CritereProduitLib o = new CritereProduitLib();
    o.setNomTable("CRITEREPRODUITLIB");
    String[] listeCrt = {"id","idcriterelib","idtypeproduitlib"};
    String[] listeInt = {};
    String[] libEntete = {"id","idcriterelib","idtypeproduitlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des crit&egrave;res produits");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("production/critereProduit-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idcriterelib").setLibelle("Crit&egrave;re");
    pr.getFormu().getChamp("idtypeproduitlib").setLibelle("Type de produit");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Crit&egrave;re","Type produit"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=production/critereProduit-fiche.jsp"};
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

