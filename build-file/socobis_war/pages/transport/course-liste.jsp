<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="transport.CourseLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="siege.Chauffeur" %>

<% try{ 
    CourseLib o = new CourseLib();
    o.setNomTable("COURSELIB");
    String[] listeCrt = {"id","idchauffeurlib"};
    String[] listeInt = {};
    String[] libEntete = {"id","daty","idvehiculelib","idchauffeurlib","remarque","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des courses");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("transport/course-liste.jsp");
    
    Liste[] liste = new Liste[1];
    Chauffeur liste0 = new Chauffeur();
    liste0.setNomTable("CHAUFFEUR");
    liste[0] = new Liste("idchauffeurlib",liste0,"nom","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idchauffeurlib").setLibelle("Idchauffeurlib");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=transport/course-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String[] libEnteteAffiche = {"Id","Daty","Idvehiculelib","Idchauffeurlib","Remarque","Etatlib"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

