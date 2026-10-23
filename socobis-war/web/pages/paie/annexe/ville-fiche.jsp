<%@page import="paie.annexe.VilleLib"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageConsulte"%>

<%
    try {
        UserEJB u = (user.UserEJB) session.getValue("u");
        String nomtable = "VILLELIB";

        VilleLib objet = new VilleLib();
        objet.setNomTable(nomtable);

        PageConsulte pc = new PageConsulte(objet, request, u);
        pc.setTitre("Fiche ville/commune");
        pc.getBase();

        pc.getChampByName("nom").setLibelle("Ville/Commune");
        pc.getChampByName("codePostal").setLibelle("Code postal");
        pc.getChampByName("idPaysLib").setLibelle("Pays");
%>
<div class="content-wrapper">
    <h1><%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
        String message = e.getMessage();
        if (message == null || message.trim().isEmpty()) {
            message = e.getClass().getName();
        }
        message = message.replace("\\", "\\\\").replace("'", "\\'").replace("\r", " ").replace("\n", " ");
%>
<script language="JavaScript">
    alert('<%=message%>');
    history.back();
</script>
<% } %>
