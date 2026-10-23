<%--
    Document   : historique.jsp
    Created on : 21 mars 2024, 15:15:01
    Author     : Angela
--%>


<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %>


<%
    try{
        As_BonDeCommandeCpl t = new As_BonDeCommandeCpl();
        t.setNomTable("AS_BONDECOMMANDE_MERECPL");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","daty","remarque","designation","modepaiementlib","fournisseurlib","etatlib"};;
        String libEnteteAffiche[] = {"ID","Date","Remarque","D&eacute;signation","Mode de paiement","Fournisseur","&Eacute;tat"};
//    id | desce | montantPayé | montantTTC | montantTVA
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and fournisseur='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);


        String lienTableau[] = {pr.getLien() + "?but=bondecommande/bondecommande-fiche.jsp"};
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


