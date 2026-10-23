<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paramCompta.ParamCompta" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    TypeObjet o = new TypeObjet();
    o.setNomTable("PARAMCOMPTA");
    String[] listeCrt = {"id","val","desce"};
    String[] listeInt = {};
    String[] libEntete = {"id","val","desce"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compta/paramCompta/paramCompta-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("R&eacute;f.");
    pr.getFormu().getChamp("val").setLibelle("Valeur");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=compta/paramCompta/paramCompta-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String[] libEnteteAffiche = {"R&eacute;f.","Valeur","Description"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=compta/paramCompta/paramCompta-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un param&egrave;tre de comptabilit&eacute;</a>"
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

