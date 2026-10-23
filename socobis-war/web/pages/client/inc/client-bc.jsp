<%--
    Document   : historique.jsp
    Created on : 21 mars 2024, 15:15:01
    Author     : Angela
--%>


<%@page import="vente.VenteDetailsLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.BonDeCommandeCpl" %>


<%
    try{
        BonDeCommandeCpl t = new BonDeCommandeCpl();
        t.setNomTable("BONDECOMMANDE_CLIENT_CPL");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","remarque","designation","reference","modepaiementlib","daty","idclientlib","etatlib"};
        String libEnteteAffiche[] = {"Id","Remarque","D&eacute;signation","r&eacute;f&eacute;rence","Mode de paiement","Date","Client","Etat"};
//    id | desce | montantPayé | montantTTC | montantTVA
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idClient='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);


        String lienTableau[] = {pr.getLien() + "?but=vente/bondecommande/bondecommande-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%

        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donne trouvé</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>


