<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="affichage.Onglet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="rapprochement.RapprochementBC" %>
<%@ page import="rapprochement.RapprochementDBMereLib" %> 

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    RapprochementDBMereLib o = new RapprochementDBMereLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche du rapprochement");
    String id = pc.getBase().getTuppleID();
    o = (RapprochementDBMereLib) pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idbanquelib").setLibelle("Banque");
    pc.getChampByName("valeur").setLibelle("Valeur");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("idbanque").setVisible(false);
    pc.getChampByName("etatlib").setVisible(false);

    String[] ordre = {"id","daty","idbanquelib","valeur"};
    pc.setOrdre(ordre);

    String pageRetour = "rapprochement/liste-rapprochement.jsp";
    String pageModif = ".jsp&acte=update";
    String pageApresDelete = ".jsp";
    String classe = "rapprochement.RapprochementDBMere";
    String pageActuel = "rapprochement/fiche-rapprochement.jsp";

    Onglet onglet = new Onglet("page1");
    onglet.setDossier("inc");
    Map<String, String> map = new HashMap<String, String>();
    map.put("rapprochement-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "rapprochement-details";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp"; 

%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

<div class="row m-0">
    <div class="col-md-3"></div>
    <div class="col-md-6">
        <div class="box-fiche">
            <div class="box">
                <div class="box-body">
                    <%
                        out.println(pc.getHtml());
                    %>
                    <br/>
                    <div class="box-footer">
                        <a class="btn btn-tertiary pull-left"  href="<%= lien + "?but="+ pageRetour %>" style="margin-right: 10px">Retour</a>
                        <% if(o.getEtat() == 1){ %>
                        <a class="btn btn-primary pull-right"
                           href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=rapprochement/fiche-rapprochement.jsp&classe=" + classe%> "
                           style="margin-right: 10px">valider </a>
                        <% } %>
<%--                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>--%>
<%--                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>--%>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row m-0">
    <div class="col-md-12 nopadding">
        <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
                <li class="<%=map.get("rapprochement-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=rapprochement-details">D&eacute;tails</a></li>
            </ul>
            <div class="tab-content">
                <jsp:include page="<%= tab%>">
                    <jsp:param name="idmere" value="<%= id%>" />
                </jsp:include>
            </div>
        </div>

    </div>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

