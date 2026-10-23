<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 28/10/2025
  Time: 09:02
  To change this template use File | Settings | File Templates.
--%>
<%@page import="bean.CGenUtil"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageConsulte"%>
<%@ page import="paie.edition.PeriodePaie" %>
<%!
    PeriodePaie pp;
    PageConsulte pc;
    UserEJB u = null;
    String lien = null;
    String id = null;
%>
<%
    try {
        id = (request.getParameter("id") == null || request.getParameter("id").compareToIgnoreCase("") == 0) ? "" : request.getParameter("id");

        u = (UserEJB) session.getAttribute("u");
        lien = (String) session.getValue("lien");
        pp = new PeriodePaie();
        pp.setNomTable("PERIODEPAIELIB");
        pc = new PageConsulte(pp, request, (user.UserEJB) session.getValue("u"));
        pp = (PeriodePaie) pc.getBase();
        pc.setTitre("Fiche du p&eacute;riode de paie");
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("datedebut").setLibelle("Date de d&eacute;but");
        pc.getChampByName("datefin").setLibelle("Date de fin");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("moislib").setLibelle("Mois");
        pc.getChampByName("annee").setLibelle("Ann&eacute;e");
        pc.getChampByName("categorieLib").setLibelle("Cat&eacute;gorie");
        pc.getChampByName("mois").setVisible(false);
        pc.getChampByName("idcategoriepaie").setVisible(false);

        String[] ordre = {"id", "datedebut", "datefin", "moislib", "annee", "categorieLib", "etat"};
        pc.setOrdre(ordre);

%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=paie/editions/periodepaie-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a>Fiche du p&eacute;riode de paie</h1>
    <div class="row">
        <div class="col-md-12 mb-5">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <%
                                if (pp.getEtat() == 1) {
                            %>
                            <a class="btn btn-primary pull-right"  href="<%= lien + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=valider&bute=paie/editions/periodepaie-fiche.jsp&classe=paie.edition.PeriodePaie" style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=paie/editions/periodepaie-saisie.jsp&id=" + id%>&acte=update" style="margin-right: 10px">Modifier</a>
                            <% } %>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%=pc.getHtmlAttacherFichier()%>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>