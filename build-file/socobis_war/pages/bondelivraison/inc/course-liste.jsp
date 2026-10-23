<%@page import="transport.*"%>
<%@page import="affichage.PageRecherche"%>

<% 
    try{ 
    CourseFilleLib t = new CourseFilleLib();
    t.setNomTable("COURSEFILLELIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","idmere","datedepart","datearrivee","remarque"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String id =request.getParameter("id");
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idobjet='"+id+"'");
    }
    String colonneLien[] = {"id","idmere"};
    String[] attributLien = {"id", "id"};
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>
<div class="box-body">
    <%
        String libEnteteAffiche[] = {"ID","Course" ,"Date de d&eacute;part","Date de arriv&eacute;e","Remarque"};
        String lienTableau[] = {pr.getLien() + "?but=transport/course-fille-fiche.jsp",pr.getLien() + "?but=transport/course-fiche.jsp"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %>          <center><h4>Aucune donne trouvee</h4></center><%
        }
    %>
    <div class="box-footer">

    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

