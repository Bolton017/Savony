<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="vente.VenteDetailsCpl" %>

<% try{ 
    VenteDetailsCpl o = new VenteDetailsCpl();
    o.setNomTable("VENTE_DETAILS_CPL");
    String[] listeCrt = {"id","montant","idProduitLib","idclientlib","qte","pu","montantttc"};
    String[] listeInt = {"pu","montantttc"};
    String[] libEntete = {"id","idProduitLib","montantttc","qte"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des ventes ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/venteDirect/venteDirecte-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("montant").setLibelle("Montant");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pr.getFormu().getChamp("pu1").setLibelle("Prix unitaire min");
    pr.getFormu().getChamp("pu2").setLibelle("Prix unitaire max");
    pr.getFormu().getChamp("montantttc1").setLibelle("Montant TTC min");
    pr.getFormu().getChamp("montantttc2").setLibelle("Montant TTC max");
    
    String[] colSomme = {"montantttc","qte","pu"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme des montants TTC","Somme des quantit&eacute;s","Somme des prix unitaires"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=vente/venteDirect/venteDirecte-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Produit","Montant TTC","Quantit&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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

