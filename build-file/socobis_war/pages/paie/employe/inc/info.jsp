<%@page import="paie.employe.PaieInfoPersonnelLib"%>
<%@page import="paie.employe.PaieInfoPersonnel"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRecherche"%>
<%  
try{
    PaieInfoPersonnelLib lv = new PaieInfoPersonnelLib();
    lv.setNomTable("paie_info_personnel_lib3");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "matricule", "lieu_naissance_commune", "lieu_delivrance_cin", "situation_matrimonial", "cturgence_nom_prenom","cturgence_telephone1"};
    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("idpersonnel") != null){
        pr.setAWhere(" and id='"+request.getParameter("idpersonnel")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>
<div class="box-body">
<%
    String libEnteteAffiche[] = {"id", "matricule", "Lieu de Naissance", "Lieu de d&eacute;livrance CIN", "situation matrimoniale", "Nom du contact d'urgence","Num&eacute;ro du contact d'urgence"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=employe/infopersonnel-fiche.jsp"};
    String colonneLien[] = {"id"};
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



