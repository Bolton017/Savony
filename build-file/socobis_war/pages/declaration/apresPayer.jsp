<%@page import="paiement.*" %>
<%@page import="user.UserEJB" %>
<%@page import="utilitaire.*" %>
<%@ page import="declaration.DeclarationTva" %>
<%@ page import="faturefournisseur.FactureDeclaration" %>
<%@ page import="faturefournisseur.FactureDeclarationDetails" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<% try {
    UserEJB u = (UserEJB) session.getAttribute("u");
    String lien = (String) session.getAttribute("lien");
    DeclarationTva dtva = new DeclarationTva();
    dtva.setId(request.getParameter("id"));
    FactureDeclaration facture = dtva.genererFactureDeclaration(u.getUser().getTuppleID(),null);
    FactureDeclarationDetails [] details = facture.getDetails(null);
    String redirection = lien+"?but=caisse/mvt/mvtCaisse-saisie-sortie-fc.jsp&idDeclaration="+facture.getId()+"&devise=AR&montant="+facture.getMontantttc()+"&tiers=FRNETAT&idPrevision=null";
    System.err.println("============ASAAAAAAAAAAAAAAAAAAAAAAAAS============="+facture.getIdBc()+"=================");
    if(facture.getIdBc()!=null && facture.getIdBc().compareToIgnoreCase("CREDIT")==0){
        redirection = lien+"?but=declaration/fiche-declaration-tva.jsp&id="+request.getParameter("id");
    }
%>
<script> document.location.replace("<%=redirection%>");</script>
<%  } catch (Exception e) {
    e.printStackTrace(); %>
    <script>
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% } %>



