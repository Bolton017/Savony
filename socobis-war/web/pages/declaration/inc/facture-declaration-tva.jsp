<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="faturefournisseur.FactureDeclarationCpl" %>

<% try{ 
    FactureDeclarationCpl o = new FactureDeclarationCpl();
    o.setNomTable("FACTUREDECLARATIONCPL");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","reference","designation","idFournisseurLib","devise","daty","montantttcAr","montantpaye","montantreste","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));



    String awhere = " AND idObjet = '" + request.getParameter("id")+"'";
    System.err.println("=========================================="+awhere);
    if(request.getParameter("id") != null){
        pr.setAWhere(awhere);
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturedeclaration-fiche.jsp"};
    String colonneLien[] = {"id"};
    String attLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attLien);
    pr.getTableau().setColonneLien(colonneLien);

    String[] libEnteteAffiche = {"ID","R&eacute;f&eacute;rence","D&eacute;signation","Fournisseur","Devise","Date","Montant ","Montant pay&eacute;","Montant restant","&Eacute;tat"};
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

