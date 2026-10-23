<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@ page import="fabrication.ProcessLib" %>
<%
    try{
        ProcessLib t = new ProcessLib();
        t.setNomTable("processLIB");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"datehistorique","heure","action", "acteur", "remarque", "ecart","ecartMinutes"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and refobjet='"+request.getParameter("id")+"' order by datehistorique desc, idhistorique desc");
        }
        String[] colSomme = {"ecartMinutes"};
        String[] enteteRecap = {"","nombre","Dur&eacute;e totale (en minutes)"};
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableauRecap().setLibeEntete(enteteRecap);
%>

<div class="box-body">
    <%
        /*String lienTableau[] = {pr.getLien() + "?but=rdv/rdvvoiture-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);*/
        String libEnteteAffiche[] =   {"date","heure","action", "acteur", "remarque","&Eacute;cart(s)","&Eacute;cart (min)"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableauRecap().getHtml());
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><div style="text-align: center;"><h4>Aucun donn&eacute; trouv&eacute;</h4></div><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
