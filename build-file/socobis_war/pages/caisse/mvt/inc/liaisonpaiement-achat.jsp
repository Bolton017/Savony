<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paiement.LiaisonPaiementAchat" %>

<% try{
    String id1 = (String)request.getParameter("id1");
    LiaisonPaiementAchat o = new LiaisonPaiementAchat();
    o.setNomTable("V_LIAISONPAIEMENT_FACTUREFOURN");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idfacturefournisseur","designation","montant","daty"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setAWhere(" and id1 ='"+ id1 + "'");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp"};
    String[] colonneLien = {"idfacturefournisseur"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setLienFille("facturefournisseur/inc/facture-fournisseur-liste-detail.jsp&id=");

    String[] libEnteteAffiche = {"ID Facture fournisseur","D&eacute;signation","Montant(Ar)","Date"};
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

