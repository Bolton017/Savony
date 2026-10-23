<%@page import="utilitaire.Utilitaire"%>
<html>
<%
    String champRet = request.getParameter("champReturn");
    String champUrl = request.getParameter("champUrl");
    String[] champs = Utilitaire.split(champRet, ";");
    String[] champsLien = Utilitaire.split(champUrl, ";");
%>

<script language="JavaScript">

    <% for (int i = 0; i < champs.length; i++) {

        if (champs[i] != null && champs[i].compareTo("") != 0 && request.getParameter(champsLien[i]) != null && !request.getParameter(champsLien[i]).equalsIgnoreCase("")) {
    %>
    window.opener.document
        .getElementById("<%= champs[i] %>")
        .value = "<%= request.getParameter(champsLien[i]) %>";
    <%
        }
    }
    %>
    window.close();
</script>
</html>