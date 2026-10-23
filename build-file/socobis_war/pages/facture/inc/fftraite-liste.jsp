<%-- 
    Document   : client-quit-liste
    Created on : 31 oct. 2022, 12:14:22
    Author     : NAEPHA
--%>

<%@page import="java.sql.Date"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="facture.tr.Traite"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="vente.VenteLib" %>
<%@ page import="vente.VenteLibTraite" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    try {
        VenteLibTraite base = new VenteLibTraite();
        base.setNomTable("TRAITE_FCsum");

        String listeCrt[] = {"idTraite"};
        String listeInt[] = {};
        String libEntete[] = {"id", "factureclientlib", "tierslib", "daty", "montantfacture","montanttraite", "etatLib"};

        PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        pr.getFormu().getChamp("idtraite").setLibelle("Traite");

        pr.setApres("facture/inc/fftraite-liste.jsp");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        String libEnteteAffiche[] = {"id", "Note Explicative", "Tiers", "Date", "Montant","Montant Traite", "Etat"};
        String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibeEntete(libEnteteAffiche);
        if (pr.getTableau().getHtml() != null) {
%>
<script>
    function changerDesignation() {
        document.liste.submit();
    }
</script>
<section class="content">
    <%
        out.println(pr.getTableau().getHtml());
    } else {
    %><center><h4>Pas de facture client</h4></center><%
                }
        %>
</section>
<% } catch (Exception e) {
        e.printStackTrace();
    }%>

