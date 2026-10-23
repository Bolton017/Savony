<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 17/12/2025
  Time: 13:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.DmdAchatLib" %>
<%
    try{
        DmdAchatLib o = new DmdAchatLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String[] libEntete = {"id", "daty","fournisseurlib","remarque","idMagasinLib","idCategorieLib","etatlib"};
        PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt,4, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idObjet='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String[] libEnteteAffiche = {"ID", "Date","Fournisseur","Fournisseur secondaire","Magasin","Cat&eacute;gorie","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
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
