<%-- 
    Document   : onglet-exemple
    Created on : 9 mars 2023, 11:28:01
    Author     : BICI
--%>
<%@ page import="transport.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    CourseFilleLib t = new CourseFilleLib();
    t.setNomTable("CourseFilleLib");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "datedepart","heuredepart","datearrivee","heurearrivee","idpersonnellib","remarque"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }
    pr.setApres("#");
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=transport/course-fille-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        String libEnteteAffiche[] =  {"Id", "Date de d&eacute;part","heure de d&eacute;part","Date d'arriv&eacute;e","Heure d'arriv&eacute;e","Personnel","Remarque"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        CourseFilleLib[] liste=(CourseFilleLib[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
            {
               %><center><h4>Aucune donnée trouvé</h4></center><%
        }
    %>
            

   

</div>