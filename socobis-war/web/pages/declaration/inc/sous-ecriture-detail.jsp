<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.sql.Date" %>

<% try{
    ComptaSousEcritureLib o = new ComptaSousEcritureLib();
    o.setNomTable("COMPTASOUSECRITURETVA");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete =  {"id", "numero","journal", "compte","daty", "moisdeclaration", "exercice","remarque","libellePiece", "debit", "credit","compte_aux"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    System.out.println(request.getParameter("datydebut"));
    Date datedebut = Utilitaire.stringDate(request.getParameter("datydebut"));
    int moisDebut = Utilitaire.getMois(datedebut);
    int anneeDebut = Utilitaire.getAnnee(datedebut);
    String awhere = " AND MOISDECLARATION=" + moisDebut +
        " AND EXERCICE = " + anneeDebut;
    if(request.getParameter("id") != null){
        pr.setAWhere(awhere);
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    String[] libEnteteAffiche =  {"ID", "Intitul&eacute;","Journal",  "Compte","Date", "Mois de d&eacuteclaration","Exercice", "Remarque","Libell&eacute;",  "D&eacute;bit", "Cr&eacute;dit","Compte Auxiliaire"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null){
        out.println(pr.getTableau().getHtml());
    } else{ %>
    <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>
