<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    ComptaSousEcritureLib t = new ComptaSousEcritureLib();
//    t.setNomTable("COMPTA_SOUSECRITURE_ECRITURE");
    t.setNomTable("COMPTA_SOUSECRITURE_LIB");
    String listeCrt[] = {};
    String listeInt[] = {};
//    String libEntete[] = {"id", "numero","journal", "compte","daty","remarque","debit", "credit","compte_aux"};
    String libEntete[] =  {"daty","libellePiece", "compte", "numero","remarque", "debit", "credit","compteauxiliaire","compte_auxlib","analytique"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idobjet='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
    String lienTableau[] = {pr.getLien() + "?but=compta/lien-fiche.jsp&type=compte",pr.getLien() + "?but=compta/lien-fiche.jsp&type=compte_aux"};
    String colonneLien[] = {"compte","compteauxiliaire"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
//         String libEnteteAffiche[] =  {"ID", "Libell&eacute; de Compte","Journal",  "Compte","Date","Remarque",  "D&eacute;bit", "Cr&eacute;dit","Compte Auxiliaire"};
        String libEnteteAffiche[] =  {"Date","Piece","Compte","Intitul&eacute;",  "Libell&eacute;",  "D&eacute;bit", "Cr&eacute;dit","Compte Auxiliaire","intitul&eacute; Auxiliaire","Analytique"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        ComptaSousEcritureLib[] liste=(ComptaSousEcritureLib[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         }else
         {
               %><center><h4>Aucune donne trouvee</h4></center><%
         }

        
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>