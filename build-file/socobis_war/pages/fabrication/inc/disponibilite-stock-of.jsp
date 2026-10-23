<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="fabrication.DisponibiliteStockOF" %>
<%@ page import="affichage.Liste"%>
<%@ page import="magasin.Magasin" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{ 
    DisponibiliteStockOF o = new DisponibiliteStockOF();
    String id= request.getParameter("id");
    String idMagasinLib = request.getParameter("filtreMagasin");
    String[] listeCrt = {"daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"idingredients","libingredients","quantite","reste","idMagasinLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    ((DisponibiliteStockOF) pr.getCritere()).setId(id);
    ((DisponibiliteStockOF) pr.getCritere()).setIdMagasinLib(idMagasinLib);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("fabrication/ordre-fabrication-fiche.jsp&id="+id+"&filtreMagasin="+idMagasinLib+"&tab=inc/disponibilite-stock-of");
    
    pr.getFormu().getChamp("daty1").setLibelle("Date");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setVisible(false);

    String[] colSomme = null;
    pr.setNpp(50);
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"ID composants","Nom composants","Quantit&eacute;","Reste","Magasin"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idingredients"};
    String attLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attLien);
    pr.getTableau().setColonneLien(colonneLien);
%>
<style>
    .mots-cless{
        display: none;
    }

</style>
<div class="body" style="margin-top: 20px; margin-left: 20px; margin-right: 20px;">
<%--    <section class="content">--%>
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
<%--    </section>/--%>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

