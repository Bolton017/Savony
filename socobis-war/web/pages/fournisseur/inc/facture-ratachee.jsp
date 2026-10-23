<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>

<% try{ 
    FactureFournisseurCpl o = new FactureFournisseurCpl();
    o.setNomTable("FACTUREFOURNISSEURCPL");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","designation","daty","montantreste"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    String awhere = " AND montantreste > 0";
    if(request.getParameter("id") != null){
        awhere += " AND idFournisseur='"+request.getParameter("id")+"'";
    }
    pr.setAWhere(awhere);
    pr.setTitre("Facture ratachee");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("facturefournisseur/inc/facture-ratachee.jsp");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","D&eacute;signation","Date","Montant restant","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<div class="box-body">

    <%  if(pr.getTableau().getHtmlWithCheckbox() != null) {  %>
        <form action="<%=pr.getLien() %>?but=ordredepaiement/ordredepaiement-saisie.jsp" method="post" name="factures" id="factures">
            <% out.println(pr.getTableau().getHtmlWithCheckbox()); %>
            <input name="idFournisseur" type="hidden" id="idFournisseur" value="<%=request.getParameter("id")%>">
        </form>
    <% } else{ %>
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
