<%-- 
    Document   : facture-bc
    Created on : 16 avr. 2025, 21:25:46
    Author     : maroussia
--%>

<%@page import="vente.VenteLib"%>
<%@page import="vente.Vente"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.Vente" %>

<% try{
    VenteLib bc = new VenteLib();
    bc.setNomTable("VENTE_LIB_BC");
    bc.setIdOrigine(request.getParameter("id"));

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "designation","idClientLib","idDevise","daty","montantttc","montantRevient","margeBrute","montantpaye", "montantreste","etatlib"};
    String libEnteteAffiche[] = {"id", "D&eacute;signation","Client","devise","Date","Montant TTC","montant Revient","marge Brute","Montant Pay&eacute;","Montant Reste","Etat"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setAWhere(" and IDORIGINE ='"+request.getParameter("id")+"' ");
    System.out.println(" and IDORIGINE ='"+request.getParameter("id")+"' ");

    
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/vente-liste.jsp");
    String[] colSomme = { "montantttc", "montantpaye", "montantreste","margeBrute" };

    pr.creerObjetPage(libEntete, colSomme);
  

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
%>
<script>
     function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="box-body">
    <%
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         %>
       <%
          } 
        else
            {
               %><center><h4>Aucune donn&eacute;e trouv&eacute;</h4></center><%
        }
    %>
            
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>