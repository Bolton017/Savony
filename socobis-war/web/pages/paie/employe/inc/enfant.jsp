<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.employe.EnfantPersonnelCpl" %>
<%
    try{
        EnfantPersonnelCpl o = new EnfantPersonnelCpl();
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"id","nom","dateNaissance","age","genreLib"};
        PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setAWhere(" AND IDPERSONNEL ='"+request.getParameter("id")+"'");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>
<div class="box-body">
    <%
        String[] libEnteteAffiche = {"ID","Nom & Pr&eacute;nom","Date de naissance","&Acirc;ge","Genre"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String[] lienTableau = {pr.getLien() + "?but=paie/employe/enfantpersonne-fiche.jsp"};
        String[] colonneLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {%>
    <div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }%>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>



