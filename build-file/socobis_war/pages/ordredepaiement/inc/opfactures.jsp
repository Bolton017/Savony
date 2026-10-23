<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="opfacture.OpFacture" %>

<% try{
    String idOp = request.getParameter("id");
    OpFacture o = new OpFacture();
    o.setNomTable("OPFACTURE");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idfacture","montant","daty"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if (idOp != null) {
        pr.setAWhere(" AND idop='" + idOp + "'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
     String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp"};
    String colonneLien[] = {"idfacture"}; 
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String[] urlLienMultiple = {"idfacture"};
    String[] urlLienAffiche = {"id"};
    pr.getTableau().setUrlLienAffiche(urlLienAffiche);
    pr.getTableau().setUrlLien(urlLienMultiple);
    String[] libEnteteAffiche = {"Id","Facture","Montant","Date"};
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

