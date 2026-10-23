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
    String libEntete[] =  {"daty","libellePiece", "compte", "numero","remarque", "debit", "credit","compteauxiliaire","compte_auxlib","lettre","analytique"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setApjSplitEnabled(false);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String awhere="";
    if (request.getParameter("id") != null) {
        String id = request.getParameter("id");
        if (id.startsWith("ECR")) {
            awhere = " and idMere='" + id + "'";
        } else if (id.startsWith("LET")) {
            awhere = " and lettrage='" + id + "'";
        } else {
            awhere = " and idobjet='" + id + "'";
        }
    }
    pr.setAWhere(awhere);
    pr.setOrdre(" order by compte desc");
    pr.setApres("compta/ecriture/ecriture-fiche.jsp");
    pr.setApresLienPage("&id=" + request.getParameter("id") + "&tab=inc/sous-ecriture-detail");
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
         String libEnteteAffiche[] =  {"Date","Pi&egrave;ce","Compte","Intitul&eacute;",  "Libell&eacute;",  "D&eacute;bit", "Cr&eacute;dit","Compte Auxiliaire","intitul&eacute; Auxiliaire","Lettrage","Analytique"};
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