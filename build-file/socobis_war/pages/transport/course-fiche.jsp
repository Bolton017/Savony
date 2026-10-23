
<%@ page import="transport.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    try{
    //Information sur les navigations via la page
    String lien = (String) session.getValue("lien");
    String pageModif = "transport/course-saisie.jsp";
    String classe = "transport.CourseLib";
    String pageListe = "transport/course-liste.jsp";
    String pageActuel = "transport/course-fiche.jsp";

    //Information sur la fiche
    CourseLib t = new CourseLib();
    t.setNomTable("courselib");
    PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
    t = (CourseLib) pc.getBase();
    String id=request.getParameter("id");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idvehiculelib").setLibelle("V&eacute;hicule");
    pc.getChampByName("idchauffeurlib").setLibelle("Chauffeur");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("idvehicule").setVisible(false);
    pc.getChampByName("idchauffeur").setVisible(false);
    pc.getChampByName("etat").setVisible(false);


    pc.setTitre("Fiche d'une course");

    //Initialisation de l'objet onglet
    Onglet onglet =  new Onglet("course-detail");
    onglet.setDossier("inc");
    Map<String, String> map = new HashMap<String, String>();
    Map<String, String> listeNumero = new HashMap<String,String>();
    map.put("course-detail","");
    listeNumero.put("1","course-detail");
    onglet.setListePage(map);
    onglet.setListeNumero(listeNumero);
    String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "course-detail";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";
    String currentTab = onglet.getCurrentPage(tab);

%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=consulte/page-fiche-simple.jsp"><i class="fa fa-angle-left"></i></a>Fiche d'une course</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("1")) { %>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <a class="btn btn-danger pull-left" style="margin-right:10px" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=transport/course-saisie.jsp&classe="+classe %>">Supprimer</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("course-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=course-detail">D&eacute;tails</a></li>

                </ul>
                <div class="tab-content">       
                    <jsp:include page="<%= currentTab %>" >
                        <jsp:param name="idmere" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>


<%
} catch (Exception e) {
    e.printStackTrace();
}
%>
