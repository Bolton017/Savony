<%-- 
    Document   : congeDroit-liste
    Created on : 1 d�c. 2020, 09:42:10
    Author     : mariano
--%>

<%@page import="paie.employe.EmployeComplet2"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.demande.DemandeJustificationsComplet" %>

<%
    paie.demande.DemandeJustificationsComplet dj = new DemandeJustificationsComplet();
    dj.setNomTable("demande_libcomplet2");
    
    String libEntete[] = {"id", "personnel", "matricules", "typeabsencelib","datefin", "duree", "etatlib"};
    String listeCrt[] = {"personnel"};
    String listeInt[] = {};
    PageRecherche pr = new PageRecherche(dj, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    
    pr.getFormu().getChamp("personnel").setLibelle("Nom employ�");
  //  pr.getFormu().getChamp("matricule").setLibelle("mat");
   
    pr.setApres("demande/demande-absence-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>

<%  String lienTableau[] = {pr.getLien() + "?but=paie/demande/demande-absence-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    
    String libEnteteAffiche[] = {"ID", "Employ&eacute", "Matricule", "Type d'absence", "Date de fin","Nombre de jours", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    out.println(pr.getTableau().getHtml());
%>


