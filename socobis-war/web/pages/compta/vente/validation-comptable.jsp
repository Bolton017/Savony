<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="caisse.MvtCaisseCpl" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="affichage.Liste" %>
<%@ page import="caisse.Caisse" %>

<% try{ 
    MvtCaisseCpl o = new MvtCaisseCpl();
    o.setNomTable("MOUVEMENTCAISSECPL_A_VALIDER");
    String[] listeCrt = {"id","daty","tiers","idCaisse", "idOrigine", "debit", "credit"};
    String[] listeInt = {"daty", "debit", "credit"};
    String[] libEntete = {"id","daty","tiers", "idCaisseLib","idOrigine","debit","credit"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste");

    affichage.Champ[] liste = new affichage.Champ[1];
    Caisse c = new Caisse();
    liste[0] = new Liste("idCaisse",c,"val","id");
    pr.getFormu().changerEnChamp(liste);

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compta/vente/validation-comptable.jsp");
    pr.getFormu().getChamp("id").setLibelle("R&eacute;f");
    pr.getFormu().getChamp("tiers").setLibelle("Tiers");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idCaisse").setLibelle("Tr&eacute;sorerie");
    pr.getFormu().getChamp("idOrigine").setLibelle("Origine");
    pr.getFormu().getChamp("debit1").setLibelle("D&eacute;bit Min");
    pr.getFormu().getChamp("debit2").setLibelle("D&eacute;bit Max");
    pr.getFormu().getChamp("credit1").setLibelle("Cr&eacute;dit Min");
    pr.getFormu().getChamp("credit2").setLibelle("Cr&eacute;dit Max");

    pr.setAWhere("order by ID desc ");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=caisse/mvt/mvtCaisse-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"R&eacute;f","Date","Tiers", "Tr&eacute;sorerie", "Origine","D&eacute;bit","Cr&eacute;dit"};
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

