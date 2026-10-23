
<%@page import="paie.conge.Absence"%>
<%@page import="paie.conge.CongeDroit"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="paie.demande.DemandeJustifications" %>
<%@ page import="mg.cnaps.paie.PaiePersonnelElementpaie" %>
<%
    try{
        PaiePersonnelElementpaie lv = new PaiePersonnelElementpaie();
        lv.setNomTable("HS_GROUPE");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","matricule","nomPersonnel","hs_30_NI","hs_30_I","hs_50_NI","hs_50_I","date_debut","date_fin","etatlib"};
        PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and id_objet='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.setNpp(1000);
        pr.creerObjetPage(libEntete, colSomme);
%>
<div class="box-body">
    <%
        String libEnteteAffiche[] = {"Id","Matricule", "Personnel","HS 30% NI","HS 30% I","HS 50% NI","HS 50% I","Date de d&eacute;but", "Date de fin", "&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String lienTableau[] = {pr.getLien() + "?but=paie/fonction/paiepersonnelelementpaie-fiche.jsp",pr.getLien() };
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



