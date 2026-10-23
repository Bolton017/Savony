
<%@page import="proforma.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="vente.BonDeCommandeCpl"%>

<%
  try {
    BonDeCommandeCpl t = new BonDeCommandeCpl();
    t.setNomTable("BONDECOMMANDE_CLIENT_CPL");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","daty","designation","idclientlib","idMagasinLib","modepaiementlib","reference","remarque","etatlib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if (request.getParameter("id") != null) {
      pr.setAWhere(" and idProforma='" + request.getParameter("id") + "'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=vente/bondecommande/bondecommande-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("vente/bondecommande/inc/bondecommande-liste-detail.jsp&id=");
//    pr.getTableau().setLienFille("bondecommande/inc/bondecommande-liste-detail.jsp&id=");
%>


<div class="box-body">
  <% String libEnteteAffiche[] = {"Ref.","Date","D&eacute;signation","Client","Magasin","Mode de paiement","R&eacute;f&eacute;rence","Remarque","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().getData();
    if (pr.getTableau().getHtml() != null) {
      out.println(pr.getTableau().getHtml());
    } else {
  %><center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center><%
  }


%>
</div>
<%    } catch (Exception e) {
  e.printStackTrace();
}%>

