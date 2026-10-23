<%-- 
    Document   : page-fiche-simple
    Created on : 9 mars 2023, 10:08:42
    Author     : BICI
--%>

<%@ page import="transport.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{
    String lien = (String) session.getValue("lien");
    CourseFilleLib t = new CourseFilleLib();
    t.setNomTable("CourseFilleLib");
    PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
    String id=pc.getBase().getTuppleID( );
    CourseFilleLib objet=(CourseFilleLib) pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idobjet").setLibelle("Objet");
    pc.getChampByName("datedepart").setLibelle("Date de d&eacute;part");
    pc.getChampByName("datearrivee").setLibelle("Date d'arriv&eacute;e");
    pc.getChampByName("heuredepart").setLibelle("Heure de d&eacute;part");
    pc.getChampByName("heurearrivee").setLibelle("Heure d'arriv&eacute;e");
    pc.getChampByName("idpersonnellib").setLibelle("Personnel");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idmere").setLibelle("Mere");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("idmere").setLien(lien+"?but=transport/course-fiche.jsp","id="+objet.getIdmere()+"&libelle=");
    pc.getChampByName("idpersonnel").setVisible(false);


    pc.setTitre("Fiche d'une d&eacute;tail course");
    String pageModif = "transport/course-fille-saisie.jsp";
    String pageDepart = "transport/course-fille-depart-saisie.jsp";
    String pageArrivee = "transport/course-fille-arrivee-saisie.jsp";
    String classe = "transport.CourseFilleLib";
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="#"><i class="fa fa-arrow-circle-left"></i></a>Fiche d'une d&eacute;tail course</h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("1")) { %>
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <a class="btn btn-danger pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=transport/course-saisie&classe="+classe %>" style="margin-right: 10px">Supprimer</a>
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("1")) { %>
                            <a class="btn btn-primary pull-right"  href="<%= lien + "?but="+ pageDepart +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Saisie d&eacute;part</a>
                            <% } else if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("7")) { %>
                            <a class="btn btn-primary pull-right"  href="<%= lien + "?but="+ pageArrivee +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Saisie arriv&eacute;e</a>
                            <% } %>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<%
} catch (Exception e) {
    e.printStackTrace();
} %>


