
<%@page import="paie.conge.Absence"%>
<%@page import="paie.conge.CongeDroit"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="paie.demande.DemandeJustifications" %>
<%
try{
    DemandeJustifications lv = new DemandeJustifications();
    lv.setNomTable("DEMANDE_LIBCOMPLET");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"motif","typeabsencelib","duree","daty","datedepart","datefin","dateretour","etatlib","annuler"};
    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("idpersonnel") != null){
        pr.setAWhere(" and idpersonnel='"+request.getParameter("idpersonnel")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>
<div class="box-body">
<%
    String libEnteteAffiche[] = {"Motif", "Type d'absence", "dur&eacute;e", "Date de saisie", "Date de d&eacute;but","Date de fin","Date de retour" , "Etat","Annul&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=paie/demande" + "/demande-absence-fiche.jsp",pr.getLien() + "?but=paie/employe" + "/personnel-fiche-portrait.jsp"};
    String colonneLien[] = {"id","idpersonnel"};
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


