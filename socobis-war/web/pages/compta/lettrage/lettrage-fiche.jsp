<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="utilitaire.*"%>
<%@page import="mg.cnaps.compta.ComptaSousEcriture"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="user.UserEJB"%>
<%@page import="mg.cnaps.compta.ComptaLettrage"%>
<%@ page import="affichage.Onglet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    ComptaLettrage lettrage;
    UserEJB u;
%>
<%
try{
    u = (UserEJB) session.getAttribute("u");
    lettrage = new ComptaLettrage();
    String[] libelleLettrageFiche = {"id", "lettre", "date de lettrage", "montant", "Remarque", "iduser", "&eacute;tat"};
    PageConsulte pc = new PageConsulte(lettrage, request, (user.UserEJB) session.getValue("u"));//ou avec argument liste Libelle si besoin
    pc.setLibAffichage(libelleLettrageFiche);
    pc.getChampByName("iduser").setVisible(false);
    pc.setTitre("Fiche Lettrage");


    String tabDefault="/../../../compta/ecriture/inc/sous-ecriture-detail";
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
    ComptaLettrage base = (ComptaLettrage) pc.getBase();

%>
<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=compta/lettrage/lettrage-liste.jsp"%>></a><%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                                <% if(base.getEtat()==ConstanteEtat.getEtatCreer()){ %>
                               <a class="btn btn-danger"
                                  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=delete&bute=compta/lettrage/lettrage-liste.jsp&classe=mg.cnaps.compta.ComptaLettrage&nomtable=COMPTA_LETTRAGE"
                                    style="margin-right: 10px">D&eacute;lettrer
                                </a>
                                <a class="btn btn-primary pull-right"  href="<%=lien + "?but=apresTarif.jsp&id=" + base.getId()%>&acte=valider&bute=compta/lettrage/lettrage-fiche.jsp&id=<%=base.getId()%>&classe=mg.cnaps.compta.ComptaLettrage&nomtable=COMPTA_LETTRAGE" style="margin-right: 10px">Viser</a>
                                <%} %>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%= listePage.get("/../../../compta/ecriture/inc/sous-ecriture-detail") %>">
                        <a class="" aria-current="page" href="<%= lien %>?but=<%= bute %>&id=<%= pc.getBase().getTuppleID() %>&tab=1">Liste des sous-écritures</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= currentTab %>" >
                        <jsp:param name="lettrage" value="<%= id %>" />
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