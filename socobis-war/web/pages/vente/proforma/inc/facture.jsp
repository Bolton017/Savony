<%@page import="vente.VenteLib"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<% try{
    VenteLib bc = new VenteLib();
    bc.setNomTable("VENTE_CPL");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id", "designation","idClientLib","idDevise","daty","montantttc","montantRevient","margeBrute","montantpaye", "montantreste","etatlib","datyprevu"};
    String[] libEnteteAffiche = {"id", "D&eacute;signation","Client","devise","Date","Montant TTC","Montant de revient","marge Brute","Montant Pay&eacute;","Montant restant","&Eacute;tat","&Eacute;ch&eacute;ance"};
    System.out.println("coucoudqdsfkqsdfqsdf8779789789qsdfmkjqsdmfkljqsdmlfjqsd");
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setAWhere(" and idreservation='" + request.getParameter("idReservation")+"'");

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String[] lienTableau = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
%>
<div class="box-body">
    <% if (pr.getTableau().getHtml() != null) {
        out.println(pr.getTableau().getHtml());
    } else { %>
        <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <% } %>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




