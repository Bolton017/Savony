<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mg.cnaps.compta.ecriture.ComptaEcritureLib" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="utilitaire.*"%>
<%
    ComptaEcritureLib ecr = new ComptaEcritureLib();
    String dateJour = utilitaire.Utilitaire.dateDuJour();
    ecr.setNomTable("compta_ecriture_lib");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","daty","tierslib","designation", "piece","reference","idObjet","source","montant","journallib","etatlib"};
    PageRecherche pr = new PageRecherche(ecr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and journal='"+request.getParameter("id")+"' and trunc(daty)=TO_DATE('"+dateJour+"','DD/MM/YYYY')");
    }
    pr.setApres("#");
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    String origineLien =  pr.getLien() + "?but=compta/ecriture/apresOrigine.jsp";
    String lienTableau[] = {pr.getLien() + "?but=compta/ecriture/ecriture-fiche.jsp", origineLien};
    String colonneLien[] = {"id","idObjet"};
    pr.getTableau().setAttLien(new String[]{"id","id"});
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("compta/ecriture/inc/sous-ecriture-detail.jsp&id=");
    int nombreLigne = pr.getTableau().getData().length;
    String libEnteteAffiche[] = {"Ref.", "Date", "Tiers", "Libell&eacute;", "Num&eacute;ro de la facture","R&eacute;f&eacute;rence", "Ref. source", "Source", "Montant", "Journal", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<%
    if (pr.getTableau().getHtml() != null) {
        out.println(pr.getTableau().getHtml());
        out.println(pr.getBasPage());
    } else {
%>
<div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div>
<%
    }
%>

