<%@page import="paie.employe.PaieInfoPersonnelLib"%>
<%@page import="paie.employe.PaieInfoPersonnel"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRecherche"%>
<%  
try{
    PaieInfoPersonnelLib lv = new PaieInfoPersonnelLib();
    lv.setNomTable("paie_info_personnel_lib4");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "matricule", "dateembauche", "idfonction", "typecontrat","debutcontrat", "fincontrat","mode_paiement", "code_agence_banque", "banque_numero_compte", "banque_compte_cle"};
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
    String libEnteteAffiche[] = {"id", "matricule", "Date d'embauche", "fonction", "Type de contrat","Date de d&eacutebut du contrat", "Date de fin du contrat","mode de paiement", "Agence bancaire", "Num&eacute;ro de compte bancaire", "Compte Cl&eacute; Banque"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=paie/contrat/contrat-fiche.jsp"};
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



