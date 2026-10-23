<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    ComptaSousEcritureLib t = new ComptaSousEcritureLib();
    t.setNomTable("COMPTA_SOUSECRITURE_LIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"idMere","daty","libellePiece", "compte", "numero","remarque", "debit", "credit","analytique"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idobjet='"+request.getParameter("id")+"'");
    }
    pr.setAWhere(pr.getAWhere() + " order by compte desc");
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
    String lienTableau[] = {pr.getLien() + "?but=compta/ecriture/ecriture-fiche.jsp",pr.getLien() + "?but=compta/lien-fiche.jsp&type=compte",pr.getLien() + "?but=compta/lien-fiche.jsp&type=compte_aux"};
    String colonneLien[] = {"idMere","compte","compteauxiliaire"};
    String attlien[] = {"id","compte","compteauxiliaire"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attlien);
    pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
         String libEnteteAffiche[] =  {"R&eacute;f&eacute;rence","Date","Piece","Compte","Intitul&eacute;",  "Libell&eacute;",  "D&eacute;bit", "Cr&eacute;dit","Analytique"};
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