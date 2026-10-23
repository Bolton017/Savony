<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetailsCpl" %>

<% try{
    String idproforma = request.getParameter("id");
    ProformaFournisseurDetailsCpl o = new ProformaFournisseurDetailsCpl();
    o.setNomTable("PROFORMAFOURNISSEURDETAILSCPL2");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"produit", "produitlib", "quantite","unitelib","pu","iddevise", "remise","remiseMontant" ,"montantht", "tauxdechange"};

    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setAWhere(" and idmere = '"+idproforma+"'");


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String[] colonneModal = {"produit"};
    String[] colonneLien = {"produit"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setModalOnClick(true, colonneModal);

    String[] libEnteteAffiche = {"Id produit", "Produit", "Quantit&eacute;","Unit&eacute;","Prix unitaire", "Devise","Remise en %", "Remise en Montant",  "Montant HT","Taux de change"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        } else{ %>
            <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>
<%=pr.getModalHtml("modalContent")%>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

