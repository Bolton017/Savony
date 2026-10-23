<%@page import="facture.tr.MvtIntraCaisseTraite"%>
<%@page import="affichage.PageRecherche"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    MvtIntraCaisseTraite mvt = new MvtIntraCaisseTraite();
    mvt.setNomTable("traiteversee");
    String libEntete[] = {"id","daty", "finaledestinationlib", "montant"};
    String listeCrt[] = {};
    String listeInt[] = {};

    PageRecherche pr = new PageRecherche(mvt, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    
    pr.setApres("facture/inc/versement.jsp");
    String[] colSomme = null;
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idtraite = '"+request.getParameter("id")+"' ");
    }
    pr.creerObjetPage(libEntete, colSomme);
    String libEnteteAffiche[] = {"Id","Date", "Caisse Finale", "Montant"};
    
    pr.getTableau().setLibeEntete(libEnteteAffiche);
    if(pr.getTableau().getHtml() != null){
        out.println(pr.getTableau().getHtml());
    }else{
        %><center><h4>Traite non transférée</h4></center><%
    }
%>
