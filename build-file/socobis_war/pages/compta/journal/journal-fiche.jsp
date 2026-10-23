<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="mg.cnaps.compta.ComptaSousEcriture"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="user.UserEJB"%>
<%@page import="mg.cnaps.compta.Journal"%>
<%@ page import="affichage.Onglet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    Journal cj;
    UserEJB u;
%>
<%
try{
    u = (UserEJB) session.getAttribute("u");
    cj = new Journal();
    String[] libelleJornal = {"id", "code", "Description", "Compte"};
    PageConsulte pc = new PageConsulte(cj, request, (user.UserEJB) session.getValue("u"));
    pc.setLibAffichage(libelleJornal);
    pc.setTitre("Fiche Journal");


    String tabDefault="ecriture-liste";
    Onglet onglet =  new Onglet(tabDefault);
    onglet.setDossier("inc");
    Map<String, String> listePage = new HashMap<String, String>();
    Map<String, String> listeNumero = new HashMap<String,String>();
    listePage.put(tabDefault,"");
    listeNumero.put("1",tabDefault);
    onglet.setListePage(listePage);
    onglet.setListeNumero(listeNumero);
    String tab = request.getParameter("tab");
    String currentTab = onglet.getCurrentPage(tab);

    String lien = (String) session.getValue("lien");
    String bute=request.getParameter("but");
    String id=pc.getBase().getTuppleID();

    String pageModif = "compta/journal/journal-saisie.jsp?acte=update";
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=compta/journal/journal.jsp"%>></a><%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%= listePage.get("ecriture-liste") %>">
                        <a class="" aria-current="page" href="<%= lien %>?but=<%= bute %>&id=<%= pc.getBase().getTuppleID() %>&tab=1">&Eacute;critures</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= currentTab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
</div>


<%--    <%out.println(pc.getBasPage());%>--%>
<%
    }catch (Exception e){
        e.printStackTrace();
        throw e;
    }
%>