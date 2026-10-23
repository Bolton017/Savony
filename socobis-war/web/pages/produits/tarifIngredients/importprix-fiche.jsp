<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="produits.ImportPrix" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ImportPrix o = new ImportPrix();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("fzse");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("daty").setLibelle("Date");

    String[] ordre = {"id","desce","daty"};
    pc.setOrdre(ordre);

    String pageActuel = "produits/tarifIngredients/importprix-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = ".jsp&acte=update";
    String pageApresDelete = ".jsp";
    String classe = "produits.ImportPrix";

    Map<String, String> map = new HashMap<>();
    map.put("inc/tarifdetails", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/tarifdetails";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    // Export Excel
    String exportButtonHtml =
        "                <a id='export-btn-excel' class='btn btn-secondary btn-small btn-bg-white' href='#' onclick='exportExcelTarif()'>\n" +
        "                    <i class='material-symbols-rounded'>download</i> Exporter en excel\n" +
        "                </a>\n";
%>
<script>
    function exportExcelTarif() {
        // Récupération de l'ID du père
        var idValue = "<%= id %>";

        var exportUrl = "${pageContext.request.contextPath}/ExportExcel?action=import_prix_details"
            + "&idMere=" + encodeURIComponent(idValue);

        var exportButton = document.getElementById("export-btn-excel");
        exportButton.href = exportUrl;
        exportButton.click();
    }
</script>
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
<%--                    <div class="box-footer">--%>
<%--                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>--%>
<%--                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>--%>
<%--                    </div>--%>
                    <div class="box-footer">
                        <a id='export-btn-excel' class='btn btn-primary pull-right' href='#' onclick='exportExcelTarif()' style="margin-right: 10px">Exporter en excel
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row m-0">
    <div class="col-md-12 nopadding">
        <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
                <!-- Exemple d'onglet -->
                <li class="<%=map.get("inc/tarifdetails")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/tarifdetails">D&eacute;tails</a></li>
            </ul>
            <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
            </div>
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

