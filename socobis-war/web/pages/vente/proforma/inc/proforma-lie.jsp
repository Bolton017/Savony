
<%@page import="proforma.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="vente.BonDeCommandeCpl"%>

<%
  try {
    ProformaLib t = new ProformaLib();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","daty","idclientLib","idMagasinLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if (request.getParameter("id") != null) {
      Proforma pro = (Proforma) new Proforma().getById(request.getParameter("id"),"PROFORMA",null);
      pr.setAWhere(" and ( idorigine='" + request.getParameter("id") + "' or id='"+pro.getIdOrigine()+"' )");
      System.err.println(pr.getAWhere());
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=vente/proforma/proforma-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("vente/proforma/inc/proforma-detail-liste.jsp&id=");

%>

<div class="box-body">
  <%  String libEnteteAffiche[] = {"Id","Date","Client","Magasin"};
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

