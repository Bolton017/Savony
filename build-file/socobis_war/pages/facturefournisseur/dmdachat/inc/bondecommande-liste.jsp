<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.DmdAchatFille" %>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %>

<%
    try{
        As_BonDeCommandeCpl t = new As_BonDeCommandeCpl();
        t.setNomTable("AS_BONDECOMMANDE_MERECPL");
        String[] listeCrt = {};
        String[] listeInt = {};
        String libEntete[] = {"id","daty","designation","modepaiementlib","fournisseurlib","remarque","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setAWhere(" AND idOrigine = '"+request.getParameter("id")+"'");
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=bondecommande/bondecommande-fiche.jsp", pr.getLien() + "?but=fournisseur/fournisseur-fiche.jsp"};
        String colonneModal[] = {"id"};
        String[] colonneLien = {"id", "fournisseurlib"};
        String[] attributLien = {"id", "id"};
        String[] valeurLien = {"id", "fournisseur"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setModalOnClick(true, colonneModal);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setValeurLien(valeurLien);
        pr.getTableau().setLienFille("bondecommande/inc/bondecommande-liste-detail.jsp&id=");
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"R&eacute;f&eacute;rence","Date","D&eacute;signation","Mode de paiement","Fournisseur","Remarque","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donne trouv&eacute;e</h4></center><%
    }

%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>