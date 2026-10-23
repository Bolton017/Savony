<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 17/12/2025
  Time: 13:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>
<%
    try{
        FactureFournisseurCpl o = new FactureFournisseurCpl();
        o.setNomTable("FACTUREFOURNISSEURCPL_TRAVAUX");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idBc","designation","idFournisseurLib","idDevise","daty","montantttc","montantpaye", "montantreste", "dateEcheancePaiement","etatlib"};
        String libEnteteAffiche[] = {"R&eacute;f&eacute;rence", "idBc","D&eacute;signation","Fournisseur","devise","Date","Montant TTC","Montant pay&eacute;","Montant Restant", "date d'&Eacute;ch&eacute;ance de Paiement","&Eacute;tat"};
        PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt,4, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idTravaux='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><div style="text-align: center;"><h4>Aucun donn&eacute; trouv&eacute;</h4></div><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
