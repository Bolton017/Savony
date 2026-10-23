<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="client.ZoneClient" %>

<% try{ 
    ZoneClient o = new ZoneClient();
    o.setNomTable("ZONECLIENT");
    String[] listeCrt = {"val"};
    String[] listeInt = {};
    String[] libEntete = {"id","val","desce","forfait","prixcarton","mincarton"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Listes des zones de livraisons");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("client/zone/zone-liste.jsp");
    pr.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=client/zone/zone-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Libell&eacute;","Description","Frais de livraison","Prix par carton","Carton minimal"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    pr.getFormu().setAnotherButton(
                    "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=client/zone/zone-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir une zone\n" +
                    "                </a>"
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

